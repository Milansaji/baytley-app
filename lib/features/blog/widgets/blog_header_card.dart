import 'package:flutter/material.dart';
import '../../../core/localization/app_locale.dart';
import '../models/blog_theme_model.dart';

class BlogHeaderCard extends StatelessWidget {
  const BlogHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.blogColorScheme;
    final textTheme = context.blogTextTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -28,
            right: -28,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.onPrimary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -18,
            right: 18,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.onPrimary.withValues(alpha: 0.04),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t('FROM THE TEAM', 'من فريقنا'),
                style: textTheme.labelSmall?.copyWith(
                  letterSpacing: 2,
                  color: colorScheme.onPrimary.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.t('Our Blog', 'مدونتنا'),
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.t(
                  'News & analysis from our experts',
                  'أخبار وتحليلات من خبرائنا',
                ),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.86),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
