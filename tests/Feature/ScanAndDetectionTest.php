<?php

namespace Tests\Feature;

use App\Models\DefectCategory;
use App\Models\Image;
use App\Models\ImageDefect;
use App\Models\Scan;
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

    public function test_detect_defect_uses_existing_category_mapping_instead_of_creating_abbreviation(): void
    {
        $user = User::factory()->create();
        UserSetting::create(['user_id' => $user->id]);
        $category = DefectCategory::create([
            'name' => 'crazing',
            'description' => 'Fine network of surface cracks',
            'severity_level' => 'high',
        ]);

        Sanctum::actingAs($user);

        Http::fake([
            '*' => Http::response([
                'class' => 'cr',
                'confidence' => 96.62,
                'bbox' => [0, 0, 186, 156],
            ], 200),
        ]);

        $response = $this->post('/api/scans/detect-defect', [
            'image' => $this->fakeImage('defect.png'),
        ]);

        $response->assertOk();

        $this->assertDatabaseHas('image_defects', [
            'defect_category_id' => $category->id,
        ]);

        $this->assertDatabaseMissing('defect_categories', [
            'name' => 'cr',
        ]);
    }

    public function test_user_statistics_dashboard_returns_expected_lifetime_metrics(): void
    {
        $user = User::factory()->create();
        UserSetting::create(['user_id' => $user->id]);

        $category = DefectCategory::create([
            'name' => 'Scratch',
            'description' => 'Surface scratch',
            'severity_level' => 'medium',
        ]);

        $scan1 = Scan::create([
            'user_id' => $user->id,
            'scan_type' => 'surface',
            'total_images' => 2,
            'status' => 'completed',
        ]);

        $scan2 = Scan::create([
            'user_id' => $user->id,
            'scan_type' => 'surface',
            'total_images' => 1,
            'status' => 'failed',
        ]);

        $image1 = Image::create([
            'scan_id' => $scan1->id,
            'image_path' => '/storage/images/a.jpg',
            'processed_image_path' => '/storage/images/a_processed.jpg',
        ]);

        $image2 = Image::create([
            'scan_id' => $scan1->id,
            'image_path' => '/storage/images/b.jpg',
            'processed_image_path' => '/storage/images/b_processed.jpg',
        ]);

        $image3 = Image::create([
            'scan_id' => $scan2->id,
            'image_path' => '/storage/images/c.jpg',
            'processed_image_path' => '/storage/images/c_processed.jpg',
        ]);

        ImageDefect::create([
            'image_id' => $image1->id,
            'defect_category_id' => $category->id,
            'confidence' => 60.00,
        ]);

        ImageDefect::create([
            'image_id' => $image1->id,
            'defect_category_id' => $category->id,
            'confidence' => 40.00,
        ]);

        ImageDefect::create([
            'image_id' => $image3->id,
            'defect_category_id' => $category->id,
            'confidence' => 20.00,
        ]);

        Sanctum::actingAs($user);

        $this->getJson('/api/user-statistics/analytics')
            ->assertOk()
            ->assertJson([
                'passedCount' => 2,
                'defectCount' => 2,
                'totalDefects' => 3,
                'accuracy' => 60.0,
                'successRate' => 50.0,
            ]);

        $this->getJson('/api/user-statistics/dashboard')
            ->assertOk()
            ->assertJson([
                'passedCount' => 2,
                'defectCount' => 2,
                'totalDefects' => 3,
                'accuracy' => 60.0,
                'successRate' => 50.0,
            ]);
    }

    public function test_user_statistics_history_returns_category_cases_and_percentages(): void
    {
        $user = User::factory()->create();
        UserSetting::create(['user_id' => $user->id]);

        $scratch = DefectCategory::create([
            'name' => 'Scratches',
            'description' => 'Surface scratches',
            'severity_level' => 'medium',
        ]);

        $crack = DefectCategory::create([
            'name' => 'Cracks',
            'description' => 'Cracks on surface',
            'severity_level' => 'high',
        ]);

        $scan = Scan::create([
            'user_id' => $user->id,
            'scan_type' => 'surface',
            'total_images' => 2,
            'status' => 'completed',
        ]);

        $image1 = Image::create([
            'scan_id' => $scan->id,
            'image_path' => '/storage/images/h1.jpg',
            'processed_image_path' => '/storage/images/h1_processed.jpg',
        ]);

        $image2 = Image::create([
            'scan_id' => $scan->id,
            'image_path' => '/storage/images/h2.jpg',
            'processed_image_path' => '/storage/images/h2_processed.jpg',
        ]);

        ImageDefect::create([
            'image_id' => $image1->id,
            'defect_category_id' => $scratch->id,
            'confidence' => 80.00,
        ]);

        ImageDefect::create([
            'image_id' => $image1->id,
            'defect_category_id' => $scratch->id,
            'confidence' => 70.00,
        ]);

        ImageDefect::create([
            'image_id' => $image2->id,
            'defect_category_id' => $crack->id,
            'confidence' => 65.00,
        ]);

        Sanctum::actingAs($user);

        $response = $this->getJson('/api/user-statistics/history')
            ->assertOk()
            ->assertJsonPath('title', 'Defect Categories')
            ->assertJsonPath('subtitle', "This week's distribution")
            ->assertJsonPath('totalCases', 3)
            ->assertJsonCount(2, 'defectCategories')
            ->assertJsonPath('defectCategories.0.name', 'Scratches')
            ->assertJsonPath('defectCategories.0.cases', 2)
            ->assertJsonPath('defectCategories.0.percentage', 66.67)
            ->assertJsonPath('defectCategories.0.progress', 66.67)
            ->assertJsonPath('defectCategories.1.name', 'Cracks')
            ->assertJsonPath('defectCategories.1.cases', 1)
            ->assertJsonPath('defectCategories.1.percentage', 33.33);
    }

    public function test_user_statistics_recent_activity_endpoint_returns_feed(): void
    {
        $user = User::factory()->create();
        UserSetting::create(['user_id' => $user->id]);

        Scan::create([
            'user_id' => $user->id,
            'scan_type' => 'surface',
            'total_images' => 1,
            'status' => 'completed',
        ]);

        Sanctum::actingAs($user);

        $this->getJson('/api/user-statistics/recent_activity')
            ->assertOk()
            ->assertJsonPath('title', 'Recent Activity')
            ->assertJsonPath('subtitle', 'Latest scan results')
            ->assertJsonCount(1, 'recentActivity');
    }

    protected function fakeImage(string $name): UploadedFile
    {
        $png = base64_decode(
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9pR8N9sAAAAASUVORK5CYII='
        );

        return UploadedFile::fake()->createWithContent($name, $png);
    }
}
