import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'shimmer_base.dart';

class BlogCardShimmer extends StatelessWidget {
  const BlogCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 88, height: 20),
          SizedBox(height: 10),
          ShimmerBox(width: double.infinity, height: 16),
          SizedBox(height: 8),
          ShimmerBox(width: double.infinity, height: 12),
          SizedBox(height: 6),
          ShimmerBox(width: 230, height: 12),
          SizedBox(height: 10),
          ShimmerBox(width: 120, height: 12),
        ],
      ),
    );
  }
}
