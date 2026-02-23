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
    echo "=== $method $uri ===\n";
    echo "Status: $status\n";
    echo "Body: $body\n\n";
    $kernel->terminate($request, $response);
    return [$status, $body];
}

$email = 'flow_' . time() . '@example.com';
$phone = '01' . rand(200000000, 999999999);
$password = 'Password123';

// Register
list($r1, $b1) = dispatchRequest($kernel, 'POST', '/api/auth/register', [
    'full_name' => 'Flow Test',
    'email' => $email,
    'phone' => $phone,
    'password' => $password,
    'password_confirmation' => $password,
]);

// Login
list($r2, $b2) = dispatchRequest($kernel, 'POST', '/api/auth/login', [
    'email' => $email,
    'password' => $password,
]);

$tok = null;
$json = json_decode($b2, true);
if (isset($json['token'])) $tok = $json['token'];

if ($tok) {
    // Call logout with Authorization header
    $headers = ['HTTP_AUTHORIZATION' => 'Bearer ' . $tok];
    list($r3, $b3) = dispatchRequest($kernel, 'POST', '/api/auth/logout', [], $headers);
} else {
    echo "No token received; cannot call logout.\n";
}

