<?php

namespace App\Http\Controllers;

use App\Models\UserSetting;
use Illuminate\Http\Request;

class UserSettingController extends Controller
{
    protected function canAccess(Request $request, UserSetting $userSetting): bool
    {
        return $request->user()->role === 'admin' || $userSetting->user_id === $request->user()->id;
    }

    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = UserSetting::with('user');

        if ($request->user()->role !== 'admin') {
            $query->where('user_id', $request->user()->id);
        }

        return response()->json($query->get(), 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|unique:user_settings|exists:users,id',
            'language' => 'nullable|string|max:10',
            'theme' => 'nullable|string|in:light,dark',
            'push_notifications' => 'nullable|boolean',
            'email_notifications' => 'nullable|boolean',
        ]);

        if ($request->user()->role !== 'admin' && (int) $validated['user_id'] !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only create your own settings.'
            ], 403);
        }

        $setting = UserSetting::create($validated);

        return response()->json($setting->load('user'), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Request $request, UserSetting $userSetting)
    {
        if (!$this->canAccess($request, $userSetting)) {
            return response()->json([
                'message' => 'Unauthorized. You can only view your own settings.'
            ], 403);
        }

        return response()->json($userSetting->load('user'), 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, UserSetting $userSetting)
    {
        if (!$this->canAccess($request, $userSetting)) {
            return response()->json([
                'message' => 'Unauthorized. You can only update your own settings.'
            ], 403);
        }

        $validated = $request->validate([
            'language' => 'nullable|string|max:10',
            'theme' => 'nullable|string|in:light,dark',
            'push_notifications' => 'nullable|boolean',
            'email_notifications' => 'nullable|boolean',
        ]);

        $userSetting->update($validated);

        return response()->json($userSetting->load('user'), 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, UserSetting $userSetting)
    {
        if (!$this->canAccess($request, $userSetting)) {
            return response()->json([
                'message' => 'Unauthorized. You can only delete your own settings.'
            ], 403);
        }

        $userSetting->delete();

        return response()->json(null, 204);
    }
}
