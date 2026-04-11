import 'package:flutter/material.dart';
import 'arabic_font_loader.dart';
import 'widgets/arabic_font_progress_card.dart';

class ArabicFontLoadingOverlay extends StatelessWidget {
  final Widget child;

  const ArabicFontLoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        ValueListenableBuilder<bool>(
          valueListenable: ArabicFontLoader.isLoading,
          builder: (context, loading, _) {
            if (!loading) return const SizedBox.shrink();

            return Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.15),
                  child: Center(
                    child: ArabicFontProgressCard(
                      isArabicUi:
                          Localizations.localeOf(context).languageCode == 'ar',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
