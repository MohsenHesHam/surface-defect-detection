<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Mail;

class AuthController extends Controller
{
    /**
     * Register a new user
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'full_name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'required|string|max:20|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::create([
            'full_name' => $request->full_name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            // 'account_status' => 'pending',
        ]);

        // Create user settings
        $user->settings()->create([
            'language' => 'en',
            'theme' => 'light',
            'push_notifications' => true,
            'email_notifications' => true,
        ]);

        return response()->json([
            'message' => 'User registered successfully',
            'user' => $user,
        ], 201);
    }

    /**
     * Login user
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'Invalid credentials',
            ], 401);
        }

        // Check account status
        if ($user->account_status === 'suspended') {
            return response()->json([
                'message' => 'Account is suspended',
            ], 403);
        }

        $token = $user->createToken('api-token')->plainTextToken;

        return response()->json([
            'message' => 'Login successful',
            'user' => $user,
            'token' => $token,
            'requires_email_verification' => $user->email_verified_at === null,
            'requires_phone_verification' => $user->phone_verified_at === null,
        ], 200);
    }

    /**
     * Logout user
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logged out successfully',
        ], 200);
    }

    /**
     * Get current authenticated user
     */
    public function me(Request $request)
    {
        return response()->json([
            'user' => $request->user()->load(['scans', 'activities', 'notifications', 'settings']),
        ], 200);
    }

    /**
     * Send email verification code
     */
    public function sendEmailVerification(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|exists:users',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::where('email', $request->email)->first();

        // Generate 6-digit verification code
        $code = rand(100000, 999999);

        // Store code in cache with 15 minutes expiration
        cache()->put('email_verification_' . $user->id, $code, now()->addMinutes(15));

        // send real email using mailable
        try {
            Mail::to($user->email)->send(new \App\Mail\VerificationCode($code, 'email'));
        } catch (\Exception $e) {
            // Log failure so developer knows SMTP isn't configured or sending failed
            //Log::error('Failed to send verification email', ['error' => $e->getMessage()]);
            // if mailer isn't configured we still return success with code (for testing)
        }

        return response()->json([
            'message' => 'Verification code sent to email',
            'code' => $code, // Remove in production
        ], 200);
    }

    /**
     * Verify email with code
     */
    public function verifyEmail(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|exists:users',
            'code' => 'required|string|digits:6',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::where('email', $request->email)->first();
        $storedCode = cache()->get('email_verification_' . $user->id);

        if (!$storedCode || $storedCode != $request->code) {
            return response()->json([
                'message' => 'Invalid verification code',
            ], 422);
        }

        $user->update(['email_verified_at' => now()]);
        cache()->forget('email_verification_' . $user->id);

        return response()->json([
            'message' => 'Email verified successfully',
            'user' => $user,
        ], 200);
    }

    /**
     * Send phone verification code
     */
    public function sendPhoneVerification(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|exists:users',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::where('phone', $request->phone)->first();

        // Generate 6-digit verification code
        $code = rand(100000, 999999);

        // Store code in cache with 15 minutes expiration
        cache()->put('phone_verification_' . $user->id, $code, now()->addMinutes(15));

        // additionally we could send via email too if desired
        try {
            Mail::to($user->email)->send(new \App\Mail\VerificationCode($code, 'phone'));
        } catch (\Exception $e) {
            // ignore
        }

        return response()->json([
            'message' => 'Verification code sent to phone',
            'code' => $code, // Remove in production
        ], 200);
    }

    /**
     * Verify phone with code
     */
    public function verifyPhone(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|exists:users',
            'code' => 'required|string|digits:6',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::where('phone', $request->phone)->first();
        $storedCode = cache()->get('phone_verification_' . $user->id);

        if (!$storedCode || $storedCode != $request->code) {
            return response()->json([
                'message' => 'Invalid verification code',
            ], 422);
        }

        $user->update(['phone_verified_at' => now()]);
        cache()->forget('phone_verification_' . $user->id);

        // Update account status if both email and phone are verified
        if ($user->email_verified_at && $user->phone_verified_at) {
            $user->update(['account_status' => 'active']);
        }

        return response()->json([
            'message' => 'Phone verified successfully',
            'user' => $user,
        ], 200);
    }

    /**
     * Resend verification code
     */
    public function resendCode(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'type' => 'required|string|in:email,phone',
            'contact' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        if ($request->type === 'email') {
            return $this->sendEmailVerification(new Request(['email' => $request->contact]));
        } else {
            return $this->sendPhoneVerification(new Request(['phone' => $request->contact]));
        }
    }

    /**
     * Send password reset code
     */
    public function sendPasswordResetCode(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|exists:users',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::where('email', $request->email)->first();

        // Generate 6-digit reset code
        $code = rand(100000, 999999);

        // Store code in cache with 15 minutes expiration
        cache()->put('password_reset_' . $user->id, $code, now()->addMinutes(15));

        // send reset email via mailable (reuse verification template or create new one)
        try {
            Mail::to($user->email)->send(new \App\Mail\VerificationCode($code, 'email'));
        } catch (\Exception $e) {
            // ignore
        }

        return response()->json([
            'message' => 'Password reset code sent to email',
            'code' => $code, // Remove in production
        ], 200);
    }

    /**
     * Verify password reset code
     */
    public function verifyPasswordResetCode(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|exists:users',
            'code' => 'required|string|digits:6',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::where('email', $request->email)->first();
        $storedCode = cache()->get('password_reset_' . $user->id);

        if (!$storedCode || $storedCode != $request->code) {
            return response()->json([
                'message' => 'Invalid reset code',
            ], 422);
        }

        // Store temporary token for password reset
        $resetToken = bin2hex(random_bytes(32));
        cache()->put('password_reset_token_' . $user->id, $resetToken, now()->addMinutes(15));

        return response()->json([
            'message' => 'Reset code verified successfully',
            'reset_token' => $resetToken,
        ], 200);
    }

    /**
     * Reset password with new password
     */
    public function resetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|exists:users',
            'reset_token' => 'required|string',
            'password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::where('email', $request->email)->first();
        $storedToken = cache()->get('password_reset_token_' . $user->id);

        if (!$storedToken || $storedToken !== $request->reset_token) {
            return response()->json([
                'message' => 'Invalid or expired reset token',
            ], 422);
        }

        $user->update(['password' => Hash::make($request->password)]);
        
        // Clear all reset codes and tokens
        cache()->forget('password_reset_' . $user->id);
        cache()->forget('password_reset_token_' . $user->id);

        return response()->json([
            'message' => 'Password changed successfully',
            'user' => $user,
        ], 200);
    }

    /**
     * Change password (authenticated user)
     */
    public function changePassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'current_password' => 'required|string',
            'new_password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = $request->user();

        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'message' => 'Current password is incorrect',
            ], 422);
        }

        $user->update(['password' => Hash::make($request->new_password)]);

        return response()->json([
            'message' => 'Password changed successfully',
            'user' => $user,
        ], 200);
    }
}
