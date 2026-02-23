<?php

namespace App\Http\Controllers;

use App\Models\Scan;
use App\Models\Image;
use App\Models\ImageDefect;
use App\Models\DefectCategory;
use App\Models\ScanStatistic;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ScanController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(Scan::with(['user', 'images', 'statistics'])->get(), 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'scan_type' => 'required|string|max:255',
            'total_images' => 'nullable|integer|min:0',
            'status' => 'nullable|string|in:pending,processing,completed,failed',
        ]);

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

                $image = Image::create([
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

        return response()->json($scan->load(['user', 'images', 'statistics']), 201);
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
                    'bounding_box' => json_encode(['x' => rand(0,400), 'y' => rand(0,400), 'width' => rand(10,200), 'height' => rand(10,200)]),
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
     */
    public function show(Scan $scan)
    {
        return response()->json($scan->load(['user', 'images', 'statistics']), 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Scan $scan)
    {
        $validated = $request->validate([
            'scan_type' => 'nullable|string|max:255',
            'total_images' => 'nullable|integer|min:0',
            'status' => 'nullable|string|in:pending,processing,completed,failed',
            'completed_at' => 'nullable|date',
        ]);

        $scan->update($validated);

        return response()->json($scan->load(['user', 'images', 'statistics']), 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Scan $scan)
    {
        $scan->delete();

        return response()->json(null, 204);
    }
}
