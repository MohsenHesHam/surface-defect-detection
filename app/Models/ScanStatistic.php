<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ScanStatistic extends Model
{
    protected $table = 'scan_statistics';

    protected $fillable = [
        'scan_id',
        'total_defects',
        'passed_count',
        'defect_count',
        'accuracy',
        'processing_time',
    ];

    public function scan()
    {
        return $this->belongsTo(Scan::class);
    }
}
