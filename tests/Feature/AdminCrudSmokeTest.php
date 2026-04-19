<?php

namespace Tests\Feature;

use App\Models\DefectCategory;
use App\Models\Image;
use App\Models\ImageDefect;
use App\Models\Notification;
use App\Models\Scan;
use App\Models\ScanStatistic;
use App\Models\User;
use App\Models\UserSetting;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AdminCrudSmokeTest extends TestCase
{
    use RefreshDatabase;

    public function test_admin_can_use_crud_endpoints(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $user = User::factory()->create();
        $adminSetting = UserSetting::create(['user_id' => $admin->id]);
        $userSetting = UserSetting::create(['user_id' => $user->id]);

        Sanctum::actingAs($admin);

        $this->getJson('/api/users')->assertOk();
        $this->getJson("/api/users/{$user->id}")->assertOk();
        $this->putJson("/api/users/{$user->id}", ['full_name' => 'Changed Name'])->assertOk();
        $this->postJson("/api/users/{$user->id}/promote-to-admin")->assertOk();
        $this->postJson("/api/users/{$user->id}/demote-to-user")->assertOk();

        $categoryId = $this->postJson('/api/defect-categories', [
            'name' => 'Crack',
            'description' => 'Crack defect',
            'severity_level' => 'high',
        ])->assertCreated()->json('id');

        $this->getJson('/api/defect-categories')->assertOk();
        $this->getJson("/api/defect-categories/{$categoryId}")->assertOk();
        $this->putJson("/api/defect-categories/{$categoryId}", ['description' => 'Updated'])->assertOk();

        $scanId = $this->postJson('/api/scans', [
            'user_id' => $user->id,
            'scan_type' => 'surface',
        ])->assertCreated()->json('data.id');

        $scan = Scan::findOrFail($scanId);

        $activityId = $this->postJson('/api/activities', [
            'user_id' => $user->id,
            'scan_id' => $scan->id,
            'title' => 'Review',
            'description' => 'Initial activity',
            'status' => 'pending',
        ])->assertCreated()->json('id');

        $this->getJson('/api/activities')->assertOk();
        $this->getJson("/api/activities/{$activityId}")->assertOk();
        $this->putJson("/api/activities/{$activityId}", ['status' => 'completed'])->assertOk();

        $imageId = $this->postJson('/api/images', [
            'scan_id' => $scan->id,
            'image_path' => '/storage/images/example.png',
            'file_size' => 12345,
        ])->assertCreated()->json('id');

        $this->getJson('/api/images')->assertOk();
        $this->getJson("/api/images/{$imageId}")->assertOk();
        $this->putJson("/api/images/{$imageId}", ['processed_image_path' => '/storage/images/processed.png'])->assertOk();

        $imageDefectId = $this->postJson('/api/image-defects', [
            'image_id' => $imageId,
            'defect_category_id' => $categoryId,
            'confidence' => 92.5,
            'bounding_box' => ['x' => 1, 'y' => 2, 'width' => 3, 'height' => 4],
        ])->assertCreated()->json('id');

        $this->getJson('/api/image-defects')->assertOk();
        $this->getJson("/api/image-defects/{$imageDefectId}")->assertOk();
        $this->putJson("/api/image-defects/{$imageDefectId}", ['confidence' => 88.1])->assertOk();

        $notificationId = $this->postJson('/api/notifications', [
            'user_id' => $user->id,
            'title' => 'Done',
            'message' => 'Scan completed',
            'type' => 'success',
        ])->assertCreated()->json('id');

        $this->getJson('/api/notifications')->assertOk();
        $this->getJson("/api/notifications/{$notificationId}")->assertOk();
        $this->putJson("/api/notifications/{$notificationId}", ['is_read' => true])->assertOk();
        $this->postJson("/api/notifications/{$notificationId}/mark-as-read")->assertOk();

        $statId = $this->postJson('/api/scan-statistics', [
            'scan_id' => $scan->id,
            'total_defects' => 2,
            'passed_count' => 1,
            'defect_count' => 2,
            'accuracy' => 50,
            'processing_time' => 12,
        ])->assertCreated()->json('id');

        $this->getJson('/api/scan-statistics')->assertOk();
        $this->getJson("/api/scan-statistics/{$statId}")->assertOk();
        $this->putJson("/api/scan-statistics/{$statId}", ['accuracy' => 60])->assertOk();

        $this->getJson('/api/user-settings')->assertOk();
        $this->getJson("/api/user-settings/{$userSetting->id}")->assertOk();
        $this->putJson("/api/user-settings/{$userSetting->id}", ['theme' => 'dark'])->assertOk();

        $newSettingId = $this->postJson('/api/user-settings', [
            'user_id' => User::factory()->create()->id,
            'language' => 'fr',
            'theme' => 'light',
        ])->assertCreated()->json('id');

        $this->deleteJson("/api/user-settings/{$newSettingId}")->assertNoContent();
        $this->deleteJson("/api/scan-statistics/{$statId}")->assertNoContent();
        $this->deleteJson("/api/notifications/{$notificationId}")->assertNoContent();
        $this->deleteJson("/api/image-defects/{$imageDefectId}")->assertNoContent();
        $this->deleteJson("/api/images/{$imageId}")->assertNoContent();
        $this->deleteJson("/api/activities/{$activityId}")->assertNoContent();
        $this->deleteJson("/api/defect-categories/{$categoryId}")->assertNoContent();
        $this->deleteJson("/api/users/{$user->id}")->assertNoContent();

        $this->assertDatabaseMissing('users', ['id' => $user->id]);
        $this->assertDatabaseHas('user_settings', ['id' => $adminSetting->id]);
    }
}
