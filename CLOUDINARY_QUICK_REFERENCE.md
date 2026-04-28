# Quick Reference: Image Upload Usage

## For Developers

### CloudinaryService Methods

```dart
// Upload a file
String imageUrl = await CloudinaryService.uploadFile(file);

// Delete a file (using URL)
await CloudinaryService.deleteFile(imageUrl);
```

### Using in Blog Management

```dart
// In your code:
final blog = BlogModel(
  id: blogId,
  title: 'My Blog',
  author: 'John',
  category: 'Tech',
  content: 'Content here',
  imageUrl: uploadedImageUrl,  // URL from CloudinaryService
  updatedAt: DateTime.now(),
);

// When updating, pass old image URL for automatic deletion:
context.read<BlogBloc>().add(
  UpdateBlogEvent(blog, oldImageUrl: oldBlog.imageUrl),
);
```

### Using in Testimonial Management

```dart
// Similar to blogs, but with avatarUrl
final testimonial = TestimonialModel(
  id: testimonialId,
  name: 'John Doe',
  role: 'Manager',
  content: 'Great work!',
  avatarUrl: uploadedAvatarUrl,  // URL from CloudinaryService
  company: 'ABC Corp',
  rating: 5,
  createdAt: DateTime.now(),
);

// When updating:
context.read<TestimonialBloc>().add(
  UpdateTestimonialEvent(testimonial, oldAvatarUrl: oldTestimonial.avatarUrl),
);
```

## Cloudinary Dashboard

To verify uploads and manage images:
1. Go to: https://cloudinary.com/console
2. Cloud Name: 874d49a4-779a-4506-b6a7-8620dab97476
3. Look for images uploaded under "baytley_uploads" preset
4. Media Library shows all uploaded files
5. You can manually delete files from dashboard if needed

## Troubleshooting

### Image URL is empty after upload
- Check network connectivity
- Verify Cloudinary credentials are correct
- Check upload preset settings in Cloudinary dashboard

### Old images not deleting
- Check Cloudinary logs for deletion errors
- Verify image URL format is correct
- Note: Deletion failures don't break the app (silent fail)

### Images showing as blank
- Verify the imageUrl is not empty
- Check if Image.network() is being used correctly
- Verify Cloudinary CDN is accessible from the device

## File Structure

```
lib/
├── core/
│   └── services/
│       └── cloudinary_service.dart (NEW)
├── features/
│   ├── blog/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── blog_model.dart (MODIFIED)
│   │   │   └── repositories/
│   │   │       └── blog_repository.dart (MODIFIED)
│   │   ├── bloc/
│   │   │   ├── blog_event.dart (MODIFIED)
│   │   │   └── blog_bloc.dart (MODIFIED)
│   │   └── screens/
│   │       ├── add_edit_blog_screen.dart (MODIFIED)
│   │       └── blog_management_screen.dart (MODIFIED)
│   └── testimonials/
│       ├── data/
│       │   ├── models/
│       │   │   └── testimonial_model.dart (MODIFIED)
│       │   └── testimonial_repository.dart (MODIFIED)
│       ├── bloc/
│       │   ├── testimonial_event.dart (MODIFIED)
│       │   └── testimonial_bloc.dart (MODIFIED)
│       └── screens/
│           ├── add_edit_testimonial_screen.dart (MODIFIED)
│           └── testimonial_management_screen.dart (MODIFIED)
└── pubspec.yaml (MODIFIED - added http and image_picker)
```

## Key Features Implemented

✅ Direct file upload to Cloudinary (not via URL)
✅ Automatic image deletion on blog/testimonial delete
✅ Automatic deletion of old images on update
✅ Image picker integration for gallery selection
✅ Upload progress UI feedback
✅ Error handling and user notifications
✅ Unsigned uploads (no API key in app)
✅ Backward compatibility with old avatar field
✅ Support for both blogs and testimonials
