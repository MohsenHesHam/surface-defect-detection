<?php

namespace App\Http\Controllers;

use App\Models\ImageDefect;
use Illuminate\Http\Request;

class ImageDefectController extends Controller
{
    /**
     * Display a listing of the resource.
     * Admin sees all defects, users see only their scan defects
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'admin') {
            return response()->json(ImageDefect::with(['image', 'defectCategory'])->get(), 200);
        }

        // Users see only defects from their own scan images
        return response()->json(
            ImageDefect::whereHas('image', function ($query) use ($user) {
                $query->whereHas('scan', function ($subquery) use ($user) {
                    $subquery->where('user_id', $user->id);
                });
            })->with(['image', 'defectCategory'])->get(),
            200
        );
    }

    /**
     * Store a newly created resource in storage.
     * Admin only (users' defects are created automatically during scan processing)
     */
    public function store(Request $request)
    {
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'message' => 'Unauthorized. Admin access required.'
            ], 403);
        }

        $validated = $request->validate([
            'image_id' => 'required|exists:images,id',
            'defect_category_id' => 'required|exists:defect_categories,id',
            'confidence' => 'nullable|numeric|min:0|max:100',
            'bounding_box' => 'nullable|array',
        ]);

        $defect = ImageDefect::create($validated);

        return response()->json($defect->load(['image', 'defectCategory']), 201);
    }

    /**
     * Display the specified resource.
     * Admin can view any defect, users can only view their own scan defects
     */
    public function show(Request $request, ImageDefect $imageDefect)
    {
        if ($request->user()->role !== 'admin' && $imageDefect->image->scan->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only view defects from your own scan images.'
            ], 403);
        }

        return response()->json($imageDefect->load(['image', 'defectCategory']), 200);
    }

    /**
     * Update the specified resource in storage.
     * Admin can update any, users can only update their own scan defects
     */
    public function update(Request $request, ImageDefect $imageDefect)
    {
        if ($request->user()->role !== 'admin' && $imageDefect->image->scan->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only update defects from your own scan images.'
            ], 403);
        }

        $validated = $request->validate([
            'confidence' => 'nullable|numeric|min:0|max:100',
            'bounding_box' => 'nullable|array',
        ]);

        $imageDefect->update($validated);

        return response()->json($imageDefect->load(['image', 'defectCategory']), 200);
    }

    /**
     * Remove the specified resource from storage.
     * Admin can delete any, users can only delete their own scan defects
     */
    public function destroy(Request $request, ImageDefect $imageDefect)
    {
        if ($request->user()->role !== 'admin' && $imageDefect->image->scan->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only delete defects from your own scan images.'
            ], 403);
        }

        $imageDefect->delete();

        return response()->json(null, 204);
    }
}
