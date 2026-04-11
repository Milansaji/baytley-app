import 'package:flutter/material.dart';

class ArabicFontProgressCard extends StatefulWidget {
  final bool isArabicUi;

  const ArabicFontProgressCard({super.key, required this.isArabicUi});

  @override
  State<ArabicFontProgressCard> createState() => _ArabicFontProgressCardState();
}

class _ArabicFontProgressCardState extends State<ArabicFontProgressCard> {
  late bool _progressComplete;

  @override
  void initState() {
    super.initState();
    _progressComplete = false;
    // Stop progress when text appears
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _progressComplete = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            value: _progressComplete ? 1.0 : null,
            strokeWidth: 2.8,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.isArabicUi ? 'جاري التحميل...' : 'Loading...',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
