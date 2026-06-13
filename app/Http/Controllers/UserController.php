<?php

namespace App\Http\Controllers;

use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    /**
     * Return the current authenticated user's profile in a clean Flutter-friendly shape.
     */
    public function getProfile(Request $request)
    {
        return response()->json((new UserResource($request->user()->fresh()))->resolve(), 200);
    }

    /**
     * Update the current authenticated user's profile.
     */
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'full_name' => 'nullable|string|max:255',
            'email' => 'nullable|string|email|max:255|unique:users,email,' . $user->id,
            'phone' => 'nullable|string|max:20|unique:users,phone,' . $user->id,
            'theme' => 'nullable|string|in:light,dark',
        ]);

        $user->update($validated);

        if (array_key_exists('theme', $validated) && $user->settings) {
            $user->settings()->update(['theme' => $validated['theme']]);
        }

        return response()->json((new UserResource($user->fresh()))->resolve(), 200);
    }

    /**
     * Upload or replace the authenticated user's avatar.
     *
     * Important:
     * 1. This stores the file in storage/app/public/avatars.
     * 2. The database stores only the relative path, never the full URL.
     * 3. Public access requires: php artisan storage:link
     *    That creates public/storage -> storage/app/public.
     * 4. On shared hosting, if symlinks are blocked, manually create the link
     *    or copy public files from storage/app/public into public/storage.
     */
    public function uploadAvatar(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'avatar' => 'required|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = $request->user();

        try {
            $path = $request->file('avatar')->store('avatars', 'public');

            if (!$path) {
                return response()->json([
                    'message' => 'Avatar upload failed',
                ], 500);
            }

            if ($user->avatar && Storage::disk('public')->exists($user->avatar)) {
                Storage::disk('public')->delete($user->avatar);
            }

            $user->update(['avatar' => $path]);

            return response()->json((new UserResource($user->fresh()))->resolve(), 200);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Avatar upload failed',
                'error' => app()->hasDebugModeEnabled() ? $e->getMessage() : null,
            ], 500);
        }
    }

    /**
     * Update the current authenticated user's settings.
     * The theme is now stored on the users table as requested.
     */
    public function updateSettings(Request $request)
    {
        $validated = $request->validate([
            'language' => 'nullable|string|max:10',
            'theme' => 'nullable|string|in:light,dark',
            'push_notifications' => 'nullable|boolean',
            'email_notifications' => 'nullable|boolean',
        ]);

        $user = $request->user();

        if (array_key_exists('theme', $validated)) {
            $user->update(['theme' => $validated['theme']]);
        }

        $settingsPayload = collect($validated)
            ->except('theme')
            ->toArray();

        $settings = null;

        if (!empty($settingsPayload) || array_key_exists('theme', $validated)) {
            $settingsPayload['theme'] = $validated['theme'] ?? $user->theme ?? 'light';
            $settings = $user->settings()->updateOrCreate([], $settingsPayload);
        }

        return response()->json(array_merge(
            (new UserResource($user->fresh()))->resolve(),
            [
                'language' => $settings?->language ?? $user->settings?->language,
                'push_notifications' => $settings?->push_notifications ?? $user->settings?->push_notifications,
                'email_notifications' => $settings?->email_notifications ?? $user->settings?->email_notifications,
            ]
        ), 200);
    }

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

        return response()->json(
            User::query()
                ->latest()
                ->get()
                ->map(fn (User $user) => (new UserResource($user))->resolve())
                ->values(),
            200
        );
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
            'theme' => 'nullable|string|in:light,dark',
            'account_status' => 'nullable|string|in:active,inactive,suspended',
        ]);

        $validated['password'] = Hash::make($validated['password']);
        $validated['theme'] = $validated['theme'] ?? 'light';

        $user = User::create($validated);

        return response()->json((new UserResource($user))->resolve(), 201);
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

        return response()->json((new UserResource($user))->resolve(), 200);
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
            'theme' => 'nullable|string|in:light,dark',
            'account_status' => 'nullable|string|in:active,inactive,suspended',
        ]);

        if (isset($validated['account_status']) && $request->user()->role !== 'admin') {
            unset($validated['account_status']);
        }

        $user->update($validated);

        if (array_key_exists('theme', $validated) && $user->settings) {
            $user->settings()->update(['theme' => $validated['theme']]);
        }

        return response()->json((new UserResource($user->fresh()))->resolve(), 200);
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

        if ($user->avatar && Storage::disk('public')->exists($user->avatar)) {
            Storage::disk('public')->delete($user->avatar);
        }

        $user->delete();

        return response()->json(null, 204);
    }

    /**
     * Promote user to admin (Admin only)
     */
    public function promoteToAdmin(Request $request, User $user)
    {
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
            'user' => (new UserResource($user->fresh()))->resolve(),
        ], 200);
    }

    /**
     * Demote admin to user (Admin only)
     */
    public function demoteToUser(Request $request, User $user)
    {
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
            'user' => (new UserResource($user->fresh()))->resolve(),
        ], 200);
    }
}
