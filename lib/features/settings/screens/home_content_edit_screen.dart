import 'package:flutter/material.dart';
import '../data/settings_repository.dart';
import '../models/home_content_model.dart';
import '../../../core/localization/app_locale.dart';

class HomeContentEditScreen extends StatefulWidget {
  const HomeContentEditScreen({super.key});

  @override
  State<HomeContentEditScreen> createState() => _HomeContentEditScreenState();
}

class _HomeContentEditScreenState extends State<HomeContentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = SettingsRepository();
  bool _isLoading = true;

  late TextEditingController _featuredTitleController;
  late TextEditingController _heroBgController;
  late TextEditingController _heroSubtitleController;
  late TextEditingController _heroTitleController;
  late TextEditingController _heroVideoController;
  late TextEditingController _upcomingTitleController;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _repository.getHomeContent();
    setState(() {
      _featuredTitleController = TextEditingController(
        text: data.featuredPropertiesTitle,
      );
      _heroBgController = TextEditingController(text: data.heroBackgroundImage);
      _heroSubtitleController = TextEditingController(text: data.heroSubtitle);
      _heroTitleController = TextEditingController(text: data.heroTitle);
      _heroVideoController = TextEditingController(text: data.heroVideo);
      _upcomingTitleController = TextEditingController(
        text: data.upcomingProjectsTitle,
      );
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _featuredTitleController.dispose();
    _heroBgController.dispose();
    _heroSubtitleController.dispose();
    _heroTitleController.dispose();
    _heroVideoController.dispose();
    _upcomingTitleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final content = HomeContentModel(
      featuredPropertiesTitle: _featuredTitleController.text,
      heroBackgroundImage: _heroBgController.text,
      heroSubtitle: _heroSubtitleController.text,
      heroTitle: _heroTitleController.text,
      heroVideo: _heroVideoController.text,
      upcomingProjectsTitle: _upcomingTitleController.text,
      updatedAt: DateTime.now(),
    );

    await _repository.updateHomeContent(content);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Settings updated')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Edit Home Content', 'تعديل محتوى الرئيسية')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _heroTitleController,
                    decoration: InputDecoration(
                      labelText: context.t('Hero Title', 'عنوان الهيرو'),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _heroSubtitleController,
                    decoration: InputDecoration(
                      labelText: context.t('Hero Subtitle', 'العنوان الفرعي'),
                    ),
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: _heroBgController,
                    decoration: InputDecoration(
                      labelText: context.t(
                        'Hero Background Image URL',
                        'رابط صورة الخلفية',
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _heroVideoController,
                    decoration: InputDecoration(
                      labelText: context.t('Hero Video URL', 'رابط الفيديو'),
                    ),
                  ),
                  const Divider(height: 32),
                  TextFormField(
                    controller: _featuredTitleController,
                    decoration: InputDecoration(
                      labelText: context.t(
                        'Featured Properties Title',
                        'عنوان العقارات المميزة',
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _upcomingTitleController,
                    decoration: InputDecoration(
                      labelText: context.t(
                        'Upcoming Projects Title',
                        'عنوان المشاريع القادمة',
                      ),
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
