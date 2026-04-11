import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/upcoming_project_bloc.dart';
import '../bloc/upcoming_project_event.dart';
import '../bloc/upcoming_project_state.dart';
import '../models/upcoming_project_model.dart';
import '../../../core/localization/app_locale.dart';
import 'add_edit_upcoming_project_screen.dart';

class UpcomingProjectManagementScreen extends StatelessWidget {
  const UpcomingProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t('Manage Upcoming Projects', 'إدارة المشاريع القادمة'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditUpcomingProjectScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<UpcomingProjectBloc, UpcomingProjectState>(
        builder: (context, state) {
          if (state is UpcomingProjectLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UpcomingProjectLoaded) {
            final projects = state.projects;
            if (projects.isEmpty) {
              return Center(
                child: Text(context.t('No projects found', 'لا توجد مشاريع')),
              );
            }
            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final item = projects[index];
                return ListTile(
                  leading: item.image.isNotEmpty
                      ? Image.network(
                          item.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.upcoming),
                        )
                      : const Icon(Icons.upcoming),
                  title: Text(item.title),
                  subtitle: Text(
                    '${item.expectedCompletion} - ${item.location}',
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
                                  AddEditUpcomingProjectScreen(project: item),
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
          if (state is UpcomingProjectError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, UpcomingProjectModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.t('Delete Project', 'حذف المشروع')),
        content: Text(
          context.t(
            'Are you sure you want to delete this project?',
            'هل أنت متأكد أنك تريد حذف هذا المشروع؟',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.t('Cancel', 'إلغاء')),
          ),
          TextButton(
            onPressed: () {
              context.read<UpcomingProjectBloc>().add(
                DeleteUpcomingProjectEvent(item.id),
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
