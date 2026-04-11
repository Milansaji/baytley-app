import 'package:flutter/material.dart';
import '../data/settings_repository.dart';
import '../models/contact_info_model.dart';
import '../../../core/localization/app_locale.dart';

class ContactInfoEditScreen extends StatefulWidget {
  const ContactInfoEditScreen({super.key});

  @override
  State<ContactInfoEditScreen> createState() => _ContactInfoEditScreenState();
}

class _ContactInfoEditScreenState extends State<ContactInfoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = SettingsRepository();
  bool _isLoading = true;

  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _workingHoursController;
  late TextEditingController _fbController;
  late TextEditingController _igController;
  late TextEditingController _liController;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _repository.getContactInfo();
    setState(() {
      _addressController = TextEditingController(text: data.address);
      _emailController = TextEditingController(text: data.email);
      _phoneController = TextEditingController(text: data.phone);
      _workingHoursController = TextEditingController(text: data.workingHours);
      _fbController = TextEditingController(
        text: data.socialMedia['facebook'] ?? '',
      );
      _igController = TextEditingController(
        text: data.socialMedia['instagram'] ?? '',
      );
      _liController = TextEditingController(
        text: data.socialMedia['linkedin'] ?? '',
      );
      _isLoading = false;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final info = ContactInfoModel(
      address: _addressController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      workingHours: _workingHoursController.text,
      socialMedia: {
        'facebook': _fbController.text,
        'instagram': _igController.text,
        'linkedin': _liController.text,
      },
      updatedAt: DateTime.now(),
    );

    await _repository.updateContactInfo(info);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Edit Contact Details', 'تعديل بيانات الاتصال')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: context.t('Address', 'العنوان'),
                    ),
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: context.t('Email', 'البريد الإلكتروني'),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: context.t('Phone', 'الهاتف'),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  TextFormField(
                    controller: _workingHoursController,
                    decoration: InputDecoration(
                      labelText: context.t('Working Hours', 'ساعات العمل'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.t('Social Media', 'وسائل التواصل الاجتماعي'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fbController,
                    decoration: const InputDecoration(
                      labelText: 'Facebook URL',
                    ),
                  ),
                  TextFormField(
                    controller: _igController,
                    decoration: const InputDecoration(
                      labelText: 'Instagram URL',
                    ),
                  ),
                  TextFormField(
                    controller: _liController,
                    decoration: const InputDecoration(
                      labelText: 'LinkedIn URL',
                    ),
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
