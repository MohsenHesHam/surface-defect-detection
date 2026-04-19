<?php

namespace Tests\Feature;

use App\Models\DefectCategory;
use App\Models\User;
use App\Models\UserSetting;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ScanAndDetectionTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_create_scan_and_fetch_analytics(): void
    {
        Storage::fake('public');

        $user = User::factory()->create();
        UserSetting::create(['user_id' => $user->id]);
        DefectCategory::create([
            'name' => 'Scratch',
            'description' => 'Surface scratch',
            'severity_level' => 'medium',
        ]);

        Sanctum::actingAs($user);

        $response = $this->post('/api/scans', [
            'user_id' => $user->id,
            'scan_type' => 'surface',
            'images' => [
                $this->fakeImage('scan-1.png'),
                $this->fakeImage('scan-2.png'),
            ],
        ]);

        $response->assertCreated()
            ->assertJsonPath('data.total_images', 2)
            ->assertJsonPath('data.status', 'completed');

        $scanId = $response->json('data.id');

        $this->getJson('/api/scans')
            ->assertOk()
            ->assertJsonPath('data.0.id', $scanId);

        $this->getJson("/api/scans/{$scanId}")
            ->assertOk()
            ->assertJsonPath('data.id', $scanId);

        $this->getJson('/api/analytics/summary')
            ->assertOk()
            ->assertJsonPath('total_scans', 1);

        $this->getJson("/api/analytics/report/{$scanId}")
            ->assertOk()
            ->assertJsonPath('report.scan_id', $scanId);

        $this->getJson('/api/analytics/history')
            ->assertOk()
            ->assertJsonStructure(['defect_categories', 'recent_activity']);
    }

    public function test_detect_defect_endpoint_returns_fastapi_response(): void
    {
        $user = User::factory()->create();
        UserSetting::create(['user_id' => $user->id]);
        $scan = \App\Models\Scan::create([
            'user_id' => $user->id,
            'scan_type' => 'surface',
            'total_images' => 0,
            'status' => 'pending',
        ]);

        Sanctum::actingAs($user);

        Http::fake([
            '*' => Http::response([
                'class' => 'sc',
                'confidence' => 98.2,
                'defect_percentage' => 10.4,
                'bbox' => [10, 20, 30, 40],
            ], 200),
        ]);

        $response = $this->post('/api/scans/detect-defect', [
            'scan_id' => $scan->id,
            'image' => $this->fakeImage('defect.png'),
        ]);

        $response->assertOk()
            ->assertJsonPath('data.prediction.class', 'sc')
            ->assertJsonPath('data.prediction.bbox.0', 10)
            ->assertJsonPath('data.saved_records.scan.id', $scan->id);

        $this->assertDatabaseHas('images', [
            'scan_id' => $scan->id,
        ]);

        $this->assertDatabaseHas('image_defects', [
            'confidence' => 98.20,
        ]);

        $this->assertDatabaseHas('scan_statistics', [
            'scan_id' => $scan->id,
            'total_defects' => 1,
        ]);
    }

    public function test_detect_defect_endpoint_returns_service_unavailable_when_fastapi_fails(): void
    {
        $user = User::factory()->create();
        UserSetting::create(['user_id' => $user->id]);

        Sanctum::actingAs($user);

        Http::fake([
            '*' => Http::response(['detail' => 'model unavailable'], 503),
        ]);

        $this->post('/api/scans/detect-defect', [
            'image' => $this->fakeImage('defect.png'),
        ])->assertStatus(503);
    }

    protected function fakeImage(string $name): UploadedFile
    {
        $png = base64_decode(
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9pR8N9sAAAAASUVORK5CYII='
        );

        return UploadedFile::fake()->createWithContent($name, $png);
    }
}
