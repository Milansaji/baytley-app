import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../data/models/blog_model.dart';
import '../../../core/localization/app_locale.dart';

class AddEditBlogScreen extends StatefulWidget {
  final BlogModel? blog;

  const AddEditBlogScreen({super.key, this.blog});

  @override
  State<AddEditBlogScreen> createState() => _AddEditBlogScreenState();
}

class _AddEditBlogScreenState extends State<AddEditBlogScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _categoryController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blog?.title ?? '');
    _authorController = TextEditingController(text: widget.blog?.author ?? '');
    _categoryController = TextEditingController(
      text: widget.blog?.category ?? '',
    );
    _contentController = TextEditingController(
      text: widget.blog?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final blog = BlogModel(
      id: widget.blog?.id ?? '',
      title: _titleController.text,
      author: _authorController.text,
      category: _categoryController.text,
      content: _contentController.text,
      updatedAt: DateTime.now(),
    );

    if (widget.blog == null) {
      context.read<BlogBloc>().add(AddBlogEvent(blog));
    } else {
      context.read<BlogBloc>().add(UpdateBlogEvent(blog));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.blog != null;
    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEdit
                ? context.t('Edit Blog', 'تعديل المدونة')
                : context.t('Add Blog', 'إضافة مدونة'),
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
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: context.t('Author', 'المؤلف'),
                ),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: context.t('Category', 'الفئة'),
                ),
              ),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: context.t('Content (Markdown)', 'المحتوى'),
                ),
                maxLines: 10,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: Text(context.t('Save', 'حفظ')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
