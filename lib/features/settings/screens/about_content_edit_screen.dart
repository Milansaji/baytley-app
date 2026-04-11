import 'package:flutter/material.dart';
import '../data/settings_repository.dart';
import '../models/about_content_model.dart';
import '../../../core/localization/app_locale.dart';

class AboutContentEditScreen extends StatefulWidget {
  const AboutContentEditScreen({super.key});

  @override
  State<AboutContentEditScreen> createState() => _AboutContentEditScreenState();
}

class _AboutContentEditScreenState extends State<AboutContentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = SettingsRepository();
  bool _isLoading = true;

  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _descriptionController;
  late TextEditingController _missionController;
  late TextEditingController _visionController;

  List<Map<String, String>> _stats = [];
  List<String> _values = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _repository.getAboutContent();
    setState(() {
      _titleController = TextEditingController(text: data.title);
      _subtitleController = TextEditingController(text: data.subtitle);
      _descriptionController = TextEditingController(text: data.description);
      _missionController = TextEditingController(text: data.mission);
      _visionController = TextEditingController(text: data.vision);
      _stats = List<Map<String, String>>.from(data.stats);
      _values = List<String>.from(data.values);
      _isLoading = false;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final content = AboutContentModel(
      title: _titleController.text,
      subtitle: _subtitleController.text,
      description: _descriptionController.text,
      mission: _missionController.text,
      vision: _visionController.text,
      stats: _stats,
      values: _values,
      updatedAt: DateTime.now(),
    );

    await _repository.updateAboutContent(content);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Edit About Content', 'تعديل محتوى "عن الشركة"')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: context.t('Title', 'العنوان'),
                    ),
                  ),
                  TextFormField(
                    controller: _subtitleController,
                    decoration: InputDecoration(
                      labelText: context.t('Subtitle', 'العنوان الفرعي'),
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
                    controller: _missionController,
                    decoration: InputDecoration(
                      labelText: context.t('Mission', 'المهمة'),
                    ),
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: _visionController,
                    decoration: InputDecoration(
                      labelText: context.t('Vision', 'الرؤية'),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  _buildValuesSection(),
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

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t('Statistics', 'الإحصائيات'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._stats.asMap().entries.map((entry) {
          final i = entry.key;
          final stat = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: stat['label'],
                    onChanged: (v) => _stats[i]['label'] = v,
                    decoration: const InputDecoration(
                      hintText: 'Label (e.g. Years)',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: stat['value'],
                    onChanged: (v) => _stats[i]['value'] = v,
                    decoration: const InputDecoration(
                      hintText: 'Value (e.g. 15+)',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => setState(() => _stats.removeAt(i)),
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: () =>
              setState(() => _stats.add({'label': '', 'value': ''})),
          icon: const Icon(Icons.add),
          label: Text(context.t('Add Stat', 'إضافة إحصائية')),
        ),
      ],
    );
  }

  Widget _buildValuesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t('Company Values', 'قيم الشركة'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._values.asMap().entries.map((entry) {
          final i = entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: entry.value,
                    onChanged: (v) => _values[i] = v,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => setState(() => _values.removeAt(i)),
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => setState(() => _values.add('')),
          icon: const Icon(Icons.add),
          label: Text(context.t('Add Value', 'إضافة قيمة')),
        ),
      ],
    );
  }
}
