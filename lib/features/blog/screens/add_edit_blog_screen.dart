import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../data/models/blog_model.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/services/cloudinary_service.dart';

class AddEditBlogScreen extends StatefulWidget {
  final BlogModel? blog;

  const AddEditBlogScreen({super.key, this.blog});

  @override
  State<AddEditBlogScreen> createState() => _AddEditBlogScreenState();
}

class _AddEditBlogScreenState extends State<AddEditBlogScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _categoryController;
  late TextEditingController _contentController;
  
  File? _selectedImage;
  String _imageUrl = '';
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blog?.title ?? '');
    _authorController = TextEditingController(text: widget.blog?.author ?? '');
    _categoryController = TextEditingController(
      text: widget.blog?.category ?? '',
    );
    _contentController = TextEditingController(
      text: widget.blog?.content ?? '',
    );
    _imageUrl = widget.blog?.imageUrl ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      final imageUrl = await CloudinaryService.uploadFile(_selectedImage!);
      setState(() => _imageUrl = imageUrl);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t('Image uploaded successfully', 'تم تحميل الصورة بنجاح')),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t('Error uploading image: ', 'خطأ في تحميل الصورة: ') + e.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // If user selected a new image, upload it first
    if (_selectedImage != null) {
      await _uploadImage();
      if (_imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t('Please upload an image', 'يرجى تحميل صورة'))),
        );
        return;
      }
    }

    final blog = BlogModel(
      id: widget.blog?.id ?? '',
      title: _titleController.text,
      author: _authorController.text,
      category: _categoryController.text,
      content: _contentController.text,
      imageUrl: _imageUrl,
      updatedAt: DateTime.now(),
    );

    if (widget.blog == null) {
      context.read<BlogBloc>().add(AddBlogEvent(blog));
    } else {
      // Pass old image URL so it can be deleted from Cloudinary if changed
      context.read<BlogBloc>().add(
        UpdateBlogEvent(blog, oldImageUrl: widget.blog!.imageUrl),
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.blog != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          isEdit
              ? context.t('Edit Blog', 'تعديل المدونة')
              : context.t('Add Blog', 'إضافة مدونة'),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
              // Image Upload Section
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[50],
                ),
                child: Column(
                  children: [
                    if (_selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else if (_imageUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 150,
                        color: Colors.grey[100],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 40, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(
                                context.t('No image selected', 'لم يتم اختيار صورة'),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isUploading ? null : _pickImage,
                              icon: const Icon(Icons.image),
                              label: Text(context.t('Pick Image', 'اختر صورة')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          if (_selectedImage != null) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isUploading ? null : _uploadImage,
                                icon: _isUploading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor,
                                              ),
                                        ),
                                      )
                                    : const Icon(Icons.upload),
                                label: Text(
                                  _isUploading
                                      ? context.t('Uploading...', 'جاري التحميل...')
                                      : context.t('Upload', 'رفع'),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Blog Form Fields
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: context.t('Title', 'العنوان'),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: context.t('Author', 'المؤلف'),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: context.t('Category', 'الفئة'),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: context.t('Content (Markdown)', 'المحتوى'),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                maxLines: 10,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isUploading ? null : _save,
                child: Text(context.t('Save', 'حفظ')),
              ),
            ],
          ),
        ),
      );
  }
}
