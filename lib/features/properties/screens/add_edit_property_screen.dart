import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../data/models/property_model.dart';
import '../bloc/property_bloc.dart';
import '../bloc/property_event.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/services/cloudinary_service.dart';

class AddEditPropertyScreen extends StatefulWidget {
  final PropertyModel? property;

  const AddEditPropertyScreen({super.key, this.property});

  @override
  State<AddEditPropertyScreen> createState() => _AddEditPropertyScreenState();
}

class _AddEditPropertyScreenState extends State<AddEditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;
  late TextEditingController _typeController;
  late TextEditingController _statusController;
  late TextEditingController _bedsController;
  late TextEditingController _bathsController;
  late TextEditingController _sqftController;
  late TextEditingController _brochureController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late bool _isFeatured;
  
  File? _selectedImage;
  String _imageUrl = '';
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.property?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.property?.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.property?.price ?? '',
    );
    _locationController = TextEditingController(
      text: widget.property?.location ?? '',
    );
    _typeController = TextEditingController(text: widget.property?.type ?? '');
    _statusController = TextEditingController(
      text: widget.property?.status ?? '',
    );
    _bedsController = TextEditingController(
      text: widget.property?.beds.toString() ?? '0',
    );
    _bathsController = TextEditingController(
      text: widget.property?.baths.toString() ?? '0',
    );
    _sqftController = TextEditingController(
      text: widget.property?.sqft.toString() ?? '0',
    );
    _brochureController = TextEditingController(
      text: widget.property?.brochureUrl ?? '',
    );
    _latController = TextEditingController(
      text: widget.property?.lat.toString() ?? '0.0',
    );
    _lngController = TextEditingController(
      text: widget.property?.lng.toString() ?? '0.0',
    );
    _isFeatured = widget.property?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _typeController.dispose();
    _statusController.dispose();
    _bedsController.dispose();
    _bathsController.dispose();
    _sqftController.dispose();
    _brochureController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final property = PropertyModel(
      id: widget.property?.id ?? '',
      title: _titleController.text,
      description: _descriptionController.text,
      image: _imageUrl,
      price: _priceController.text,
      location: _locationController.text,
      type: _typeController.text,
      status: _statusController.text,
      beds: int.tryParse(_bedsController.text) ?? 0,
      baths: int.tryParse(_bathsController.text) ?? 0,
      sqft: int.tryParse(_sqftController.text) ?? 0,
      lat: double.tryParse(_latController.text) ?? 0.0,
      lng: double.tryParse(_lngController.text) ?? 0.0,
      isFeatured: _isFeatured,
      brochureUrl: _brochureController.text,
      createdAt: widget.property?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.property == null) {
      context.read<PropertyBloc>().add(AddPropertyEvent(property));
    } else {
      context.read<PropertyBloc>().add(UpdatePropertyEvent(property));
    }

    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.property != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? context.t('Edit Property', 'تعديل العقار')
              : context.t('Add Property', 'إضافة عقار'),
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
              controller: _priceController,
              decoration: InputDecoration(
                labelText: context.t('Price', 'السعر'),
              ),
            ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: context.t('Location', 'الموقع'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _typeController,
                    decoration: InputDecoration(
                      labelText: context.t('Type', 'النوع'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _statusController,
                    decoration: InputDecoration(
                      labelText: context.t('Status', 'الحالة'),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _bedsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.t('Beds', 'الغرف'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _bathsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.t('Baths', 'الحمامات'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _sqftController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.t('Sqft', 'المساحة'),
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: _brochureController,
              decoration: InputDecoration(
                labelText: context.t('Brochure URL', 'رابط الكتيب'),
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
            SwitchListTile(
              title: Text(context.t('Featured Property', 'عقار مميز')),
              value: _isFeatured,
              onChanged: (v) => setState(() => _isFeatured = v),
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
