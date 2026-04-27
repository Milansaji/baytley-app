import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/constants/colors.dart';
import '../data/models/blog_model.dart';
import '../models/blog_ui_model.dart';
import '../models/blog_theme_model.dart';
import '../widgets/blog_reading_widgets.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../bloc/blog_state.dart';

class BlogReadingScreen extends StatefulWidget {
  final BlogModel blog;

  const BlogReadingScreen({super.key, required this.blog});

  @override
  State<BlogReadingScreen> createState() => _BlogReadingScreenState();
}

class _BlogReadingScreenState extends State<BlogReadingScreen> {
  late ScrollController _scrollController;
  bool _isLiked = false;
  bool _isSaved = false;
  int _likeCount = 0;
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    context.read<BlogBloc>().add(FetchBlogsEvent());
    _loadUserInteractions();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInteractions() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Load like status
      final likeDoc = await _firestore
          .collection('blogs')
          .doc(widget.blog.id)
          .collection('likes')
          .doc(user.uid)
          .get();
      
      final blogDoc = await _firestore
          .collection('blogs')
          .doc(widget.blog.id)
          .get();

      // Load save status
      final saveDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_blogs')
          .doc(widget.blog.id)
          .get();

      setState(() {
        _isLiked = likeDoc.exists;
        _isSaved = saveDoc.exists;
        _likeCount = blogDoc.get('likeCount') ?? 0;
      });
    } catch (e) {
      debugPrint('Error loading interactions: $e');
    }
  }

  Future<void> _toggleLike() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('Please sign in', 'يرجى تسجيل الدخول')),
        ),
      );
      return;
    }

    try {
      final likeRef = _firestore
          .collection('blogs')
          .doc(widget.blog.id)
          .collection('likes')
          .doc(user.uid);

      final blogRef = _firestore.collection('blogs').doc(widget.blog.id);

      if (_isLiked) {
        // Unlike
        await likeRef.delete();
        await blogRef.update({'likeCount': FieldValue.increment(-1)});
        setState(() {
          _isLiked = false;
          _likeCount--;
        });
      } else {
        // Like
        await likeRef.set({'timestamp': FieldValue.serverTimestamp()});
        await blogRef.update({'likeCount': FieldValue.increment(1)});
        setState(() {
          _isLiked = true;
          _likeCount++;
        });
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('Error', 'خطأ'))),
      );
    }
  }

  Future<void> _toggleSave() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('Please sign in', 'يرجى تسجيل الدخول')),
        ),
      );
      return;
    }

    try {
      final saveRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_blogs')
          .doc(widget.blog.id);

      if (_isSaved) {
        // Unsave
        await saveRef.delete();
        setState(() {
          _isSaved = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t('Removed from saved', 'تم الحذف من المحفوظات')),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // Save
        await saveRef.set({
          'blogId': widget.blog.id,
          'title': widget.blog.title,
          'author': widget.blog.author,
          'category': widget.blog.category,
          'savedAt': FieldValue.serverTimestamp(),
        });
        setState(() {
          _isSaved = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t('Saved successfully', 'تم الحفظ بنجاح')),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error toggling save: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('Error', 'خطأ'))),
      );
    }
  }

  Future<void> _shareArticle() async {
    try {
      final message = '''${widget.blog.title}

${context.t('By', 'بقلم')}: ${widget.blog.author}

${context.t('Category', 'الفئة')}: ${widget.blog.category}

${context.t('Check out this amazing article on Baytley!', 'اطلع على هذا المقال الرائع على Baytley!')}''';

      await Clipboard.setData(ClipboardData(text: message));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('Copied to clipboard', 'تم النسخ إلى الحافظة')),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: context.t('Share', 'مشاركة'),
            onPressed: () {
              _showShareOptions();
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error sharing: $e');
    }
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.t('Share Via', 'شارك عبر'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  icon: Icons.mail_outline,
                  label: context.t('Email', 'البريد'),
                  onTap: () => _shareViaEmail(),
                ),
                _buildShareOption(
                  icon: Icons.message_outlined,
                  label: context.t('SMS', 'رسالة نصية'),
                  onTap: () => _shareViaSMS(),
                ),
                _buildShareOption(
                  icon: Icons.copy,
                  label: context.t('Copy', 'نسخ'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  void _shareViaEmail() {
    // Implement email sharing
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.t('Opening email client...', 'جاري فتح عميل البريد...'))),
    );
  }

  void _shareViaSMS() {
    // Implement SMS sharing
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.t('Opening SMS app...', 'جاري فتح تطبيق الرسائل...'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogBloc, BlogState>(
      builder: (context, state) {
        if (state is BlogLoading) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildShimmerHeader(context),
                  _buildShimmerContent(context),
                ],
              ),
            ),
          );
        }

        return _buildBlogContent(context, widget.blog);
      },
    );
  }

  Widget _buildBlogContent(BuildContext context, BlogModel blog) {
    final colorScheme = context.blogColorScheme;
    final textTheme = context.blogTextTheme;

    return Scaffold(
      backgroundColor: context.blogScaffoldBackground,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: -70,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.secondary.withValues(alpha: 0.08),
              ),
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 240,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                title: Text(
                  context.t('Article', 'المقال'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          Color.lerp(
                                colorScheme.primary,
                                colorScheme.secondary,
                                0.4,
                              ) ??
                              colorScheme.primary,
                          colorScheme.secondary,
                        ],
                        stops: const [0.0, 0.68, 1.0],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 62, 20, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BlogCategoryChip(text: blog.safeCategory),
                            const SizedBox(height: 12),
                            Hero(
                              tag: 'blog-title-${blog.id}',
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  blog.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.headlineMedium?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Author Card ──────────────────────────────────────
                      _buildAuthorCard(context, blog, colorScheme, textTheme),
                      const SizedBox(height: 20),

                      // ── Article Stats ───────────────────────────────────
                      _buildArticleStats(context, blog, colorScheme),
                      const SizedBox(height: 24),

                      // ── Content Section ─────────────────────────────────
                      _buildContentSection(context, blog, colorScheme),
                      const SizedBox(height: 20),

                      // ── Article Footer ──────────────────────────────────
                      _buildArticleFooter(context, colorScheme),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorCard(
    BuildContext context,
    BlogModel blog,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.blogTheme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('Written by', 'بقلم'),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      blog.author,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleStats(
    BuildContext context,
    BlogModel blog,
    ColorScheme colorScheme,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatChip(
            context,
            icon: Icons.calendar_today_outlined,
            label: blog.formattedDate,
            colorScheme: colorScheme,
          ),
          const SizedBox(width: 12),
          _buildStatChip(
            context,
            icon: Icons.schedule_outlined,
            label: context.t(
              '${blog.readingMinutes} min',
              '${blog.readingMinutes} دقيقة',
            ),
            colorScheme: colorScheme,
          ),
          const SizedBox(width: 12),
          _buildStatChip(
            context,
            icon: Icons.description_outlined,
            label: context.t(
              '${blog.wordCount} words',
              '${blog.wordCount} كلمة',
            ),
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(
    BuildContext context,
    BlogModel blog,
    ColorScheme colorScheme,
  ) {
    final paragraphs = blog.paragraphs;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.blogTheme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: paragraphs.isEmpty
          ? Center(
              child: Text(
                context.t(
                  'Article content is not available.',
                  'محتوى المقال غير متاح.',
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < paragraphs.length; i++) ...[
                  BlogContentBlock(text: paragraphs[i]),
                  if (i != paragraphs.length - 1)
                    const SizedBox(height: 18),
                ],
              ],
            ),
    );
  }

  Widget _buildArticleFooter(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInteractionButton(
                context,
                icon: _isLiked ? Icons.favorite : Icons.favorite_outline,
                label: context.t('Like', 'إعجاب'),
                count: _likeCount,
                isActive: _isLiked,
                onTap: _toggleLike,
              ),
              const SizedBox(width: 20),
              _buildInteractionButton(
                context,
                icon: Icons.share_outlined,
                label: context.t('Share', 'مشاركة'),
                onTap: _shareArticle,
              ),
              const SizedBox(width: 20),
              _buildInteractionButton(
                context,
                icon: _isSaved ? Icons.bookmark : Icons.bookmark_outline,
                label: context.t('Save', 'حفظ'),
                isActive: _isSaved,
                onTap: _toggleSave,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    int? count,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.red : AppColors.primary,
              size: 20,
            ),
            const SizedBox(height: 4),
            if (count != null && count > 0)
              Text(
                '$count',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shimmer Loading States ─────────────────────────────────────────────
  Widget _buildShimmerHeader(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[300]!,
            Colors.grey[200]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 200,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Card Shimmer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats Shimmer
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  height: 40,
                  margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Content Shimmer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                5,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: index < 4 ? 16 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 200,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}