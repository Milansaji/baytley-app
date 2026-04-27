import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/shimmer.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../bloc/blog_state.dart';
import '../../../core/localization/app_locale.dart';
import '../models/blog_theme_model.dart';
import '../widgets/blog_article_card.dart';
import '../widgets/blog_error_state.dart';
import 'blog_reading_screen.dart';
import 'saved_blogs_screen.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.blogColorScheme;

    return Scaffold(
      backgroundColor: context.blogScaffoldBackground,
      appBar: AppBar(
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Text(
          context.t('Articles', 'المقالات'),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SavedBlogsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.bookmark_outline),
            tooltip: context.t('Saved Articles', 'المقالات المحفوظة'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<BlogBloc, BlogState>(
                builder: (context, state) {
                  if (state is BlogLoading) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      itemCount: 4,
                      itemBuilder: (_, __) => const BlogCardShimmer(),
                    );
                  }
                  if (state is BlogError) {
                    return BlogErrorState(
                      message: state.message,
                      onRetry: () =>
                          context.read<BlogBloc>().add(FetchBlogsEvent()),
                    );
                  }
                  if (state is BlogLoaded) {
                    if (state.blogs.isEmpty) {
                      return Center(
                        child: Text(
                          context.t('No articles yet.', 'لا توجد مقالات بعد.'),
                          style: context.blogTextTheme.bodyMedium,
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: colorScheme.primary,
                      backgroundColor: colorScheme.surface,
                      onRefresh: () async {
                        context.read<BlogBloc>().add(FetchBlogsEvent());
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        itemCount: state.blogs.length,
                        itemBuilder: (ctx, i) => BlogArticleCard(
                          key: ValueKey(state.blogs[i].id),
                          blog: state.blogs[i],
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  BlogReadingScreen(blog: state.blogs[i]),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
