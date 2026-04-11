import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/testimonial_bloc.dart';
import '../bloc/testimonial_event.dart';
import '../bloc/testimonial_state.dart';
import '../models/testimonial_model.dart';
import '../../../core/localization/app_locale.dart';
import 'add_edit_testimonial_screen.dart';

class TestimonialManagementScreen extends StatelessWidget {
  const TestimonialManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Manage Testimonials', 'إدارة التوصيات')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditTestimonialScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TestimonialBloc, TestimonialState>(
        builder: (context, state) {
          if (state is TestimonialLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TestimonialLoaded) {
            final testimonials = state.testimonials;
            if (testimonials.isEmpty) {
              return Center(
                child: Text(
                  context.t('No testimonials found', 'لا توجد توصيات'),
                ),
              );
            }
            return ListView.builder(
              itemCount: testimonials.length,
              itemBuilder: (context, index) {
                final item = testimonials[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: item.avatar.isNotEmpty
                        ? NetworkImage(item.avatar)
                        : null,
                    child: item.avatar.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    item.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddEditTestimonialScreen(testimonial: item),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, item),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          if (state is TestimonialError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, TestimonialModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.t('Delete Testimonial', 'حذف التوصية')),
        content: Text(
          context.t(
            'Are you sure you want to delete this testimonial?',
            'هل أنت متأكد أنك تريد حذف هذه التوصية؟',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.t('Cancel', 'إلغاء')),
          ),
          TextButton(
            onPressed: () {
              context.read<TestimonialBloc>().add(
                DeleteTestimonialEvent(item.id),
              );
              Navigator.pop(ctx);
            },
            child: Text(
              context.t('Delete', 'حذف'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
