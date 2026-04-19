<?php
require __DIR__ . '/../vendor/autoload.php';
$app = require_once __DIR__ . '/../bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;

$email = $argv[1] ?? null;
if (!$email) {
    echo "Usage: php scripts/dump_user_pwd.php user@example.com\n";
    exit(1);
}

$u = User::where('email', $email)->first();
if (!$u) {
    echo "User not found: $email\n";
    exit(1);
}

echo "User id={$u->id}, email={$u->email}\n";
echo "password raw: {$u->password}\n";
echo "is bcrypt? " . (preg_match('/^\$2[ayb]\$/' , $u->password) ? 'yes' : 'no') . "\n";
