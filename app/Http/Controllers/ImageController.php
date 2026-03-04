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
     * Admin sees all images, users see only their scan images
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'admin') {
            return response()->json(Image::with(['scan', 'defects'])->get(), 200);
        }

        // Users see only images from their own scans
        return response()->json(
            Image::whereHas('scan', function ($query) use ($user) {
                $query->where('user_id', $user->id);
            })->with(['scan', 'defects'])->get(),
            200
        );
    }

    /**
     * Store a newly created resource in storage.
     * Admin can add to any scan, users can only add to their own scans
     */
    public function store(Request $request)
    {
        $user = $request->user();

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

        // Check if user has permission to add image to this scan
        $scan = \App\Models\Scan::find($validated['scan_id']);
        if ($user->role !== 'admin' && $scan->user_id !== $user->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only add images to your own scans.'
            ], 403);
        }

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
     * Admin can view any image, users can only view their scan images
     */
    public function show(Request $request, Image $image)
    {
        if ($request->user()->role !== 'admin' && $image->scan->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only view your own scan images.'
            ], 403);
        }

        return response()->json($image->load(['scan', 'defects']), 200);
    }

    /**
     * Update the specified resource in storage.
     * Admin can update any image, users can only update their scan images
     */
    public function update(Request $request, Image $image)
    {
        if ($request->user()->role !== 'admin' && $image->scan->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only update your own scan images.'
            ], 403);
        }

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
     * Admin can delete any image, users can only delete their scan images
     */
    public function destroy(Request $request, Image $image)
    {
        if ($request->user()->role !== 'admin' && $image->scan->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized. You can only delete your own scan images.'
            ], 403);
        }

        $image->delete();

        return response()->json(null, 204);
    }
}
