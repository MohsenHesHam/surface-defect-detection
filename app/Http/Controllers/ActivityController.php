<?php

namespace App\Http\Controllers;

use App\Models\Activity;
use Illuminate\Http\Request;

class ActivityController extends Controller
{
    /**
     * Display a listing of the resource.
     * Admin sees all activities, users see only their own
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'admin') {
            return response()->json(Activity::with(['user', 'scan'])->get(), 200);
        }

        return response()->json(Activity::where('user_id', $user->id)->with(['user', 'scan'])->get(), 200);
    }

    /**
     * Store a newly created resource in storage.
     * Admin can create for any user, users can only create for themselves
     */
    public function store(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'scan_id' => 'required|exists:scans,id',
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'status' => 'nullable|string|in:pending,completed,failed',
        ]);

        // Regular users can only create activities for themselves
        if ($user->role !== 'admin' && $validated['user_id'] != $user->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only create activities for yourself.'
            ], 403);
        }

        $activity = Activity::create($validated);

        return response()->json($activity->load(['user', 'scan']), 201);
    }

    /**
     * Display the specified resource.
     * Admin can view any activity, users can only view their own
     */
    public function show(Request $request, Activity $activity)
    {
        if ($request->user()->role !== 'admin' && $activity->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only view your own activities.'
            ], 403);
        }

        return response()->json($activity->load(['user', 'scan']), 200);
    }

    /**
     * Update the specified resource in storage.
     * Admin can update any, users can only update their own
     */
    public function update(Request $request, Activity $activity)
    {
        if ($request->user()->role !== 'admin' && $activity->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only update your own activities.'
            ], 403);
        }

        $validated = $request->validate([
            'title' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'status' => 'nullable|string|in:pending,completed,failed',
        ]);

        $activity->update($validated);

        return response()->json($activity->load(['user', 'scan']), 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, Activity $activity)
    {
        if ($request->user()->role !== 'admin' && $activity->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only delete your own activities.'
            ], 403);
        }

        $activity->delete();

        return response()->json(null, 204);
    }
}
