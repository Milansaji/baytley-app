import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../bloc/testimonial_bloc.dart';
import '../bloc/testimonial_event.dart';
import '../models/testimonial_model.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/services/cloudinary_service.dart';

class AddEditTestimonialScreen extends StatefulWidget {
  final TestimonialModel? testimonial;

  const AddEditTestimonialScreen({super.key, this.testimonial});

  @override
  State<AddEditTestimonialScreen> createState() =>
      _AddEditTestimonialScreenState();
}

class _AddEditTestimonialScreenState extends State<AddEditTestimonialScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _contentController;
  late TextEditingController _companyController;
  
  File? _selectedImage;
  String _avatarUrl = '';
  bool _isUploading = false;
  late int _rating;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.testimonial?.name ?? '',
    );
    _roleController = TextEditingController(
      text: widget.testimonial?.role ?? '',
    );
    _contentController = TextEditingController(
      text: widget.testimonial?.content ?? '',
    );
    _companyController = TextEditingController(
      text: widget.testimonial?.company ?? '',
    );
    _avatarUrl = widget.testimonial?.avatarUrl ?? '';
    _rating = widget.testimonial?.rating ?? 5;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _contentController.dispose();
    _companyController.dispose();
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
      setState(() => _avatarUrl = imageUrl);
      
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
      if (_avatarUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t('Please upload an image', 'يرجى تحميل صورة'))),
        );
        return;
      }
    }

    final testimonial = TestimonialModel(
      id: widget.testimonial?.id ?? '',
      name: _nameController.text,
      role: _roleController.text,
      content: _contentController.text,
      avatarUrl: _avatarUrl,
      company: _companyController.text,
      rating: _rating,
      createdAt: widget.testimonial?.createdAt ?? DateTime.now(),
    );

    if (widget.testimonial == null) {
      context.read<TestimonialBloc>().add(AddTestimonialEvent(testimonial));
    } else {
      // Pass old avatar URL so it can be deleted from Cloudinary if changed
      context.read<TestimonialBloc>().add(
        UpdateTestimonialEvent(testimonial, oldAvatarUrl: widget.testimonial!.avatarUrl),
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.testimonial != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? context.t('Edit Testimonial', 'تعديل التوصية')
              : context.t('Add Testimonial', 'إضافة توصية'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Avatar Upload Section
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
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
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else if (_avatarUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _avatarUrl,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 150,
                      width: 150,
                      color: Colors.grey[800],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              context.t('No image', 'لا توجد صورة'),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isUploading ? null : _pickImage,
                            icon: const Icon(Icons.image),
                            label: Text(context.t('Pick Avatar', 'اختر الصورة')),
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
            
            // Form Fields
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.t('Name', 'الاسم'),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(
                labelText: context.t('Company', 'الشركة'),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _roleController,
              decoration: InputDecoration(
                labelText: context.t('Role', 'الدور / المسمى'),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.t('Rating', 'التقييم')),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => setState(() => _rating = index + 1),
                      );
                    }),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: context.t('Content', 'المحتوى'),
              ),
              maxLines: 5,
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
