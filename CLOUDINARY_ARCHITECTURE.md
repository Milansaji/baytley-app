# Cloudinary Integration Architecture

## System Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER APP                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  [Blog/Testimonial Management Screen]                            │
│              ↓                                                    │
│  [Image Picker] ──→ [Select from Gallery]                        │
│              ↓                                                    │
│  [Preview Selected Image]                                        │
│              ↓                                                    │
│  [Upload Button] ──→ CloudinaryService.uploadFile()              │
│              ↓                                                    │
│  [Fill Form Details + Secure URL]                                │
│              ↓                                                    │
│  [Save Button] ──→ BLoC Event                                    │
│              ↓                                                    │
│  [Repository Layer]                                              │
│              ↓                                                    │
│  Firebase + Cloudinary Update                                    │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│ UI LAYER                                                          │
├─────────────────────────────────────────────────────────────────┤
│ • AddEditBlogScreen                   (Image picker + Preview)   │
│ • AddEditTestimonialScreen            (Image picker + Preview)   │
│ • BlogManagementScreen                (Delete integration)       │
│ • TestimonialManagementScreen         (Delete integration)       │
└────────────────────┬────────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────────┐
│ BLoC/STATE MANAGEMENT                                            │
├─────────────────────────────────────────────────────────────────┤
│ • BlogBloc / BlogEvent / BlogState                               │
│ • TestimonialBloc / TestimonialEvent / TestimonialState          │
│                                                                   │
│ Events: AddEvent, UpdateEvent(+oldImageUrl), DeleteEvent         │
└────────────────────┬────────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────────┐
│ REPOSITORY LAYER                                                 │
├─────────────────────────────────────────────────────────────────┤
│ • BlogRepository                                                 │
│   - updateBlog(blog, oldImageUrl) ──→ calls CloudinaryService   │
│   - deleteBlog(id) ──→ calls CloudinaryService                  │
│                                                                   │
│ • TestimonialRepository                                          │
│   - updateTestimonial(testimonial, oldAvatarUrl)                 │
│   - deleteTestimonial(id)                                        │
└────────────────────┬────────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────────┐
│ SERVICE LAYER                                                    │
├─────────────────────────────────────────────────────────────────┤
│ • CloudinaryService                                              │
│   - uploadFile(File) ──→ HTTP Multipart POST                    │
│   - deleteFile(url) ──→ Extract Public ID + HTTP DELETE         │
│   - _extractPublicIdFromUrl(url)                                 │
│   - _parseJsonResponse(body)                                     │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ├─────────→ [Cloudinary API]
                     │           (Upload & Delete)
                     │
                     └─────────→ [Firebase Firestore]
                                 (Save URLs)
```

## Data Flow on Create

```
User Input
    ↓
[File selected from gallery]
    ↓
CloudinaryService.uploadFile(File)
    ↓
HTTP POST (multipart) to Cloudinary
    ↓
Cloudinary returns { secure_url: "https://..." }
    ↓
[Image URL stored in _imageUrl variable]
    ↓
[User fills form + clicks Save]
    ↓
Blog/TestimonialModel created with imageUrl
    ↓
AddBlogEvent/AddTestimonialEvent
    ↓
Repository.addBlog/addTestimonial()
    ↓
Firebase saves blog with imageUrl
    ↓
BLoC emits Loaded state
    ↓
UI shows success message
```

## Data Flow on Update with Image Change

```
User Input
    ↓
[Existing blog with old imageUrl loaded]
    ↓
[File selected from gallery]
    ↓
CloudinaryService.uploadFile(File) 
    ↓
Cloudinary returns new secure_url
    ↓
[New image URL stored in _imageUrl]
    ↓
[User clicks Save]
    ↓
UpdateBlogEvent(blog, oldImageUrl: oldBlog.imageUrl)
    ↓
BLoC._onUpdateBlog()
    ↓
Repository.updateBlog(blog, oldImageUrl)
    ↓
Check: oldImageUrl != newImageUrl?
    ├─ YES: CloudinaryService.deleteFile(oldImageUrl)
    │       (Extract public ID + HTTP DELETE)
    │
    └─ NO: Skip deletion
    ↓
Firebase.update(blog)
    ↓
BLoC emits Loaded state
    ↓
UI shows success message
```

## Data Flow on Delete

```
User clicks delete on blog/testimonial
    ↓
DeleteBlogEvent(id)
    ↓
BLoC._onDeleteBlog()
    ↓
Repository.deleteBlog(id)
    ↓
Firestore.get(id) 
    │
    ├─ Retrieve blog document
    └─ Extract imageUrl from document
    ↓
Check: imageUrl.isNotEmpty?
    ├─ YES: CloudinaryService.deleteFile(imageUrl)
    │       (Extract public ID + HTTP DELETE)
    │       (Silent failure if not found)
    │
    └─ NO: Skip deletion
    ↓
Firestore.delete(id)
    ↓
BLoC.add(FetchEvent()) - Refresh list
    ↓
UI updates with deleted item removed
```

## Class Relationships

```
┌──────────────────────┐
│   CloudinaryService  │
│  (Static Methods)    │
├──────────────────────┤
│ + uploadFile(File)   │
│ + deleteFile(url)    │
│ - extractPublicId()  │
│ - parseJson()        │
└──────┬───────────────┘
       ↑
       │ uses
       │
┌──────┴───────────────────┐
│   BlogRepository          │
│ + addBlog()              │
│ + updateBlog()           │ ─→ BlogModel
│ + deleteBlog()           │
│ + fetchBlogs()           │
└──────────────────────────┘

┌──────────────────────────────┐
│ TestimonialRepository         │
│ + addTestimonial()           │
│ + updateTestimonial()        │ ─→ TestimonialModel
│ + deleteTestimonial()        │
│ + fetchTestimonials()        │
└──────────────────────────────┘
```

## API Endpoints

```
Upload Endpoint:
POST https://api.cloudinary.com/v1_1/{cloudName}/image/upload
Content-Type: multipart/form-data
Fields:
  - file: <binary image data>
  - upload_preset: baytley_uploads

Response:
{
  "public_id": "baytley_uploads/xxx",
  "secure_url": "https://res.cloudinary.com/xxx/image/upload/v1234/xxx.jpg",
  ...
}

Delete Endpoint:
POST https://api.cloudinary.com/v1_1/{cloudName}/image/destroy
Content-Type: multipart/form-data
Fields:
  - public_id: baytley_uploads/xxx
  - upload_preset: baytley_uploads

Response:
{
  "result": "ok"
}
```

## Error Handling Strategy

```
Upload Fails:
    ↓
Show SnackBar with error message
    ↓
User can retry image selection
    ↓
Form is not submitted

Delete Fails:
    ↓
Log error (silent)
    ↓
Continue with blog/testimonial deletion
    ↓
Cloudinary garbage collection handles orphaned images

Firebase Fails:
    ↓
Show error to user
    ↓
User can retry
```

## Security Model

```
Request Flow:
User App ──[HTTP]──→ Cloudinary API
            ↓
         No API Keys exposed
         ✅ Unsigned upload preset
         ✅ Folder-restricted preset
         ✅ File size limits (Cloudinary side)
         ✅ Format validation (Cloudinary side)

Data Storage:
User Device ─→ Cloudinary (Image)
             ─→ Firebase (Metadata + URL)
             
Deletion:
         Public ID extracted from URL
         ✅ Can only delete with public ID
         ✅ No full API key needed
         ✅ Minimal exposure risk
```
