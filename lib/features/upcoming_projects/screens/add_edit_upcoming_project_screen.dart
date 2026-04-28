import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../bloc/upcoming_project_bloc.dart';
import '../bloc/upcoming_project_event.dart';
import '../models/upcoming_project_model.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/services/cloudinary_service.dart';

class AddEditUpcomingProjectScreen extends StatefulWidget {
  final UpcomingProjectModel? project;

  const AddEditUpcomingProjectScreen({super.key, this.project});

  @override
  State<AddEditUpcomingProjectScreen> createState() =>
      _AddEditUpcomingProjectScreenState();
}

class _AddEditUpcomingProjectScreenState
    extends State<AddEditUpcomingProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _completionController;
  late TextEditingController _featuresController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  
  File? _selectedImage;
  String _imageUrl = '';
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.project?.description ?? '',
    );
    _imageUrl = widget.project?.image ?? '';
    _locationController = TextEditingController(
      text: widget.project?.location ?? '',
    );
    _completionController = TextEditingController(
      text: widget.project?.expectedCompletion ?? '',
    );
    _featuresController = TextEditingController(
      text: widget.project?.features.join(', ') ?? '',
    );
    _latController = TextEditingController(
      text: widget.project?.lat.toString() ?? '0.0',
    );
    _lngController = TextEditingController(
      text: widget.project?.lng.toString() ?? '0.0',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _completionController.dispose();
    _featuresController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);
    try {
      final url = await CloudinaryService.uploadFile(_selectedImage!);
      setState(() {
        _imageUrl = url;
        _isUploading = false;
      });
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final project = UpcomingProjectModel(
      id: widget.project?.id ?? '',
      title: _titleController.text,
      description: _descriptionController.text,
      image: _imageUrl,
      location: _locationController.text,
      expectedCompletion: _completionController.text,
      features: _featuresController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      lat: double.tryParse(_latController.text) ?? 0.0,
      lng: double.tryParse(_lngController.text) ?? 0.0,
      createdAt: widget.project?.createdAt ?? DateTime.now(),
    );

    if (widget.project == null) {
      context.read<UpcomingProjectBloc>().add(AddUpcomingProjectEvent(project));
    } else {
      context.read<UpcomingProjectBloc>().add(
        UpdateUpcomingProjectEvent(project),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.project != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? context.t('Edit Project', 'تعديل المشروع')
              : context.t('Add Project', 'إضافة مشروع'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: context.t('Title', 'العنوان'),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: context.t('Description', 'الوصف'),
              ),
              maxLines: 3,
            ),
            GestureDetector(
              onTap: () => _pickImage(context),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : _imageUrl.isNotEmpty
                        ? Image.network(_imageUrl, fit: BoxFit.cover)
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(context.t('Tap to select image',
                                    'اضغط لاختيار صورة')),
                              ],
                            ),
                          ),
              ),
            ),
            if (_isUploading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: context.t('Location', 'الموقع'),
              ),
            ),
            TextFormField(
              controller: _completionController,
              decoration: InputDecoration(
                labelText: context.t('Expected Completion', 'الاكتمال المتوقع'),
                hintText: 'e.g. Q4 2026',
              ),
            ),
            TextFormField(
              controller: _featuresController,
              decoration: InputDecoration(
                labelText: context.t(
                  'Features (comma separated)',
                  'الميزات (مفصولة بفاصلة)',
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.t('Latitude', 'خط العرض'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lngController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.t('Longitude', 'خط الطول'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: Text(context.t('Save', 'حفظ')),
            ),
          ],
        ),
      ),
    );
  }
}
