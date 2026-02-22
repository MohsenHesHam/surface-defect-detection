<?php

namespace App\Services;

use App\Models\Scan;
use App\Models\ScanStatistic;
use App\Models\ImageDefect;
use App\Models\DefectCategory;

/**
 * AIService is a small abstraction to call an external AI model.
 * Currently it simulates analysis using DB data. Replace the simulate* methods
 * with real model calls when available.
 */
class AIService
{
    /**
     * Simulate analyzing a scan and returning a detailed report structure
     */
    public function analyzeScan(Scan $scan): array
    {
        // Prefer existing statistics if present
        $stats = $scan->statistics()->first();

        // defect breakdown from image_defects
        $defects = ImageDefect::whereIn('image_id', $scan->images()->pluck('id'))->get();
        $byCategory = [];
        $totalDefects = $defects->count();
        $categories = DefectCategory::all()->keyBy('id');

        foreach ($defects as $d) {
            $catName = $categories->has($d->defect_category_id) ? $categories[$d->defect_category_id]->name : 'Unknown';
            if (!isset($byCategory[$catName])) $byCategory[$catName] = 0;
            $byCategory[$catName]++;
        }

        $breakdown = [];
        foreach ($byCategory as $name => $count) {
            $breakdown[] = [
                'name' => $name,
                'count' => $count,
                'percentage' => $totalDefects > 0 ? round(($count / $totalDefects) * 100, 2) : 0,
            ];
        }

        // build high-level report
        $report = [
            'scan_id' => $scan->id,
            'scan_type' => $scan->scan_type,
            'total_images' => $scan->total_images,
            'total_defects' => $stats ? $stats->total_defects : $totalDefects,
            'defect_breakdown' => $breakdown,
            'accuracy' => $stats ? $stats->accuracy : ($scan->total_images ? 100 : 0),
            'processing_time' => $stats ? $stats->processing_time : null,
            'generated_at' => now()->toDateTimeString(),
        ];

        return $report;
    }

    /**
     * Simulate analytics summary for dashboard
     */
    public function analyticsSummary(): array
    {
        $totalScans = Scan::count();
        $totalImages = 
            
            \App\Models\Image::count();
        $totalDefects = ImageDefect::count();

        // accuracy - average of scan accuracies
        $avgAccuracy = ScanStatistic::avg('accuracy') ?: 0;

        // recent scans
        $recent = Scan::with('user')->orderBy('created_at', 'desc')->limit(6)->get()->map(function ($s) {
            return [
                'id' => $s->id,
                'user' => $s->user ? $s->user->full_name : null,
                'type' => $s->scan_type,
                'status' => $s->status,
                'created_at' => $s->created_at->toDateTimeString(),
            ];
        });

        // defect counts per category
        $categories = DefectCategory::all();
        $byCategory = [];
        foreach ($categories as $c) {
            $count = ImageDefect::where('defect_category_id', $c->id)->count();
            $byCategory[] = ['name' => $c->name, 'count' => $count];
        }

        return [
            'total_scans' => $totalScans,
            'total_images' => $totalImages,
            'total_defects' => $totalDefects,
            'average_accuracy' => round($avgAccuracy, 2),
            'recent_scans' => $recent,
            'defects_by_category' => $byCategory,
        ];
    }
}
