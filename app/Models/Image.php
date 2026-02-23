<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Image extends Model
{
    protected $fillable = [
        'scan_id',
        'image_path',
        'processed_image_path',
        'file_size',
        'resolution',
    ];

    public function scan()
    {
        return $this->belongsTo(Scan::class);
    }

    public function defects()
    {
        return $this->hasMany(ImageDefect::class);
    }
}
