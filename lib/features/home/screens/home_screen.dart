import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/widgets/shimmer.dart';
import '../../properties/bloc/property_bloc.dart';
import '../../properties/bloc/property_state.dart';
import '../../blog/bloc/blog_bloc.dart';
import '../../blog/bloc/blog_state.dart';
import '../../blog/screens/blog_reading_screen.dart';
import '../../../core/constants/colors.dart';
import '../widgets/home_hero.dart';
// import '../widgets/home_stats_bar.dart'; // User diff showed removal, keeping it out if they removed it
import '../widgets/property_card.dart';
import '../widgets/insight_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HOME SCREEN  –  Refactored with separated widgets
// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  final Function(int index)? onTabChange;
  const HomeScreen({super.key, this.onTabChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Staggered hero animations
  late final AnimationController _heroCtrl;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _headlineFade;
  late final Animation<Offset> _headlineSlide;
  late final Animation<double> _subFade;
  late final Animation<Offset> _subSlide;
  late final Animation<double> _searchFade;
  late final Animation<double> _searchScale;

  // Scroll-driven shimmer controller
  late final AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();

    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    // tagline pill  0–35%
    _taglineFade = CurvedAnimation(
      parent: _heroCtrl,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _taglineSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _heroCtrl,
            curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
          ),
        );

    // headline  15–60%
    _headlineFade = CurvedAnimation(
      parent: _heroCtrl,
      curve: const Interval(0.15, 0.6, curve: Curves.easeOut),
    );
    _headlineSlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _heroCtrl,
            curve: const Interval(0.15, 0.65, curve: Curves.easeOutCubic),
          ),
        );

    // sub-headline  35–75%
    _subFade = CurvedAnimation(
      parent: _heroCtrl,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
    );
    _subSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _heroCtrl,
            curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    // search bar  55–100%  (scale-up + fade)
    _searchFade = CurvedAnimation(
      parent: _heroCtrl,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );
    _searchScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroCtrl,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Cinematic Hero ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: HomeHero(
              heroCtrl: _heroCtrl,
              taglineFade: _taglineFade,
              taglineSlide: _taglineSlide,
              headlineFade: _headlineFade,
              headlineSlide: _headlineSlide,
              subFade: _subFade,
              subSlide: _subSlide,
              searchFade: _searchFade,
              searchScale: _searchScale,
            ),
          ),

          // ── Featured Properties ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Text(
                    context.t('Featured Properties', 'عقارات مميزة'),
                    style: textTheme.titleMedium,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(1);
                      }
                    },
                    child: Text(
                      context.t('See all', 'عرض الكل'),
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 244,
              child: BlocBuilder<PropertyBloc, PropertyState>(
                builder: (context, state) {
                  if (state is PropertyLoading) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20, right: 8),
                      itemCount: 3,
                      itemBuilder: (_, __) => const PropertyCardShimmer(),
                    );
                  }
                  if (state is PropertyError) {
                    return Center(
                      child: Text(state.message, style: textTheme.bodyMedium),
                    );
                  }
                  if (state is PropertyLoaded) {
                    final featured = state.properties
                        .where((p) => p.isFeatured)
                        .toList();
                    final list = featured.isEmpty
                        ? state.properties.take(5).toList()
                        : featured;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20, right: 8),
                      itemCount: list.length,
                      itemBuilder: (ctx, i) =>
                          PropertyCardAnimated(property: list[i], index: i),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // ── Latest Insights ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    context.t('Latest Insights', 'أحدث المقالات'),
                    style: textTheme.titleMedium,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(2);
                      }
                    },
                    child: Text(
                      context.t('See all', 'عرض الكل'),
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          BlocBuilder<BlogBloc, BlogState>(
            builder: (context, state) {
              if (state is BlogLoading) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: BlogCardShimmer(),
                    ),
                    childCount: 3,
                  ),
                );
              }
              if (state is BlogError) {
                return SliverToBoxAdapter(
                  child: Center(child: Text(state.message)),
                );
              }
              if (state is BlogLoaded) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => InsightCardAnimated(
                      blog: state.blogs[i],
                      index: i,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                BlogReadingScreen(blog: state.blogs[i]),
                          ),
                        );
                      },
                    ),
                    childCount: state.blogs.length.clamp(0, 3),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
