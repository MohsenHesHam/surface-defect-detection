<?php
require __DIR__ . '/../vendor/autoload.php';
$app = require_once __DIR__ . '/../bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

use Illuminate\Http\Request;

function dispatchRequest($kernel, $method, $uri, $data = [], $headers = []) {
    $content = json_encode($data);
    $server = [
        'CONTENT_TYPE' => 'application/json',
        'HTTP_ACCEPT' => 'application/json',
    ];
    foreach ($headers as $k => $v) {
        $server[$k] = $v;
    }
    $request = Request::create($uri, $method, [], [], [], $server, $content);
    $response = $kernel->handle($request);
    $status = $response->getStatusCode();
    $body = $response->getContent();
    $kernel->terminate($request, $response);
    return [$status, $body];
}

$results = [];
$email = 'test_' . time() . '@example.com';
$phone = '01' . rand(100000000, 999999999);
$password = 'Password123';

echo "=== COMPREHENSIVE API TEST ===\n\n";

// 1. Register
echo "1. Testing Register...\n";
list($s, $b) = dispatchRequest($kernel, 'POST', '/api/auth/register', [
    'full_name' => 'Test User',
    'email' => $email,
    'phone' => $phone,
    'password' => $password,
    'password_confirmation' => $password,
]);
$results['register'] = $s === 201 ? '✅ PASS' : "❌ FAIL ($s)";
echo "Status: $s\n";
if ($s !== 201) {
    echo "Error: $b\n";
}
echo "\n";

// 2. Login
echo "2. Testing Login...\n";
list($s, $b) = dispatchRequest($kernel, 'POST', '/api/auth/login', [
    'email' => $email,
    'password' => $password,
]);
$results['login'] = $s === 200 ? '✅ PASS' : "❌ FAIL ($s)";
echo "Status: $s\n";
$json = json_decode($b, true);
$token = $json['token'] ?? null;
if (!$token) {
    echo "Error: No token received\n";
    echo "Response: $b\n";
}
echo "\n";

if (!$token) {
    echo "Cannot continue tests without token.\n";
    exit(1);
}

// 3. Get Profile
echo "3. Testing Get Profile (/api/auth/me)...\n";
list($s, $b) = dispatchRequest($kernel, 'GET', '/api/auth/me', [], ['HTTP_AUTHORIZATION' => 'Bearer ' . $token]);
$results['get_profile'] = $s === 200 ? '✅ PASS' : "❌ FAIL ($s)";
echo "Status: $s\n";
if ($s !== 200) {
    echo "Error: $b\n";
}
echo "\n";

// 4. Send Email Verification
echo "4. Testing Send Email Verification...\n";
list($s, $b) = dispatchRequest($kernel, 'POST', '/api/auth/send-email-verification', [
    'email' => $email,
]);
$results['send_otp'] = $s === 200 ? '✅ PASS' : "❌ FAIL ($s)";
echo "Status: $s\n";
$json = json_decode($b, true);
$otp_code = $json['code'] ?? null;
if ($otp_code) {
    echo "OTP Code (for testing): $otp_code\n";
}
if ($s !== 200) {
    echo "Error: $b\n";
}
echo "\n";

// 5. Verify Email
if ($otp_code) {
    echo "5. Testing Verify Email...\n";
    list($s, $b) = dispatchRequest($kernel, 'POST', '/api/auth/verify-email', [
        'email' => $email,
        'code' => (string)$otp_code,
    ]);
    $results['verify_otp'] = $s === 200 ? '✅ PASS' : "❌ FAIL ($s)";
    echo "Status: $s\n";
    if ($s !== 200) {
        echo "Error: $b\n";
    }
    echo "\n";
}

// 6. Logout
echo "6. Testing Logout...\n";
list($s, $b) = dispatchRequest($kernel, 'POST', '/api/auth/logout', [], ['HTTP_AUTHORIZATION' => 'Bearer ' . $token]);
$results['logout'] = $s === 200 ? '✅ PASS' : "❌ FAIL ($s)";
echo "Status: $s\n";
if ($s !== 200) {
    echo "Error: $b\n";
}
echo "\n";

// 7. Test protected route should fail without token
echo "7. Testing Protected Route (should fail without token)...\n";
// Re-bootstrap the application to ensure no previous auth state persists
$app2 = require __DIR__ . '/../bootstrap/app.php';
$kernel2 = $app2->make(Illuminate\Contracts\Http\Kernel::class);
list($s, $b) = dispatchRequest($kernel2, 'GET', '/api/auth/me', []);
$results['protected_no_token'] = $s === 401 ? '✅ PASS (correctly denied)' : "❌ FAIL ($s - should be 401)";
echo "Status: $s (expected 401)\n";
echo "\n";

// Summary
echo "=== TEST SUMMARY ===\n";
foreach ($results as $test => $result) {
    echo "$test: $result\n";
}

$passed = count(array_filter($results, fn($r) => strpos($r, '✅') === 0));
$total = count($results);
echo "\nPassed: $passed/$total\n";

if ($passed === $total) {
    echo "\n🎉 ALL TESTS PASSED! Ready to push to GitHub.\n";
    exit(0);
} else {
    echo "\n⚠️  Some tests failed. Fix issues before pushing.\n";
    exit(1);
}
