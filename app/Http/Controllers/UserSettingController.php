<?php

namespace App\Http\Controllers;

use App\Models\UserSetting;
use Illuminate\Http\Request;

class UserSettingController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(UserSetting::with('user')->get(), 200);
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

        $setting = UserSetting::create($validated);

        return response()->json($setting->load('user'), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(UserSetting $userSetting)
    {
        return response()->json($userSetting->load('user'), 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, UserSetting $userSetting)
    {
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
    public function destroy(UserSetting $userSetting)
    {
        $userSetting->delete();

        return response()->json(null, 204);
    }
}
