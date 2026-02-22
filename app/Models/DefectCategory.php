<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DefectCategory extends Model
{
    protected $fillable = [
        'name',
        'description',
        'severity_level',
    ];

    public function imageDefects()
    {
        return $this->hasMany(ImageDefect::class);
    }
}
