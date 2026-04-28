# Cloudinary Image Upload Implementation Summary

## Overview
Successfully implemented Cloudinary integration for the Baytley Flutter app to handle direct file uploads with automatic deletion of old images when blogs or testimonials are updated/deleted.

## Cloudinary Credentials Used
- **Cloud Name:** 874d49a4-779a-4506-b6a7-8620dab97476
- **Upload Preset:** baytley_uploads
- **Upload Type:** Unsigned (no API key required in client)

## Changes Made

### 1. **Created CloudinaryService** (`lib/core/services/cloudinary_service.dart`)
A new service class that handles all Cloudinary operations:

**Key Methods:**
- `uploadFile(File file)` - Uploads a file to Cloudinary and returns the secure URL
- `deleteFile(String imageUrl)` - Deletes an image from Cloudinary using its public ID
- `_extractPublicIdFromUrl(String url)` - Extracts the public ID from Cloudinary URL
- `_parseJsonResponse(String responseBody)` - Parses Cloudinary API responses

**Features:**
- Uses unsigned upload preset for client-side uploads (no server required)
- Automatic public ID extraction from URLs
- Silent failure on deletion (doesn't break operation if deletion fails)
- MultipartRequest for file streaming

### 2. **Updated Models**

#### BlogModel (`lib/features/blog/data/models/blog_model.dart`)
- Added `imageUrl` field to store the Cloudinary image URL
- Updated `fromFirestore()` to read imageUrl
- Updated `toMap()` to include imageUrl

#### TestimonialModel (`lib/features/testimonials/models/testimonial_model.dart`)
- Renamed `avatar` field to `avatarUrl`
- Added fallback support for old `avatar` field for backward compatibility
- Updated `fromFirestore()` and `toMap()` methods

### 3. **Updated Repositories**

#### BlogRepository (`lib/features/blog/data/repositories/blog_repository.dart`)
- Modified `updateBlog()` to accept `oldImageUrl` parameter and delete old image if changed
- Modified `deleteBlog()` to retrieve and delete the associated image from Cloudinary before deleting the blog document

#### TestimonialRepository (`lib/features/testimonials/data/testimonial_repository.dart`)
- Modified `updateTestimonial()` to accept `oldAvatarUrl` parameter and delete old image if changed
- Modified `deleteTestimonial()` to retrieve and delete the associated image from Cloudinary before deleting the testimonial document

### 4. **Updated BLoC Events**

#### BlogEvent (`lib/features/blog/bloc/blog_event.dart`)
- Modified `UpdateBlogEvent` to accept optional `oldImageUrl` parameter

#### TestimonialEvent (`lib/features/testimonials/bloc/testimonial_event.dart`)
- Modified `UpdateTestimonialEvent` to accept optional `oldAvatarUrl` parameter

### 5. **Updated BLoCs**

#### BlogBloc (`lib/features/blog/bloc/blog_bloc.dart`)
- Modified `_onUpdateBlog()` to pass oldImageUrl to repository

#### TestimonialBloc (`lib/features/testimonials/bloc/testimonial_bloc.dart`)
- Modified `_onUpdateTestimonial()` to pass oldAvatarUrl to repository

### 6. **Updated UI Screens**

#### AddEditBlogScreen (`lib/features/blog/screens/add_edit_blog_screen.dart`)
**New Features:**
- Image picker with gallery selection
- Image preview (selected or existing)
- Upload button with progress indicator
- Upload status feedback with SnackBar
- Automatic image upload before saving
- Passes old image URL to BLoC for deletion
- Disables save button during upload

**New State Variables:**
- `_selectedImage` - File object of selected image
- `_imageUrl` - Current image URL
- `_isUploading` - Upload progress state

#### AddEditTestimonialScreen (`lib/features/testimonials/screens/add_edit_testimonial_screen.dart`)
**New Features:**
- Similar image picker functionality for avatar
- Circular avatar preview
- Upload button with progress indicator
- Same upload status feedback and automatic upload
- Passes old avatar URL to BLoC for deletion

### 7. **Updated Dependencies**
Added to `pubspec.yaml`:
- `http: ^1.2.0` - For HTTP multipart requests
- `image_picker: ^1.1.2` - For image selection from gallery

### 8. **Updated Management Screens**

#### TestimonialManagementScreen
- Changed `item.avatar` to `item.avatarUrl` to match new field name

## Workflow

### Creating a New Blog/Testimonial with Image:
1. User picks an image from gallery
2. User fills in form details
3. On save, image is uploaded to Cloudinary
4. After successful upload, blog/testimonial is saved with imageUrl
5. User gets success notification

### Updating Blog/Testimonial with New Image:
1. User picks a new image from gallery
2. User fills in form details
3. On save, new image is uploaded to Cloudinary
4. Old image public ID is extracted from old URL
5. Blog/testimonial is updated with new imageUrl
6. Old image is deleted from Cloudinary

### Deleting Blog/Testimonial:
1. Blog/testimonial document is retrieved to get imageUrl
2. Image public ID is extracted from the URL
3. Image is deleted from Cloudinary
4. Blog/testimonial document is deleted from Firebase

## Important Notes

1. **Unsigned Uploads**: The implementation uses unsigned uploads via upload preset, which means:
   - No API key is stored in the app
   - File uploads go directly to Cloudinary
   - No server-side image handling required

2. **Public ID Extraction**: The service automatically extracts the public ID from Cloudinary URLs in the format:
   - Standard: `https://res.cloudinary.com/{cloud}/image/upload/{version}/{public-id}`
   - Removes version prefix and file extension automatically

3. **Error Handling**: 
   - Image upload failures show user-friendly error messages
   - Image deletion failures are silent (don't break operations)
   - Form validation prevents saving without uploaded images when needed

4. **Backward Compatibility**: TestimonialModel supports both `avatar` and `avatarUrl` fields to prevent issues with existing data

## Testing Recommendations

1. Create a new blog with image upload
2. Update blog with new image - verify old image is deleted
3. Delete blog - verify image is deleted from Cloudinary
4. Repeat same tests for testimonials
5. Test with invalid image files
6. Test with poor network conditions
7. Verify Cloudinary dashboard shows uploaded images

## Security Considerations

- Upload preset is public but limited to specific folder in Cloudinary
- No sensitive API keys in the app
- Deletion requires matching public ID (minimal exposure risk)
- Images are stored in Cloudinary (not Firebase Storage)
