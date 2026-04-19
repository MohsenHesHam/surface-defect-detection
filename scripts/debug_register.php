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
        $server["HTTP_" . strtoupper(str_replace('-', '_', $k))] = $v;
    }
    
    $request = Request::create($uri, $method, [], [], [], $server, $content);
    $response = $kernel->handle($request);
    $status = $response->getStatusCode();
    $body = $response->getContent();
    $kernel->terminate($request, $response);
    return [$status, $body];
}

$email = 'test_' . time() . '@example.com';
$password = 'Password123';
$phone = rand(1000000000, 9999999999);

echo "Testing register with:\n";
echo "  email: $email\n";
echo "  phone: $phone\n";
echo "  password: $password\n\n";

list($status, $body) = dispatchRequest($kernel, 'POST', '/api/auth/register', [
    'full_name' => 'Test User',
    'email' => $email,
    'phone' => (string) $phone,
    'password' => $password,
    'password_confirmation' => $password,
]);

echo "Response status: $status\n";
echo "Response body:\n";
echo $body . "\n";
