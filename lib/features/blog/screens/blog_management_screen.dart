import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../bloc/blog_state.dart';
import '../data/models/blog_model.dart';
import '../../../core/localization/app_locale.dart';
import 'add_edit_blog_screen.dart';

class BlogManagementScreen extends StatelessWidget {
  const BlogManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          context.t('Manage Blogs', 'إدارة المدونات'),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEditBlogScreen()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BlogLoaded) {
              final blogs = state.blogs;
              if (blogs.isEmpty) {
                return Center(
                  child: Text(context.t('No blogs found', 'لا توجد مدونات')),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  final item = blogs[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1,
                    child: ListTile(
                      title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${item.author} - ${item.category}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddEditBlogScreen(blog: item),
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
                    ),
                  );
                },
              );
            }
            if (state is BlogError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      );
  }

  void _confirmDelete(BuildContext context, BlogModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.t('Delete Blog', 'حذف المدونة')),
        content: Text(
          context.t(
            'Are you sure you want to delete this blog post?',
            'هل أنت متأكد أنك تريد حذف هذه التدوينة؟',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.t('Cancel', 'إلغاء')),
          ),
          TextButton(
            onPressed: () {
              context.read<BlogBloc>().add(DeleteBlogEvent(item.id));
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
