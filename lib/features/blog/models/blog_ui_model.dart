import '../data/models/blog_model.dart';

extension BlogUiModelX on BlogModel {
  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[updatedAt.month - 1]} ${updatedAt.day}, ${updatedAt.year}';
  }

  int get readingMinutes {
    final count = wordCount;
    if (count == 0) return 1;
    return (count / 220).ceil().clamp(1, 99);
  }

  int get wordCount {
    return content
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
  }

  List<String> get paragraphs {
    return content
        .replaceAll('\r\n', '\n')
        .split(RegExp(r'\n{2,}'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
  }

  String get safeCategory {
    final value = category.trim();
    return value.isEmpty ? 'General' : value;
  }

  String get authorInitials {
    final trimmed = author.trim();
    if (trimmed.isEmpty) return 'NA';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    if (trimmed.length == 1) return trimmed.toUpperCase();
    return trimmed.substring(0, 2).toUpperCase();
  }
}
