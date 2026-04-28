import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../data/settings_repository.dart';
import '../models/company_info_model.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/services/cloudinary_service.dart';

class CompanyInfoEditScreen extends StatefulWidget {
  const CompanyInfoEditScreen({super.key});

  @override
  State<CompanyInfoEditScreen> createState() => _CompanyInfoEditScreenState();
}

class _CompanyInfoEditScreenState extends State<CompanyInfoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = SettingsRepository();
  bool _isLoading = true;

  late TextEditingController _nameController;
  late TextEditingController _taglineController;
  late TextEditingController _descriptionController;

  File? _selectedLogoImage;
  String _logoUrl = '';
  bool _isUploadingLogo = false;

  File? _selectedWordmarkImage;
  String _wordmarkUrl = '';
  bool _isUploadingWordmark = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _repository.getCompanyInfo();
    setState(() {
      _nameController = TextEditingController(text: data.name);
      _taglineController = TextEditingController(text: data.tagline);
      _descriptionController = TextEditingController(text: data.description);
      _logoUrl = data.logo;
      _wordmarkUrl = data.wordmark;
      _isLoading = false;
    });
  }

  Future<void> _pickLogoImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedLogoImage = File(pickedFile.path);
      });
      await _uploadLogoImage();
    }
  }

  Future<void> _uploadLogoImage() async {
    if (_selectedLogoImage == null) return;

    setState(() => _isUploadingLogo = true);
    try {
      final url = await CloudinaryService.uploadFile(_selectedLogoImage!);
      setState(() {
        _logoUrl = url;
        _isUploadingLogo = false;
      });
    } catch (e) {
      setState(() => _isUploadingLogo = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading logo: $e')),
        );
      }
    }
  }

  Future<void> _pickWordmarkImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedWordmarkImage = File(pickedFile.path);
      });
      await _uploadWordmarkImage();
    }
  }

  Future<void> _uploadWordmarkImage() async {
    if (_selectedWordmarkImage == null) return;

    setState(() => _isUploadingWordmark = true);
    try {
      final url = await CloudinaryService.uploadFile(_selectedWordmarkImage!);
      setState(() {
        _wordmarkUrl = url;
        _isUploadingWordmark = false;
      });
    } catch (e) {
      setState(() => _isUploadingWordmark = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading wordmark: $e')),
        );
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final info = CompanyInfoModel(
      name: _nameController.text,
      tagline: _taglineController.text,
      description: _descriptionController.text,
      logo: _logoUrl,
      wordmark: _wordmarkUrl,
      updatedAt: DateTime.now(),
    );

    await _repository.updateCompanyInfo(info);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Edit Company Info', 'تعديل معلومات الشركة')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: context.t('Company Name', 'اسم الشركة'),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _taglineController,
                    decoration: InputDecoration(
                      labelText: context.t('Tagline', 'الشعار اللفظي'),
                    ),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: context.t('Description', 'الوصف'),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  Text(context.t('Logo', 'الشعار')),
                  GestureDetector(
                    onTap: () => _pickLogoImage(context),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _selectedLogoImage != null
                          ? Image.file(_selectedLogoImage!, fit: BoxFit.cover)
                          : _logoUrl.isNotEmpty
                              ? Image.network(_logoUrl, fit: BoxFit.cover)
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
                  if (_isUploadingLogo)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    ),
                  const SizedBox(height: 24),
                  Text(context.t('Wordmark', 'علامة الاسم')),
                  GestureDetector(
                    onTap: () => _pickWordmarkImage(context),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _selectedWordmarkImage != null
                          ? Image.file(_selectedWordmarkImage!, fit: BoxFit.cover)
                          : _wordmarkUrl.isNotEmpty
                              ? Image.network(_wordmarkUrl, fit: BoxFit.cover)
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
                  if (_isUploadingWordmark)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _save,
                    child: Text(context.t('Save Changes', 'حفظ التغييرات')),
                  ),
                ],
              ),
            ),
    );
  }
}
