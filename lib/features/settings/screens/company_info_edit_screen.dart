import 'package:flutter/material.dart';
import '../data/settings_repository.dart';
import '../models/company_info_model.dart';
import '../../../core/localization/app_locale.dart';

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
  late TextEditingController _logoController;
  late TextEditingController _wordmarkController;

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
      _logoController = TextEditingController(text: data.logo);
      _wordmarkController = TextEditingController(text: data.wordmark);
      _isLoading = false;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final info = CompanyInfoModel(
      name: _nameController.text,
      tagline: _taglineController.text,
      description: _descriptionController.text,
      logo: _logoController.text,
      wordmark: _wordmarkController.text,
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
                  TextFormField(
                    controller: _logoController,
                    decoration: InputDecoration(
                      labelText: context.t('Logo URL', 'رابط الشعار'),
                    ),
                  ),
                  TextFormField(
                    controller: _wordmarkController,
                    decoration: InputDecoration(
                      labelText: context.t('Wordmark URL', 'رابط علامة الاسم'),
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
