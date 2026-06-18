<?php

namespace App\Http\Controllers;

use App\Models\Scan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Schema;

class UserStatisticController extends Controller
{
    protected function userScansWithRelations(int $userId)
    {
        return Scan::where('user_id', $userId)
            ->with([
                'images.defects.defectCategory',
                'statistics',
            ])
            ->orderByDesc('created_at')
            ->get();
    }

    /**
     * Lifetime analytics for the authenticated user.
     * GET /api/user-statistics/analytics
     */
    public function analytics(Request $request)
    {
        $user = $request->user();

        $scans = Scan::where('user_id', $user->id)
            ->with(['images.defects'])
            ->get();

        // passedCount: total scan operations done by the user.
        $passedCount = $scans->count();

        $allImages = $scans->flatMap(fn (Scan $scan) => $scan->images);
        $allDefects = $allImages->flatMap(fn ($image) => $image->defects);

        // defectCount: number of images that contain at least one defect.
        $defectCount = $allImages->filter(fn ($image) => $image->defects->isNotEmpty())->count();

        // totalDefects: total defect records across all images.
        $totalDefects = $allDefects->count();

        // accuracy: sum(confidant|confidence) / passedCount
        $scoreColumn = Schema::hasColumn('image_defects', 'confidant') ? 'confidant' : 'confidence';
        $totalScore = $allDefects->sum(fn ($defect) => (float) ($defect->{$scoreColumn} ?? 0));
        $accuracy = $passedCount > 0 ? round($totalScore / $passedCount, 2) : 0.0;

        // successRate: successful scans / total scans * 100
        $successfulScans = $scans->where('status', 'completed')->count();
        $successRate = $passedCount > 0 ? round(($successfulScans / $passedCount) * 100, 2) : 0.0;

        return response()->json([
            'passedCount' => $passedCount,
            'defectCount' => $defectCount,
            'totalDefects' => $totalDefects,
            'accuracy' => $accuracy,
            'successRate' => $successRate,
        ], 200);
    }

    /**
     * Alias for dashboard cards.
     * GET /api/user-statistics/dashboard
     */
    public function dashboard(Request $request)
    {
        return $this->analytics($request);
    }

    /**
     * History data for the authenticated user.
     * GET /api/user-statistics/history
     */
    public function history(Request $request)
    {
        $user = $request->user();

        $scans = $this->userScansWithRelations($user->id);

        $allDefects = $scans
            ->flatMap(fn (Scan $scan) => $scan->images)
            ->flatMap(fn ($image) => $image->defects);

        $totalCases = $allDefects->count();

        $defectCategories = $allDefects
            ->groupBy('defect_category_id')
            ->map(function ($defects) use ($totalCases) {
                $first = $defects->first();
                $name = $first?->defectCategory?->name ?? 'Unknown';
                $cases = $defects->count();

                return [
                    'name' => $name,
                    'cases' => $cases,
                    'percentage' => $totalCases > 0 ? round(($cases / $totalCases) * 100, 2) : 0.0,
                    'progress' => $totalCases > 0 ? round(($cases / $totalCases) * 100, 2) : 0.0,
                ];
            })
            ->values()
            ->sortByDesc('cases')
            ->values();

        return response()->json([
            'title' => 'Defect Categories',
            'subtitle' => 'This week\'s distribution',
            'defectCategories' => $defectCategories,
            'totalCases' => $totalCases,
        ], 200);
    }

    /**
     * Recent activity feed for the authenticated user.
     * GET /api/user-statistics/recent_activity
     */
    public function recentActivity(Request $request)
    {
        $user = $request->user();
        $scans = $this->userScansWithRelations($user->id);

        $recentActivity = $scans->take(10)->map(function (Scan $scan) {
            return [
                'scanId' => $scan->id,
                'scanType' => $scan->scan_type,
                'status' => $scan->status,
                'totalImages' => (int) ($scan->total_images ?? $scan->images->count()),
                'totalDefects' => (int) ($scan->statistics->total_defects ?? $scan->images->sum(fn ($image) => $image->defects->count())),
                'createdAt' => optional($scan->created_at)->toDateTimeString(),
            ];
        })->values();

        return response()->json([
            'title' => 'Recent Activity',
            'subtitle' => 'Latest scan results',
            'recentActivity' => $recentActivity,
        ], 200);
    }
}
