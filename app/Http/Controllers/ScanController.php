<?php

namespace App\Http\Controllers;

use App\Models\Scan;
use App\Models\Image;
use App\Models\ImageDefect;
use App\Models\DefectCategory;
use App\Models\ScanStatistic;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Client\Response as HttpResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ScanController extends Controller
{
    use ApiResponse;
    /**
     * Display a listing of the resource.
     * Admin sees all scans, users see only their own
     */
    public function index(Request $request)
    {
        try {
            $user = $request->user();
            $perPage = $request->query('per_page');

            if ($user->role === 'admin') {
                $query = Scan::with(['user', 'images', 'statistics']);
            } else {
                $query = Scan::where('user_id', $user->id)->with(['user', 'images', 'statistics']);
            }

            if ($request->has('page') || $perPage !== null) {
                $perPage = $perPage ? (int) $perPage : 15;
                $scans = $query->paginate($perPage);
                return $this->paginatedResponse($scans, 'Scans retrieved successfully');
            }

            return $this->listResponse($query->get(), 'Scans retrieved successfully');
        } catch (\Exception $e) {
            return $this->errorResponse($e->getMessage(), 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     * Admin can create for any user, regular user can only create for themselves
     */
    public function store(Request $request)
    {
        try {
            $user = $request->user();

            // Validate input
            $validated = $request->validate([
                'user_id' => 'required|exists:users,id',
                'scan_type' => 'required|string|max:255',
                'total_images' => 'nullable|integer|min:0',
                'status' => 'nullable|string|in:pending,processing,completed,failed',
            ]);

            // Regular users can only create scans for themselves
            if ($user->role !== 'admin' && $validated['user_id'] != $user->id) {
                return $this->errorResponse('Unauthorized. You can only create scans for yourself.', 403);
            }

            $scan = Scan::create(array_merge($validated, ['status' => $validated['status'] ?? 'pending']));

            // handle uploaded images if provided
            $uploadedCount = 0;
            if ($request->hasFile('images')) {
                foreach ($request->file('images') as $file) {
                    if (!$file->isValid()) {
                        continue;
                    }
                    $filename = Str::random(24) . '.' . $file->getClientOriginalExtension();
                    $path = $file->storeAs('images', $filename, 'public');
                    $imagePath = Storage::url($path);

                    Image::create([
                        'scan_id' => $scan->id,
                        'image_path' => $imagePath,
                        'processed_image_path' => null,
                        'file_size' => $file->getSize(),
                    ]);

                    $uploadedCount++;
                }
            }

            // update total_images
            if ($uploadedCount > 0) {
                $scan->update(['total_images' => $uploadedCount]);
            }

            // simulate processing: create defects and statistics
            $this->processScan($scan);

            return $this->successResponse($scan->load(['user', 'images', 'statistics']), 'Scan created successfully', 201);
        } catch (\Exception $e) {
            return $this->errorResponse($e->getMessage(), 500);
        }
    }

    /**
     * Simple scan processing simulation - creates defects and statistics
     */
    protected function processScan(Scan $scan)
    {
        $images = $scan->images;
        $totalDefects = 0;

        // get some defect categories to assign (fallback: create default)
        $categories = DefectCategory::all();
        if ($categories->isEmpty()) {
            $categories = collect([DefectCategory::create(['name' => 'Unknown', 'description' => 'Auto generated', 'severity_level' => 'medium'])]);
        }

        foreach ($images as $image) {
            // create 0..2 defects per image
            $defectCount = rand(0, 2);
            for ($i = 0; $i < $defectCount; $i++) {
                $cat = $categories->random();
                ImageDefect::create([
                    'image_id' => $image->id,
                    'defect_category_id' => $cat->id,
                    'confidence' => rand(50, 99) + (rand(0,99)/100),
                    'bounding_box' => [
                        'x' => rand(0, 400),
                        'y' => rand(0, 400),
                        'width' => rand(10, 200),
                        'height' => rand(10, 200),
                    ],
                ]);
                $totalDefects++;
            }

            // set processed image path placeholder
            $image->update(['processed_image_path' => $image->image_path]);
        }

        $defectCount = $totalDefects;
        $totalImages = $images->count();
        $passedCount = max(0, $totalImages - $defectCount);
        $accuracy = $totalImages > 0 ? round((($passedCount) / $totalImages) * 100, 2) : 0;

        ScanStatistic::create([
            'scan_id' => $scan->id,
            'total_defects' => $totalDefects,
            'passed_count' => $passedCount,
            'defect_count' => $defectCount,
            'accuracy' => $accuracy,
            'processing_time' => rand(10, 300),
        ]);

        $scan->update(['status' => 'completed', 'completed_at' => now()]);
    }

    /**
     * Display the specified resource.
     * Admin can view any scan, users can only view their own
     */
    public function show(Request $request, Scan $scan)
    {
        try {
            if ($request->user()->role !== 'admin' && $scan->user_id !== $request->user()->id) {
                return $this->errorResponse('Unauthorized. You can only view your own scans.', 403);
            }

            return $this->successResponse($scan->load(['user', 'images', 'statistics']), 'Scan retrieved successfully', 200);
        } catch (\Exception $e) {
            return $this->errorResponse($e->getMessage(), 500);
        }
    }

    /**
     * Update the specified resource in storage.
     * Admin can update any scan, users can only update their own
     */
    public function update(Request $request, Scan $scan)
    {
        try {
            if ($request->user()->role !== 'admin' && $scan->user_id !== $request->user()->id) {
                return $this->errorResponse('Unauthorized. You can only update your own scans.', 403);
            }

            $validated = $request->validate([
                'scan_type' => 'nullable|string|max:255',
                'total_images' => 'nullable|integer|min:0',
                'status' => 'nullable|string|in:pending,processing,completed,failed',
                'completed_at' => 'nullable|date',
            ]);

            $scan->update($validated);

            return $this->successResponse($scan->load(['user', 'images', 'statistics']), 'Scan updated successfully', 200);
        } catch (\Exception $e) {
            return $this->errorResponse($e->getMessage(), 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     * Admin can delete any scan, users can only delete their own
     */
    public function destroy(Request $request, Scan $scan)
    {
        try {
            if ($request->user()->role !== 'admin' && $scan->user_id !== $request->user()->id) {
                return $this->errorResponse('Unauthorized. You can only delete your own scans.', 403);
            }

            $scan->delete();

            return response()->json(null, 204);
        } catch (\Exception $e) {
            return $this->errorResponse($e->getMessage(), 500);
        }
    }

    /**
     * Detect defects in an uploaded image using FastAPI service
     */
    public function detectDefect(Request $request)
    {
        try {
            $validated = $request->validate([
                'scan_id' => 'nullable|exists:scans,id',
                'image' => 'required|image|mimes:jpeg,png,jpg,gif|max:10240', // 10MB max
            ]);

            $user = $request->user();
            $image = $request->file('image');
            $scan = null;

            if (!empty($validated['scan_id'])) {
                $scan = Scan::findOrFail($validated['scan_id']);

                if ($user->role !== 'admin' && $scan->user_id !== $user->id) {
                    return $this->errorResponse('Unauthorized. You can only run detection on your own scans.', 403);
                }
            } else {
                $scan = Scan::create([
                    'user_id' => $user->id,
                    'scan_type' => 'ai_detection',
                    'total_images' => 0,
                    'status' => 'processing',
                ]);
            }

            // Call FastAPI service
            $fastapiUrl = env('FASTAPI_URL', 'http://localhost:8001'); // Use different port

            /** @var HttpResponse $response */
            $response = \Illuminate\Support\Facades\Http::timeout(30)->attach(
                'file', file_get_contents($image->getRealPath()), $image->getClientOriginalName()
            )->post($fastapiUrl . '/predict');

            if ($response->failed()) {
                return $this->errorResponse('Defect detection service unavailable', 503);
            }

            $result = $response->json();
            $savedData = DB::transaction(function () use ($image, $result, $scan) {
                $filename = Str::random(24) . '.' . $image->getClientOriginalExtension();
                $path = $image->storeAs('images', $filename, 'public');
                $imagePath = Storage::url($path);

                $processedImagePath = null;
                if (!empty($result['annotated_image'])) {
                    $processedFilename = Str::random(24) . '_annotated.jpg';
                    $processedRelativePath = 'images/' . $processedFilename;
                    Storage::disk('public')->put($processedRelativePath, base64_decode($result['annotated_image']));
                    $processedImagePath = Storage::url($processedRelativePath);
                }

                $resolution = null;
                $dimensions = @getimagesize($image->getRealPath());
                if ($dimensions !== false) {
                    $resolution = $dimensions[0] . 'x' . $dimensions[1];
                }

                $savedImage = Image::create([
                    'scan_id' => $scan->id,
                    'image_path' => $imagePath,
                    'processed_image_path' => $processedImagePath,
                    'file_size' => $image->getSize(),
                    'resolution' => $resolution,
                ]);

                $predictedClass = $result['class'] ?? 'unknown';
                $defectCategory = DefectCategory::firstOrCreate(
                    ['name' => $predictedClass],
                    [
                        'description' => 'Auto-created from AI detection result',
                        'severity_level' => 'medium',
                    ]
                );

                $savedDefect = ImageDefect::create([
                    'image_id' => $savedImage->id,
                    'defect_category_id' => $defectCategory->id,
                    'confidence' => $result['confidence'] ?? null,
                    'bounding_box' => isset($result['bbox'])
                        ? [
                            'x' => $result['bbox'][0] ?? null,
                            'y' => $result['bbox'][1] ?? null,
                            'width' => $result['bbox'][2] ?? null,
                            'height' => $result['bbox'][3] ?? null,
                        ]
                        : null,
                ]);

                $totalImages = $scan->images()->count();
                $totalDefects = ImageDefect::whereHas('image', function ($query) use ($scan) {
                    $query->where('scan_id', $scan->id);
                })->count();

                $passedCount = max(0, $totalImages - $totalDefects);
                $accuracy = $totalImages > 0 ? round(($passedCount / $totalImages) * 100, 2) : 0;

                $statistics = ScanStatistic::updateOrCreate(
                    ['scan_id' => $scan->id],
                    [
                        'total_defects' => $totalDefects,
                        'passed_count' => $passedCount,
                        'defect_count' => $totalDefects,
                        'accuracy' => $accuracy,
                        'processing_time' => 0,
                    ]
                );

                $scan->update([
                    'status' => 'completed',
                    'completed_at' => now(),
                    'total_images' => $totalImages,
                ]);

                return [
                    'scan' => $scan->fresh(),
                    'image' => $savedImage->fresh(),
                    'image_defect' => $savedDefect->fresh(),
                    'statistics' => $statistics->fresh(),
                ];
            });

            return $this->successResponse([
                'prediction' => $result,
                'saved_records' => $savedData,
            ], 'Defect detection completed successfully');
        } catch (\Exception $e) {
            return $this->errorResponse($e->getMessage(), 500);
        }
    }
}
