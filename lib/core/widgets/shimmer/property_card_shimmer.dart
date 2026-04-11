import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'shimmer_base.dart';

class PropertyCardShimmer extends StatelessWidget {
  const PropertyCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.only(bottom: 10),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: 200,
            height: 120,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 90, height: 18),
                SizedBox(height: 8),
                ShimmerBox(width: 150, height: 12),
                SizedBox(height: 8),
                ShimmerBox(width: 110, height: 12),
                SizedBox(height: 10),
                Row(
                  children: [
                    ShimmerBox(width: 40, height: 18),
                    SizedBox(width: 6),
                    ShimmerBox(width: 40, height: 18),
                    SizedBox(width: 6),
                    ShimmerBox(width: 50, height: 18),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
