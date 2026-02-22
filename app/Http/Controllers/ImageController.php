<?php

namespace App\Http\Controllers;

use App\Models\Image;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ImageController extends Controller
{ 

 
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(Image::with(['scan', 'defects'])->get(), 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // support multipart file upload or direct path
        $rules = [
            'scan_id' => 'required|exists:scans,id',
            'processed_image_path' => 'nullable|string',
            'file_size' => 'nullable|integer|min:0',
            'resolution' => 'nullable|string',
        ];

        if ($request->hasFile('file')) {
            $rules['file'] = 'file|mimes:jpg,jpeg,png,bmp,tiff|max:51200';
        } else {
            $rules['image_path'] = 'required|string';
        }

        $validated = $request->validate($rules);

        if ($request->hasFile('file')) {
            $file = $request->file('file');
            $filename = Str::random(24) . '.' . $file->getClientOriginalExtension();
            $path = $file->storeAs('images', $filename, 'public');
            $imagePath = Storage::url($path);
            $validated['image_path'] = $imagePath;
            $validated['file_size'] = $file->getSize();
        }

        $image = Image::create($validated);

        return response()->json($image->load(['scan', 'defects']), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Image $image)
    {
        return response()->json($image->load(['scan', 'defects']), 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Image $image)
    {
        $validated = $request->validate([
            'image_path' => 'nullable|string',
            'processed_image_path' => 'nullable|string',
            'file_size' => 'nullable|integer|min:0',
            'resolution' => 'nullable|string',
        ]);

        $image->update($validated);

        return response()->json($image->load(['scan', 'defects']), 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Image $image)
    {
        $image->delete();

        return response()->json(null, 204);
    }
}
