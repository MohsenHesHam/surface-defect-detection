<?php
require __DIR__ . '/../vendor/autoload.php';
$app = require_once __DIR__ . '/../bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;
use Illuminate\Support\Facades\Hash;

echo "Starting rehash process...\n";
$count = 0;
foreach (User::all() as $u) {
    $pwd = $u->password;
    if (!preg_match('/^\$2[ayb]\$/' , $pwd)) {
        // assume stored value is plain text (or non-bcrypt) -> re-hash
        $u->password = Hash::make($pwd);
        $u->save();
        $count++;
        echo "Rehashed user id={$u->id}\n";
    }
}

echo "Done. Rehashed {$count} users.\n";
