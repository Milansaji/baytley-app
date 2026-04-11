import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/localization/app_locale.dart';

import '../../properties/screens/property_management_screen.dart';
import '../../testimonials/screens/testimonial_management_screen.dart';
import '../../upcoming_projects/screens/upcoming_project_management_screen.dart';
import '../../blog/screens/blog_management_screen.dart';
import '../../property_enquiries/screens/enquiry_list_screen.dart';
import '../../analytics/bloc/analytics_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Elegant top accent gradient
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.primaryColor.withOpacity(0.15),
                    theme.primaryColor.withOpacity(0),
                  ],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.9),
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.1,
                  titlePadding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 14,
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('Manager', 'المدير'),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.primaryColor.withOpacity(0.5),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        context.t('Control Hub', 'مركز التحكم'),
                        style: theme.textTheme.displayMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
                    builder: (context, state) {
                      if (state is AnalyticsLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildQuickStats(context, state.data),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.t('Management', 'الإدارة'),
                                  style: theme.textTheme.titleLarge,
                                ),
                                Icon(
                                  Icons.tune_rounded,
                                  size: 20,
                                  color: theme.primaryColor.withOpacity(0.3),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      return const SizedBox(height: 100); // Placeholder
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                  children: [
                    _buildModuleCard(
                      context,
                      title: context.t('Properties', 'العقارات'),
                      icon: Icons.domain_rounded,
                      color: const Color(0xFF6366F1),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PropertyManagementScreen(),
                        ),
                      ),
                    ),
                    _buildModuleCard(
                      context,
                      title: context.t('Enquiries', 'الاستفسارات'),
                      icon: Icons.alternate_email_rounded,
                      color: const Color(0xFFF59E0B),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EnquiryListScreen(),
                        ),
                      ),
                    ),
                    _buildModuleCard(
                      context,
                      title: context.t('Testimonials', 'التوصيات'),
                      icon: Icons.auto_awesome_rounded,
                      color: const Color(0xFF10B981),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TestimonialManagementScreen(),
                        ),
                      ),
                    ),
                    _buildModuleCard(
                      context,
                      title: context.t('Upcoming', 'قادم'),
                      icon: Icons.rocket_launch_rounded,
                      color: const Color(0xFFEC4899),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const UpcomingProjectManagementScreen(),
                        ),
                      ),
                    ),
                    _buildModuleCard(
                      context,
                      title: context.t('Blogs', 'المدونات'),
                      icon: Icons.auto_stories_rounded,
                      color: const Color(0xFFEF4444),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BlogManagementScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, dynamic data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildStatChip(
            context,
            Icons.bar_chart_rounded,
            '${data.totalEnquiries}',
            context.t('Enquiries', 'استفسارات'),
          ),
          _buildStatChip(
            context,
            Icons.campaign_rounded,
            '${data.totalBlogs}',
            context.t('Blogs', 'مدونات'),
          ),
          _buildStatChip(
            context,
            Icons.domain_rounded,
            '${data.totalProperties}',
            context.t('Properties', 'عقارات'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: theme.primaryColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.03),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
