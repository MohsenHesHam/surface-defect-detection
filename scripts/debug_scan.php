<?php
require __DIR__ . '/../vendor/autopath.php';
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
        $server["HTTP_" . strtoupper(str_replace('-', '_', $k))] = $v;
    }
    
    $request = Request::create($uri, $method, [], [], [], $server, $content);
    $response = $kernel->handle($request);
    $status = $response->getStatusCode();
    $body = $response->getContent();
    $kernel->terminate($request, $response);
    return [$status, $body];
}

// 1. Register
$email = 'debug_' . time() . '@example.com';
$phone = (string) rand(1000000000, 9999999999);
$password = 'Password123';
list($s, $b) = dispatchRequest($kernel, 'POST', '/api/auth/register', [
    'full_name' => 'Debug User',
    'email' => $email,
    'phone' => $phone,
    'password' => $password,
    'password_confirmation' => $password,
]);

// 2. Login
list($s, $b) = dispatchRequest($kernel, 'POST', '/api/auth/login', [
    'email' => $email,
    'password' => $password,
]);

$json = json_decode($b, true);
$token = $json['token'] ?? null;

echo "Token: " . ($token ? 'obtained' : 'failed') . "\n";

if ($token) {
    echo "\n--- Testing CreateScan ---\n";
    list($status, $body) = dispatchRequest($kernel, 'POST', '/api/scans', [
        'camera_model' => 'Canon EOS',
        'location' => 'Test Location',
        'surface_type' => 'metal',
        'notes' => 'Test scan',
    ], ['Authorization' => "Bearer $token"]);
    
    echo "Status: $status\n";
    echo "Body:\n$body\n";
}
