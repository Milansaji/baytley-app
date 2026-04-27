import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/constants/colors.dart';
import '../data/models/blog_model.dart';
import 'blog_reading_screen.dart';

class SavedBlogsScreen extends StatefulWidget {
  const SavedBlogsScreen({super.key});

  @override
  State<SavedBlogsScreen> createState() => _SavedBlogsScreenState();
}

class _SavedBlogsScreenState extends State<SavedBlogsScreen> {
  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Saved Articles', 'المقالات المحفوظة')),
        elevation: 0,
      ),
      body: user == null
          ? _buildNotSignedInState(context)
          : _buildSavedBlogsList(context, user.uid),
    );
  }

  Widget _buildNotSignedInState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_outline,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.t('Not signed in', 'لم تقم بتسجيل الدخول'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              context.t(
                'Sign in to save and manage your favorite articles',
                'قم بتسجيل الدخول لحفظ وإدارة مقالاتك المفضلة',
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.t('Sign In', 'تسجيل الدخول')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedBlogsList(BuildContext context, String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved_blogs')
          .orderBy('savedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState(context);
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.t('Error loading saved articles', 'خطأ في تحميل المقالات المحفوظة'),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final savedBlogs = snapshot.data?.docs ?? [];

        if (savedBlogs.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: savedBlogs.length,
          itemBuilder: (context, index) {
            final docSnapshot = savedBlogs[index];
            final data = docSnapshot.data() as Map<String, dynamic>;

            return _buildSavedBlogCard(
              context,
              docSnapshot.id,
              data,
              userId,
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_border_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.t('No saved articles', 'لا توجد مقالات محفوظة'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              context.t(
                'Save your favorite articles for later reading',
                'احفظ مقالاتك المفضلة لقراءتها لاحقاً',
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedBlogCard(
    BuildContext context,
    String docId,
    Map<String, dynamic> data,
    String userId,
  ) {
    final title = data['title'] as String? ?? 'Unknown Title';
    final author = data['author'] as String? ?? 'Unknown Author';
    final category = data['category'] as String? ?? 'General';
    final savedAt = (data['savedAt'] as Timestamp?)?.toDate() ?? DateTime.now();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _navigateToBlogReading(context, docId, title, author, category);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            category,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeSavedBlog(context, userId, docId),
                    icon: const Icon(Icons.close),
                    splashRadius: 24,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.t('By', 'بقلم'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    author,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                context.t(
                  'Saved on ${savedAt.toString().split(' ')[0]}',
                  'تم الحفظ في ${savedAt.toString().split(' ')[0]}',
                ),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _removeSavedBlog(
    BuildContext context,
    String userId,
    String blogId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved_blogs')
          .doc(blogId)
          .delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('Removed from saved', 'تم الحذف من المحفوظات')),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Error removing saved blog: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('Error', 'خطأ'))),
      );
    }
  }

  void _navigateToBlogReading(
    BuildContext context,
    String blogId,
    String title,
    String author,
    String category,
  ) {
    final blog = BlogModel(
      id: blogId,
      title: title,
      author: author,
      category: category,
      content: 'Content to be loaded...',
      updatedAt: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogReadingScreen(blog: blog),
      ),
    );
  }
}

