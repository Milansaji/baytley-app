import 'package:flutter/material.dart';
import '../../blog/data/models/blog_model.dart';
import '../../blog/widgets/blog_article_card.dart';

class InsightCardAnimated extends StatefulWidget {
  final BlogModel blog;
  final int index;
  final VoidCallback? onTap;
  const InsightCardAnimated({
    super.key,
    required this.blog,
    required this.index,
    this.onTap,
  });

  @override
  State<InsightCardAnimated> createState() => _InsightCardAnimatedState();
}

class _InsightCardAnimatedState extends State<InsightCardAnimated>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: BlogArticleCard(blog: widget.blog, onTap: widget.onTap),
        ),
      ),
    );
  }
}
