import 'package:flutter/material.dart';
import '../../../core/localization/app_locale.dart';
import '../models/blog_theme_model.dart';

class BlogErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const BlogErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.blogColorScheme;
    final textTheme = context.blogTextTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 24,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(context.t('Try again', 'حاول مرة أخرى')),
            ),
          ],
        ),
      ),
    );
  }
}
