<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AuthAndProfileTest extends TestCase
{
    use RefreshDatabase;

    public function test_auth_flow_and_profile_routes_work(): void
    {
        $registerResponse = $this->postJson('/api/auth/register', [
            'full_name' => 'Test User',
            'email' => 'test@example.com',
            'phone' => '01012345678',
            'password' => 'Password123',
            'password_confirmation' => 'Password123',
        ]);

        $registerResponse->assertCreated()
            ->assertJsonPath('user.email', 'test@example.com');

        $loginResponse = $this->postJson('/api/auth/login', [
            'email' => 'test@example.com',
            'password' => 'Password123',
        ]);

        $loginResponse->assertOk()
            ->assertJsonStructure(['token']);

        $user = User::firstOrFail();
        Sanctum::actingAs($user);

        $this->getJson('/api/auth/me')
            ->assertOk()
            ->assertJsonPath('user.email', 'test@example.com');

        $this->getJson('/api/profile')
            ->assertOk()
            ->assertJsonPath('email', 'test@example.com');

        $this->putJson('/api/profile', [
            'full_name' => 'Updated User',
            'phone' => '01099998888',
        ])->assertOk()
            ->assertJsonPath('full_name', 'Updated User')
            ->assertJsonPath('phone', '01099998888');

        $this->putJson('/api/profile/settings', [
            'language' => 'ar',
            'theme' => 'dark',
            'push_notifications' => false,
        ])->assertOk()
            ->assertJsonPath('language', 'ar')
            ->assertJsonPath('theme', 'dark')
            ->assertJsonPath('push_notifications', false);
    }
}
