<?php
require __DIR__ . '/../vendor/autoload.php';
$app = require_once __DIR__ . '/../bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

use Illuminate\Http\Request;

$email = $argv[1] ?? null;
$password = $argv[2] ?? null;
if (!$email || !$password) {
    echo "Usage: php scripts/login_test.php email password\n";
    exit(1);
}

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

list($s, $b) = dispatchRequest($kernel, 'POST', '/api/auth/login', [
    'email' => $email,
    'password' => $password,
]);

echo "Summary: status=$s\n";
