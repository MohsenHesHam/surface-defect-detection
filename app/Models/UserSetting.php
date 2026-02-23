<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserSetting extends Model
{
    protected $fillable = [
        'user_id',
        'language',
        'theme',
        'push_notifications',
        'email_notifications',
    ];

    protected $casts = [
        'push_notifications' => 'boolean',
        'email_notifications' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
