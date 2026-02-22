<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ImageDefect extends Model
{
    protected $fillable = [
        'image_id',
        'defect_category_id',
        'confidence',
        'bounding_box',
    ];

    protected $casts = [
        'bounding_box' => 'array',
    ];

    public function image()
    {
        return $this->belongsTo(Image::class);
    }

    public function defectCategory()
    {
        return $this->belongsTo(DefectCategory::class);
    }
}
