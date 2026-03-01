<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;

class User extends Model
{
    use HasApiTokens;

    protected $fillable = [
        'full_name',
        'email',
        'phone',
        'password',
        'avatar',
        'email_verified_at',
        'phone_verified_at',
        'account_status',
    ];

    protected $hidden = [
        'remember_token',
        'password',
    ]; 

    protected $casts = [
        'email_verified_at' => 'datetime',
        'phone_verified_at' => 'datetime',
    ];

    public function scans()
    {
        return $this->hasMany(Scan::class);
    }

    public function activities()
    {
        return $this->hasMany(Activity::class);
    }

    public function notifications()
    {
        return $this->hasMany(Notification::class);
    }

    public function settings()
    {
        return $this->hasOne(UserSetting::class);
    }
}
