import 'package:flutter/material.dart';
import '../models/blog_theme_model.dart';
import '../../../core/localization/app_locale.dart';
import '../data/models/blog_model.dart';
import '../models/blog_ui_model.dart';

class BlogArticleCard extends StatelessWidget {
  final BlogModel blog;
  final VoidCallback? onTap;

  const BlogArticleCard({super.key, required this.blog, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.blogColorScheme;
    final blogTheme = context.blogTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: blogTheme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryChip(label: blog.safeCategory),
                const SizedBox(height: 10),
                Hero(
                  tag: 'blog-title-${blog.id}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      blog.title,
                      style: context.blogTextTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  blog.preview,
                  style: context.blogTextTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: blogTheme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.t('By ${blog.author}', 'بقلم ${blog.author}'),
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.blogColorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
