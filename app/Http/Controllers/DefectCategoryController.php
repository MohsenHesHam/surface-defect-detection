<?php

namespace App\Http\Controllers;

use App\Models\DefectCategory;
use Illuminate\Http\Request;

class DefectCategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(DefectCategory::all(), 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:defect_categories',
            'description' => 'nullable|string',
            'severity_level' => 'nullable|string|in:low,medium,high,critical',
        ]);

        $category = DefectCategory::create($validated);

        return response()->json($category, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(DefectCategory $defectCategory)
    {
        return response()->json($defectCategory, 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, DefectCategory $defectCategory)
    {
        $validated = $request->validate([
            'name' => 'nullable|string|max:255|unique:defect_categories,name,' . $defectCategory->id,
            'description' => 'nullable|string',
            'severity_level' => 'nullable|string|in:low,medium,high,critical',
        ]);

        $defectCategory->update($validated);

        return response()->json($defectCategory, 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(DefectCategory $defectCategory)
    {
        $defectCategory->delete();

        return response()->json(null, 204);
    }
}
