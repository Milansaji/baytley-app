import 'package:flutter/material.dart';
import '../models/blog_theme_model.dart';

class BlogCategoryChip extends StatelessWidget {
  final String text;

  const BlogCategoryChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.blogColorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: context.blogTextTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class BlogMetaChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const BlogMetaChip({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.blogColorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: context.blogTextTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.85),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class BlogContentBlock extends StatelessWidget {
  final String text;

  const BlogContentBlock({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.blogColorScheme;
    final textTheme = context.blogTextTheme;
    final isHeading = text.startsWith('# ') || text.startsWith('## ');
    final isBullet = text.startsWith('- ') || text.startsWith('* ');
    final isQuote = text.startsWith('> ');
    final isNumbered = RegExp(r'^\d+\.\s+').hasMatch(text);

    if (isHeading) {
      final heading = text.replaceFirst(RegExp(r'^#{1,2}\s*'), '');
      return Text(
        heading,
        style: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
      );
    }

    if (isBullet) {
      final value = text.replaceFirst(RegExp(r'^[-*]\s*'), '');
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 7, color: colorScheme.secondary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyLarge?.copyWith(height: 1.8),
            ),
          ),
        ],
      );
    }

    if (isNumbered) {
      final match = RegExp(r'^(\d+)\.\s+(.*)$').firstMatch(text);
      final number = match?.group(1) ?? '1';
      final value = match?.group(2) ?? text;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyLarge?.copyWith(height: 1.8),
            ),
          ),
        ],
      );
    }

    if (isQuote) {
      final value = text.replaceFirst(RegExp(r'^>\s*'), '');
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(color: colorScheme.primary, width: 3),
          ),
        ),
        child: Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontStyle: FontStyle.italic,
            height: 1.7,
          ),
        ),
      );
    }

    return Text(text, style: textTheme.bodyLarge?.copyWith(height: 1.8));
  }
}
