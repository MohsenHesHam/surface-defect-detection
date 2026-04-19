<?php

namespace Tests\Feature;

use App\Models\Activity;
use App\Models\Notification;
use App\Models\Scan;
use App\Models\User;
use App\Models\UserSetting;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AuthorizationBoundariesTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_cannot_delete_another_users_activity(): void
    {
        [$owner, $intruder] = $this->createUsers();
        $scan = Scan::create([
            'user_id' => $owner->id,
            'scan_type' => 'surface',
            'total_images' => 0,
            'status' => 'pending',
        ]);

        $activity = Activity::create([
            'user_id' => $owner->id,
            'scan_id' => $scan->id,
            'title' => 'Owner Activity',
            'description' => 'Private',
            'status' => 'pending',
        ]);

        Sanctum::actingAs($intruder);

        $this->deleteJson("/api/activities/{$activity->id}")
            ->assertForbidden();
    }

    public function test_user_cannot_mark_another_users_notification_as_read(): void
    {
        [$owner, $intruder] = $this->createUsers();

        $notification = Notification::create([
            'user_id' => $owner->id,
            'title' => 'Owner Notification',
            'message' => 'Private',
            'type' => 'info',
        ]);

        Sanctum::actingAs($intruder);

        $this->postJson("/api/notifications/{$notification->id}/mark-as-read")
            ->assertForbidden();
    }

    public function test_user_settings_endpoints_are_scoped_to_the_owner(): void
    {
        [$owner, $intruder] = $this->createUsers();

        $ownerSetting = UserSetting::where('user_id', $owner->id)->firstOrFail();

        Sanctum::actingAs($intruder);

        $this->getJson('/api/user-settings')
            ->assertOk()
            ->assertJsonCount(1)
            ->assertJsonPath('0.user_id', $intruder->id);

        $this->getJson("/api/user-settings/{$ownerSetting->id}")
            ->assertForbidden();

        $this->putJson("/api/user-settings/{$ownerSetting->id}", [
            'theme' => 'dark',
        ])->assertForbidden();
    }

    /**
     * @return array{0: User, 1: User}
     */
    protected function createUsers(): array
    {
        $owner = User::factory()->create();
        $intruder = User::factory()->create();

        UserSetting::firstOrCreate(['user_id' => $owner->id], ['language' => 'en', 'theme' => 'light']);
        UserSetting::firstOrCreate(['user_id' => $intruder->id], ['language' => 'en', 'theme' => 'light']);

        return [$owner, $intruder];
    }
}
