<?php

namespace App\Http\Controllers;

use App\Models\ImageDefect;
use Illuminate\Http\Request;

class ImageDefectController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(ImageDefect::with(['image', 'defectCategory'])->get(), 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
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
     */
    public function show(ImageDefect $imageDefect)
    {
        return response()->json($imageDefect->load(['image', 'defectCategory']), 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, ImageDefect $imageDefect)
    {
        $validated = $request->validate([
            'confidence' => 'nullable|numeric|min:0|max:100',
            'bounding_box' => 'nullable|array',
        ]);

        $imageDefect->update($validated);

        return response()->json($imageDefect->load(['image', 'defectCategory']), 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(ImageDefect $imageDefect)
    {
        $imageDefect->delete();

        return response()->json(null, 204);
    }
}
