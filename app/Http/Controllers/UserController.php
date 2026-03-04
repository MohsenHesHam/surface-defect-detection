<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     * Admin only
     */
    public function index(Request $request)
    {
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'message' => 'Unauthorized. Admin access required.'
            ], 403);
        }

        return response()->json(User::all(), 200);
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
            'full_name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'nullable|string|max:20',
            'password' => 'required|string|min:8',
            'avatar' => 'nullable|string',
            'account_status' => 'nullable|string|in:active,inactive,suspended',
        ]);

        $validated['password'] = Hash::make($validated['password']);

        $user = User::create($validated);

        return response()->json($user, 201);
    }

    /**
     * Display the specified resource.
     * User can see their own, admin can see all
     */
    public function show(Request $request, User $user)
    {
        if ($request->user()->role !== 'admin' && $request->user()->id !== $user->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only view your own profile.'
            ], 403);
        }

        return response()->json($user, 200);
    }

    /**
     * Update the specified resource in storage.
     * User can update their own, admin can update all
     */
    public function update(Request $request, User $user)
    {
        if ($request->user()->role !== 'admin' && $request->user()->id !== $user->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only update your own profile.'
            ], 403);
        }

        $validated = $request->validate([
            'full_name' => 'nullable|string|max:255',
            'email' => 'nullable|string|email|max:255|unique:users,email,' . $user->id,
            'phone' => 'nullable|string|max:20',
            'avatar' => 'nullable|string',
            'account_status' => 'nullable|string|in:active,inactive,suspended',
        ]);

        // Only admin can change account_status
        if (isset($validated['account_status']) && $request->user()->role !== 'admin') {
            unset($validated['account_status']);
        }

        $user->update($validated);

        return response()->json($user, 200);
    }

    /**
     * Remove the specified resource from storage.
     * Admin only
     */
    public function destroy(Request $request, User $user)
    {
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'message' => 'Unauthorized. Admin access required.'
            ], 403);
        }

        $user->delete();

        return response()->json(null, 204);
    }

    /**
     * Promote user to admin (Admin only)
     */
    public function promoteToAdmin(Request $request, User $user)
    {
        // Check if requester is admin
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'message' => 'Only admins can promote users'
            ], 403);
        }

        if ($user->role === 'admin') {
            return response()->json([
                'message' => 'User is already an admin'
            ], 400);
        }

        $user->update(['role' => 'admin']);

        return response()->json([
            'message' => 'User promoted to admin successfully',
            'user' => $user
        ], 200);
    }

    /**
     * Demote admin to user (Admin only)
     */
    public function demoteToUser(Request $request, User $user)
    {
        // Check if requester is admin
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'message' => 'Only admins can demote users'
            ], 403);
        }

        if ($user->role === 'user') {
            return response()->json([
                'message' => 'User is already a regular user'
            ], 400);
        }

        $user->update(['role' => 'user']);

        return response()->json([
            'message' => 'Admin demoted to user successfully',
            'user' => $user
        ], 200);
    }
}
  

