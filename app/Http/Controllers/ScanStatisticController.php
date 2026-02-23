<?php

namespace App\Http\Controllers;

use App\Models\ScanStatistic;
use Illuminate\Http\Request;

class ScanStatisticController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(ScanStatistic::with('scan')->get(), 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'scan_id' => 'required|exists:scans,id',
            'total_defects' => 'nullable|integer|min:0',
            'passed_count' => 'nullable|integer|min:0',
            'defect_count' => 'nullable|integer|min:0',
            'accuracy' => 'nullable|numeric|min:0|max:100',
            'processing_time' => 'nullable|integer|min:0',
        ]);

        $statistic = ScanStatistic::create($validated);

        return response()->json($statistic->load('scan'), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(ScanStatistic $scanStatistic)
    {
        return response()->json($scanStatistic->load('scan'), 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, ScanStatistic $scanStatistic)
    {
        $validated = $request->validate([
            'total_defects' => 'nullable|integer|min:0',
            'passed_count' => 'nullable|integer|min:0',
            'defect_count' => 'nullable|integer|min:0',
            'accuracy' => 'nullable|numeric|min:0|max:100',
            'processing_time' => 'nullable|integer|min:0',
        ]);

        $scanStatistic->update($validated);

        return response()->json($scanStatistic->load('scan'), 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(ScanStatistic $scanStatistic)
    {
        $scanStatistic->delete();

        return response()->json(null, 204);
    }
}
