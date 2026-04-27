import 'dart:ui';
import 'package:baytley/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/localization/app_locale.dart';

class HomeHero extends StatelessWidget {
  final AnimationController heroCtrl;
  final Animation<double> taglineFade;
  final Animation<Offset> taglineSlide;
  final Animation<double> headlineFade;
  final Animation<Offset> headlineSlide;
  final Animation<double> subFade;
  final Animation<Offset> subSlide;
  final Animation<double> searchFade;
  final Animation<double> searchScale;

  const HomeHero({
    super.key,
    required this.heroCtrl,
    required this.taglineFade,
    required this.taglineSlide,
    required this.headlineFade,
    required this.headlineSlide,
    required this.subFade,
    required this.subSlide,
    required this.searchFade,
    required this.searchScale,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final brandSub = context.t('Properties', 'عقارات');
    final tagline = context.t('PREMIUM REAL ESTATE', 'عقارات فاخرة');
    final headline = context.t('Experience The\nPinnacle', 'عِش قمة\nالرفاهية');
    final accent = context.t('of Luxury Living', 'في أسلوب حياة مترف');
    final subText = context.t(
      "Curating the finest properties in Dubai's\nmost prestigious addresses.",
      'نقدّم أرقى العقارات في دبي\nضمن أكثر العناوين تميزًا.',
    );

    return Stack(
      children: [
        // ── Background gradient (simulates dark Dubai skyline)
        Container(
          height: 440 + topPad,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.4, 0.75, 1.0],
              colors: [
                Color(0xFF0A1628), // very deep navy
                Color(0xFF0F2040),
                Color(0xFF152B55),
                Color(0xFF1C3A6E),
              ],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),

        // Decorative glow circles
        Positioned(
          top: topPad - 30,
          right: -50,
          child: const _GlowCircle(size: 250, opacity: 0.06),
        ),
        Positioned(
          top: topPad + 80,
          right: 40,
          child: const _GlowCircle(size: 90, opacity: 0.08),
        ),
        Positioned(
          bottom: 80,
          left: -30,
          child: const _GlowCircle(size: 160, opacity: 0.05),
        ),

        // ── Content
        Padding(
          padding: EdgeInsets.fromLTRB(24, topPad + 16, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nav row
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BAYTLEY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                      Text(
                        brandSub,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 10,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(width: 8),
                 
                  const SizedBox(width: 8),
                  _NavIconBtn(
                    icon: Icons.language_rounded,
                    onTap: AppLocaleController.toggleLanguage,
                    tooltip: context.t('Switch language', 'تغيير اللغة'),
                  ),
                ],
              ),

              const SizedBox(height: 44),

              // Tagline pill
              FadeTransition(
                opacity: taglineFade,
                child: SlideTransition(
                  position: taglineSlide,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    child: Text(
                      tagline,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Main headline  (large, luxury serif feel with weight)
              FadeTransition(
                opacity: headlineFade,
                child: SlideTransition(
                  position: headlineSlide,
                  child: Text(
                    headline,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),

              // Italic accent line
              FadeTransition(
                opacity: headlineFade,
                child: SlideTransition(
                  position: headlineSlide,
                  child: Text(
                    accent,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Subtext
              FadeTransition(
                opacity: subFade,
                child: SlideTransition(
                  position: subSlide,
                  child: Text(
                    subText,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const _GlowCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

class _NavIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;

  const _NavIconBtn({required this.icon, this.onTap, this.tooltip});

  @override
  Widget build(BuildContext context) {
    Widget button = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
