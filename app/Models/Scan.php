<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Scan extends Model
{
    protected $fillable = [
        'user_id',
        'scan_type',
        'total_images',
        'status',
        'completed_at',
    ];

    protected $casts = [
        'completed_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function images()
    {
        return $this->hasMany(Image::class);
    }

    public function activities()
    {
        return $this->hasMany(Activity::class);
    }

    public function statistics()
    {
        return $this->hasOne(ScanStatistic::class);
    }
}
