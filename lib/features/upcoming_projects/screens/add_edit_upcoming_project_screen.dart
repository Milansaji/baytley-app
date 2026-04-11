import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/upcoming_project_bloc.dart';
import '../bloc/upcoming_project_event.dart';
import '../models/upcoming_project_model.dart';
import '../../../core/localization/app_locale.dart';

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
  late TextEditingController _imageController;
  late TextEditingController _locationController;
  late TextEditingController _completionController;
  late TextEditingController _featuresController;
  late TextEditingController _latController;
  late TextEditingController _lngController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.project?.description ?? '',
    );
    _imageController = TextEditingController(text: widget.project?.image ?? '');
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
    _imageController.dispose();
    _locationController.dispose();
    _completionController.dispose();
    _featuresController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final project = UpcomingProjectModel(
      id: widget.project?.id ?? '',
      title: _titleController.text,
      description: _descriptionController.text,
      image: _imageController.text,
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
            TextFormField(
              controller: _imageController,
              decoration: InputDecoration(
                labelText: context.t('Image URL', 'رابط الصورة'),
              ),
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
