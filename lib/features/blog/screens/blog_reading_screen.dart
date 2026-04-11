import 'package:flutter/material.dart';
import '../../../core/localization/app_locale.dart';
import '../data/models/blog_model.dart';
import '../models/blog_ui_model.dart';
import '../models/blog_theme_model.dart';
import '../widgets/blog_reading_widgets.dart';

class BlogReadingScreen extends StatelessWidget {
  final BlogModel blog;

  const BlogReadingScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.blogColorScheme;
    final textTheme = context.blogTextTheme;
    final paragraphs = blog.paragraphs;

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
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 230,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                title: Text(
                  context.t('Article', 'المقال'),
                  style: const TextStyle(fontWeight: FontWeight.w600),
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
                            const SizedBox(height: 10),
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.blogTheme.cardTheme.color,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(
                                alpha: 0.05,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: colorScheme.onPrimary,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    blog.author,
                                    style: textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                BlogMetaChip(
                                  icon: Icons.calendar_month_rounded,
                                  text: blog.formattedDate,
                                ),
                                BlogMetaChip(
                                  icon: Icons.schedule_rounded,
                                  text: context.t(
                                    '${blog.readingMinutes} min read',
                                    '${blog.readingMinutes} دقيقة قراءة',
                                  ),
                                ),
                                BlogMetaChip(
                                  icon: Icons.text_snippet_outlined,
                                  text: context.t(
                                    '${blog.wordCount} words',
                                    '${blog.wordCount} كلمة',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                        decoration: BoxDecoration(
                          color: context.blogTheme.cardTheme.color,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(
                                alpha: 0.06,
                              ),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: paragraphs.isEmpty
                            ? Text(
                                context.t(
                                  'Article content is not available.',
                                  'محتوى المقال غير متاح.',
                                ),
                                style: textTheme.bodyLarge,
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (
                                    int i = 0;
                                    i < paragraphs.length;
                                    i++
                                  ) ...[
                                    BlogContentBlock(text: paragraphs[i]),
                                    if (i != paragraphs.length - 1)
                                      const SizedBox(height: 16),
                                  ],
                                ],
                              ),
                      ),
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
}
