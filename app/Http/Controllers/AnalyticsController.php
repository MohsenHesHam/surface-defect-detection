<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\AIService;
use App\Models\Scan;

class AnalyticsController extends Controller
{
    protected $ai;

    public function __construct(AIService $ai)
    {
        $this->ai = $ai;
    }

    // Dashboard summary
    public function summary(Request $request)
    {
        $data = $this->ai->analyticsSummary();
        return response()->json($data, 200);
    }

    // Detailed report for a scan (or latest if none specified)
    public function report(Request $request, $scanId = null)
    {
        $scan = $scanId ? Scan::with(['images', 'statistics'])->find($scanId) : Scan::with(['images', 'statistics'])->latest()->first();
        if (!$scan) {
            return response()->json(['message' => 'Scan not found'], 404);
        }

        $report = $this->ai->analyzeScan($scan);

        // Example chart data for weekly overview (simulate)
        $chart = [
            'labels' => [],
            'values' => [],
        ];
        for ($i = 6; $i >= 0; $i--) {
            $date = now()->subDays($i)->format('Y-m-d');
            $chart['labels'][] = $date;
            $chart['values'][] = rand(0, 100);
        }

        return response()->json([
            'report' => $report,
            'weekly_overview' => $chart,
        ], 200);
    }

    // History: return defect categories with counts and recent activity
    public function history(Request $request)
    {
        $data = $this->ai->analyticsSummary();

        // recent activity from activities table
        $activities = \App\Models\Activity::latest()->limit(10)->get()->map(function ($a) {
            return [
                'id' => $a->id,
                'user_id' => $a->user_id,
                'title' => $a->title,
                'description' => $a->description,
                'status' => $a->status,
                'created_at' => $a->created_at->toDateTimeString(),
            ];
        });

        return response()->json([
            'defect_categories' => $data['defects_by_category'],
            'recent_activity' => $activities,
        ], 200);
    }
}
