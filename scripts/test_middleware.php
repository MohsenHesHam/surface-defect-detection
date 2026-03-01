<?php
require __DIR__ . '/../vendor/autoload.php';
$app = require_once __DIR__ . '/../bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

use Illuminate\Http\Request;

function dispatchRequest($kernel, $method, $uri, $data = [], $headers = []) {
    $content = json_encode($data);
    $server = array_merge([
        'CONTENT_TYPE' => 'application/json',
        'HTTP_ACCEPT' => 'application/json',
    ], $headers);
    
    $request = Request::create($uri, $method, [], [], [], $server, $content);
    $response = $kernel->handle($request);
    $status = $response->getStatusCode();
    $body = $response->getContent();
    $kernel->terminate($request, $response);
    return [$status, $body];
}

// Test protected route without token
echo "Testing /api/scans without token (should return 401)...\n";
list($status, $body) = dispatchRequest($kernel, 'GET', '/api/scans');
echo "Status: $status\n";
echo "Body: $body\n\n";

if ($status === 401) {
    echo "✅ Middleware is working correctly - protected routes deny access without token\n";
} else {
    echo "⚠️  Expected 401, got $status\n";
}
