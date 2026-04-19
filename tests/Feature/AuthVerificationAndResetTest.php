<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthVerificationAndResetTest extends TestCase
{
    use RefreshDatabase;

    public function test_verification_and_password_reset_endpoints_work(): void
    {
        $user = User::factory()->create([
            'email' => 'verify@example.com',
            'phone' => '01011112222',
            'email_verified_at' => null,
            'phone_verified_at' => null,
            'account_status' => 'inactive',
        ]);

        $emailCode = $this->postJson('/api/auth/send-email-verification', [
            'email' => $user->email,
        ])->assertOk()->json('code');

        $this->postJson('/api/auth/verify-email', [
            'email' => $user->email,
            'code' => (string) $emailCode,
        ])->assertOk();

        $phoneCode = $this->postJson('/api/auth/send-phone-verification', [
            'phone' => $user->phone,
        ])->assertOk()->json('code');

        $this->postJson('/api/auth/verify-phone', [
            'phone' => $user->phone,
            'code' => (string) $phoneCode,
        ])->assertOk();

        $this->postJson('/api/auth/resend-code', [
            'type' => 'email',
            'contact' => $user->email,
        ])->assertOk();

        $resetCode = $this->postJson('/api/auth/send-password-reset', [
            'email' => $user->email,
        ])->assertOk()->json('code');

        $resetToken = $this->postJson('/api/auth/verify-password-reset', [
            'email' => $user->email,
            'code' => (string) $resetCode,
        ])->assertOk()->json('reset_token');

        $this->postJson('/api/auth/reset-password', [
            'email' => $user->email,
            'reset_token' => $resetToken,
            'password' => 'NewPassword123',
            'password_confirmation' => 'NewPassword123',
        ])->assertOk();

        $this->postJson('/api/auth/login', [
            'email' => $user->email,
            'password' => 'NewPassword123',
        ])->assertOk();

        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'account_status' => 'active',
        ]);
    }
}
