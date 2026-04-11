import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/testimonial_bloc.dart';
import '../bloc/testimonial_event.dart';
import '../models/testimonial_model.dart';
import '../../../core/localization/app_locale.dart';

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
  late TextEditingController _avatarController;
  late TextEditingController _companyController;
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
    _avatarController = TextEditingController(
      text: widget.testimonial?.avatar ?? '',
    );
    _companyController = TextEditingController(
      text: widget.testimonial?.company ?? '',
    );
    _rating = widget.testimonial?.rating ?? 5;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _contentController.dispose();
    _avatarController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final testimonial = TestimonialModel(
      id: widget.testimonial?.id ?? '',
      name: _nameController.text,
      role: _roleController.text,
      content: _contentController.text,
      avatar: _avatarController.text,
      company: _companyController.text,
      rating: _rating,
      createdAt: widget.testimonial?.createdAt ?? DateTime.now(),
    );

    if (widget.testimonial == null) {
      context.read<TestimonialBloc>().add(AddTestimonialEvent(testimonial));
    } else {
      context.read<TestimonialBloc>().add(UpdateTestimonialEvent(testimonial));
    }

    Navigator.pop(context);
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
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.t('Name', 'الاسم'),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(
                labelText: context.t('Company', 'الشركة'),
              ),
            ),
            TextFormField(
              controller: _roleController,
              decoration: InputDecoration(
                labelText: context.t('Role', 'الدور / المسمى'),
              ),
            ),
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
            TextFormField(
              controller: _avatarController,
              decoration: InputDecoration(
                labelText: context.t('Avatar URL', 'رابط الصورة الشخصية'),
              ),
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
