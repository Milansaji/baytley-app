import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'shimmer_base.dart';

class PropertyListCardShimmer extends StatelessWidget {
  const PropertyListCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(
              width: double.infinity,
              height: 180,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            SizedBox(height: 12),
            ShimmerBox(width: 180, height: 16),
            SizedBox(height: 8),
            ShimmerBox(width: 130, height: 12),
            SizedBox(height: 10),
            Row(
              children: [
                ShimmerBox(width: 90, height: 18),
                Spacer(),
                ShimmerBox(width: 42, height: 14),
                SizedBox(width: 10),
                ShimmerBox(width: 42, height: 14),
                SizedBox(width: 10),
                ShimmerBox(width: 62, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
