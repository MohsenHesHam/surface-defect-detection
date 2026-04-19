<?php

namespace App\Http\Controllers;

use App\Models\ScanStatistic;
use Illuminate\Http\Request;

class ScanStatisticController extends Controller
{
    /**
     * Display a listing of the resource.
     * Admin sees all statistics, users see only their own scan statistics
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'admin') {
            return response()->json(ScanStatistic::with('scan')->get(), 200);
        }

        return response()->json(
            ScanStatistic::whereHas('scan', function ($query) use ($user) {
                $query->where('user_id', $user->id);
            })->with('scan')->get(),
            200
        );
    }

    /**
     * Store a newly created resource in storage.
     * Admin only (statistics are created automatically during scan processing)
     */
    public function store(Request $request)
    {
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'message' => 'Unauthorized. Admin access required.'
            ], 403);
        }

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
     * Admin can view any statistic, users can only view their own scan statistics
     */
    public function show(Request $request, ScanStatistic $scanStatistic)
    {
        if ($request->user()->role !== 'admin' && $scanStatistic->scan->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only view statistics from your own scans.'
            ], 403);
        }

        return response()->json($scanStatistic->load('scan'), 200);
    }

    /**
     * Update the specified resource in storage.
     * Admin can update any, users can only update their own scan statistics
     */
    public function update(Request $request, ScanStatistic $scanStatistic)
    {
        if ($request->user()->role !== 'admin' && $scanStatistic->scan->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only update statistics from your own scans.'
            ], 403);
        }

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
     * Admin can delete any, users can only delete their own scan statistics
     */
    public function destroy(Request $request, ScanStatistic $scanStatistic)
    {
        if ($request->user()->role !== 'admin' && $scanStatistic->scan->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only delete statistics from your own scans.'
            ], 403);
        }

        $scanStatistic->delete();

        return response()->json(null, 204);
    }
}
