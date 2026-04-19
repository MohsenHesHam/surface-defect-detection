<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    /**
     * Display a listing of the resource.
     * Admin sees all notifications, users see only their own
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'admin') {
            return response()->json(Notification::with('user')->get(), 200);
        }

        return response()->json(Notification::where('user_id', $user->id)->with('user')->get(), 200);
    }

    /**
     * Store a newly created resource in storage.
     * Admin only
     */
    public function store(Request $request)
    {
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'message' => 'Unauthorized. Admin access required.'
            ], 403);
        }

        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'title' => 'required|string|max:255',
            'message' => 'required|string',
            'type' => 'nullable|string|in:info,success,warning,error',
            'is_read' => 'nullable|boolean',
        ]);

        $notification = Notification::create($validated);

        return response()->json($notification->load('user'), 201);
    }

    /**
     * Display the specified resource.
     * Admin can view any notification, users can only view their own
     */
    public function show(Request $request, Notification $notification)
    {
        if ($request->user()->role !== 'admin' && $notification->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only view your own notifications.'
            ], 403);
        }

        return response()->json($notification->load('user'), 200);
    }

    /**
     * Update the specified resource in storage.
     * Admin can update any, users can only update their own
     */
    public function update(Request $request, Notification $notification)
    {
        if ($request->user()->role !== 'admin' && $notification->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only update your own notifications.'
            ], 403);
        }

        $validated = $request->validate([
            'title' => 'nullable|string|max:255',
            'message' => 'nullable|string',
            'type' => 'nullable|string|in:info,success,warning,error',
            'is_read' => 'nullable|boolean',
        ]);

        $notification->update($validated);

        return response()->json($notification->load('user'), 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, Notification $notification)
    {
        if ($request->user()->role !== 'admin' && $notification->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only delete your own notifications.'
            ], 403);
        }

        $notification->delete();

        return response()->json(null, 204);
    }

    /**
     * Mark notification as read
     */
    public function markAsRead(Request $request, Notification $notification)
    {
        if ($request->user()->role !== 'admin' && $notification->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only update your own notifications.'
            ], 403);
        }

        $notification->update(['is_read' => true]);

        return response()->json($notification->load('user'), 200);
    }
}
