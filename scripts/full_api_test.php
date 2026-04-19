<?php
require __DIR__ . '/../vendor/autoload.php';
$app = require_once __DIR__ . '/../bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

function dispatchRequest($kernel, $method, $uri, $data = [], $headers = []) {
    $content = json_encode($data);
    $server = [
        'CONTENT_TYPE' => 'application/json',
        'HTTP_ACCEPT' => 'application/json',
    ];
    
    foreach ($headers as $k => $v) {
        $server["HTTP_" . strtoupper(str_replace('-', '_', $k))] = $v;
    }
    
    $request = Request::create($uri, $method, [], [], [], $server, $content);
    $response = $kernel->handle($request);
    $status = $response->getStatusCode();
    $body = $response->getContent();
    $kernel->terminate($request, $response);
    return [$status, $body];
}

echo "========================================\n";
echo "COMPREHENSIVE API ENDPOINT VERIFICATION\n";
echo "========================================\n\n";

$tests = [];

// 1. Register a new user
echo "[1] Testing UserRegistration...\n";
$email = 'test_' . time() . '@example.com';
$phone = (string) rand(1000000000, 9999999999);
$password = 'Password123';
list($status, $body) = dispatchRequest($kernel, 'POST', '/api/auth/register', [
    'full_name' => 'Test User',
    'email' => $email,
    'phone' => $phone,
    'password' => $password,
    'password_confirmation' => $password,
]);
$register_ok = $status === 201;
$tests['User Registration (POST /api/auth/register)'] = $register_ok ? 'PASS' : "FAIL: status=$status";
echo "  Status: $status\n\n";

// 2. Login
echo "[2] Testing UserLogin...\n";
list($status, $body) = dispatchRequest($kernel, 'POST', '/api/auth/login', [
    'email' => $email,
    'password' => $password,
]);
$login_ok = $status === 200;
$tests['User Login (POST /api/auth/login)'] = $login_ok ? 'PASS' : "FAIL: status=$status";
$token = null;
if ($login_ok) {
    $json = json_decode($body, true);
    $token = $json['token'] ?? null;
    echo "  Status: $status\n";
    echo "  Token obtained: " . ($token ? "yes" : "no") . "\n\n";
} else {
    echo "  Status: $status\n\n";
}

// 3. Get current user (me)
if ($token) {
    echo "[3] Testing GetCurrentUser...\n";
    list($status, $body) = dispatchRequest($kernel, 'GET', '/api/auth/me', [], ['Authorization' => "Bearer $token"]);
    $me_ok = $status === 200;
    $tests['Get Current User (GET /api/auth/me)'] = $me_ok ? 'PASS' : "FAIL: status=$status";
    echo "  Status: $status\n\n";
}

// 4. Get users list (protected route)
if ($token) {
    echo "[4] Testing GetUsersList...\n";
    list($status, $body) = dispatchRequest($kernel, 'GET', '/api/users', [], ['Authorization' => "Bearer $token"]);
    $users_list_ok = $status === 200;
    $tests['Get Users List (GET /api/users)'] = $users_list_ok ? 'PASS' : "FAIL: status=$status";
    echo "  Status: $status\n\n";
}

// 5. Test creating a scan (requires camera_model, location, surface_type)
if ($token) {
    echo "[5] Testing CreateScan...\n";
    list($status, $body) = dispatchRequest($kernel, 'POST', '/api/scans', [
        'camera_model' => 'Canon EOS',
        'location' => 'Test Location',
        'surface_type' => 'metal',
        'notes' => 'Test scan',
    ], ['Authorization' => "Bearer $token"]);
    $scan_create_ok = $status === 201;
    $tests['Create Scan (POST /api/scans)'] = $scan_create_ok ? 'PASS' : "FAIL: status=$status";
    echo "  Status: $status\n\n";
    
    if ($scan_create_ok) {
        $json = json_decode($body, true);
        $scan_id = $json['data']['id'] ?? null;
        
        if ($scan_id) {
            // 6. Get scan by id
            echo "[6] Testing GetScanById...\n";
            list($status, $body) = dispatchRequest($kernel, 'GET', "/api/scans/$scan_id", [], ['Authorization' => "Bearer $token"]);
            $scan_get_ok = $status === 200;
            $tests['Get Scan By ID (GET /api/scans/{id})'] = $scan_get_ok ? 'PASS' : "FAIL: status=$status";
            echo "  Status: $status\n\n";
            
            // 7. Update scan
            echo "[7] Testing UpdateScan...\n";
            list($status, $body) = dispatchRequest($kernel, 'PUT', "/api/scans/$scan_id", [
                'notes' => 'Updated test scan',
            ], ['Authorization' => "Bearer $token"]);
            $scan_update_ok = $status === 200;
            $tests['Update Scan (PUT /api/scans/{id})'] = $scan_update_ok ? 'PASS' : "FAIL: status=$status";
            echo "  Status: $status\n\n";
        }
    }
}

// 8. Get defect categories list
echo "[8] Testing GetDefectCategories...\n";
list($status, $body) = dispatchRequest($kernel, 'GET', '/api/defect-categories');
$defect_cat_ok = $status === 200;
$tests['Get Defect Categories (GET /api/defect-categories)'] = $defect_cat_ok ? 'PASS' : "FAIL: status=$status";
echo "  Status: $status\n\n";

// 9. Test logout
if ($token) {
    echo "[9] Testing UserLogout...\n";
    list($status, $body) = dispatchRequest($kernel, 'POST', '/api/auth/logout', [], ['Authorization' => "Bearer $token"]);
    $logout_ok = $status === 200;
    $tests['User Logout (POST /api/auth/logout)'] = $logout_ok ? 'PASS' : "FAIL: status=$status";
    echo "  Status: $status\n\n";
}

// 10. Try accessing protected route after logout (should fail)
if ($token) {
    echo "[10] Testing ProtectedRouteAfterLogout (should fail with 401)...\n";
    list($status, $body) = dispatchRequest($kernel, 'GET', '/api/auth/me', [], ['Authorization' => "Bearer $token"]);
    $logout_verified = $status === 401;
    $tests['Token Invalid After Logout (GET /api/auth/me after logout)'] = $logout_verified ? 'PASS (correctly denied)' : "FAIL: status=$status";
    echo "  Status: $status (expected 401)\n\n";
}

// Print summary
echo "\n========================================\n";
echo "TEST SUMMARY\n";
echo "========================================\n";
$passed = 0;
$failed = 0;
foreach ($tests as $name => $result) {
    $is_pass = strpos($result, 'PASS') !== false;
    $status = $is_pass ? '[PASS]' : '[FAIL]';
    echo "$status $name: $result\n";
    if ($is_pass) {
        $passed++;
    } else {
        $failed++;
    }
}

echo "\n";
echo "TOTAL: " . ($passed + $failed) . " tests\n";
echo "PASSED: $passed\n";
echo "FAILED: $failed\n";
echo "SUCCESS RATE: " . round(($passed / ($passed + $failed)) * 100, 1) . "%\n";
