<?php
require __DIR__ . '/../vendor/autoload.php';
$app = require_once __DIR__ . '/../bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

use Illuminate\Http\Request;

function dispatchRequest($kernel, $method, $uri, $data = []) {
    $content = json_encode($data);
    $server = [
        'CONTENT_TYPE' => 'application/json',
        'HTTP_ACCEPT' => 'application/json',
    ];
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

$email = 'smoke_' . time() . '@example.com';
$password = 'Password123';

// Register
list($s1, $b1) = dispatchRequest($kernel, 'POST', '/api/auth/register', [
    'full_name' => 'Smoke Test',
    'email' => $email,
    'phone' => '01112223344',
    'password' => $password,
    'password_confirmation' => $password,
]);

// Login
list($s2, $b2) = dispatchRequest($kernel, 'POST', '/api/auth/login', [
    'email' => $email,
    'password' => $password,
]);

// Show results summary
echo "SUMMARY:\n";
echo "Register status: $s1\n";
echo "Login status: $s2\n";

// If login returned token, print token
$json = json_decode($b2, true);
if (isset($json['token'])) {
    echo "Token received: ".($json['token'])."\n";
}
