import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/localization/app_locale.dart';
import '../bloc/analytics_bloc.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AnalyticsLoaded) {
            final data = state.data;
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: theme.scaffoldBackgroundColor.withOpacity(
                    0.8,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      context.t('Insights', 'التحليلات'),
                      style: theme.textTheme.displayMedium,
                    ),
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    centerTitle: false,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuickStats(context, data),
                        const SizedBox(height: 32),
                        Text(
                          context.t('Engagement Trends', 'اتجاهات التفاعل'),
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildChartCard(
                          context,
                          child: _buildBarChart(context, data.enquiryTrends),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          context.t('Portfolio Distribution', 'توزيع المحفظة'),
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildChartCard(
                          context,
                          child: _buildPieChart(
                            context,
                            data.propertyDistribution,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          if (state is AnalyticsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, dynamic data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildModernMetric(
                context,
                context.t('Total Properties', 'إجمالي العقارات'),
                data.totalProperties.toString(),
                const Color(0xFF6366F1),
                Icons.home_work_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModernMetric(
                context,
                context.t('Enquiries', 'الاستفسارات'),
                data.totalEnquiries.toString(),
                const Color(0xFFF59E0B),
                Icons.message_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildModernMetric(
                context,
                context.t('Latest Blogs', 'أحدث المدونات'),
                data.totalBlogs.toString(),
                const Color(0xFF10B981),
                Icons.article_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModernMetric(
                context,
                context.t('Upcoming', 'قادم'),
                data.totalUpcoming.toString(),
                const Color(0xFFEC4899),
                Icons.calendar_today_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModernMetric(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: SizedBox(height: 220, child: child),
    );
  }

  Widget _buildBarChart(BuildContext context, Map<DateTime, int> trends) {
    final theme = Theme.of(context);
    final sortedDates = trends.keys.toList()..sort();
    final spots = sortedDates.asMap().entries.map<FlSpot>((e) {
      return FlSpot(e.key.toDouble(), trends[e.value]!.toDouble());
    }).toList();

    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.1),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: spots.asMap().entries.map<BarChartGroupData>((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.y,
                color: theme.primaryColor,
                width: 20,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
            ],
          );
        }).toList(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 12,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.round().toString(),
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, Map<String, int> distribution) {
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
      const Color(0xFFEC4899),
      const Color(0xFF8B5CF6),
    ];

    return PieChart(
      PieChartData(
        sectionsSpace: 6,
        centerSpaceRadius: 45,
        sections: distribution.entries
            .toList()
            .asMap()
            .entries
            .map<PieChartSectionData>((e) {
              final index = e.key;
              final entry = e.value;
              return PieChartSectionData(
                color: colors[index % colors.length],
                value: entry.value.toDouble(),
                title: entry.value.toString(),
                radius: 60,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                badgeWidget: _buildPieBadge(
                  entry.key,
                  colors[index % colors.length],
                ),
                badgePositionPercentageOffset: 1.4,
              );
            })
            .toList(),
      ),
    );
  }

  Widget _buildPieBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
