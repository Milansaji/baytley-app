import 'package:cloud_firestore/cloud_firestore.dart';

class AboutContentModel {
  final String title;
  final String subtitle;
  final String description;
  final String mission;
  final String vision;
  final List<Map<String, String>> stats;
  final List<String> values;
  final DateTime updatedAt;

  const AboutContentModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.mission,
    required this.vision,
    required this.stats,
    required this.values,
    required this.updatedAt,
  });

  factory AboutContentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final List<dynamic> statsData = data['stats'] ?? [];
    final List<Map<String, String>> parsedStats = statsData.map((s) {
      final map = s as Map<String, dynamic>;
      return {
        'label': map['label']?.toString() ?? '',
        'value': map['value']?.toString() ?? '',
      };
    }).toList();

    return AboutContentModel(
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      description: data['description'] ?? '',
      mission: data['mission'] ?? '',
      vision: data['vision'] ?? '',
      stats: parsedStats,
      values: List<String>.from(data['values'] ?? []),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'mission': mission,
      'vision': vision,
      'stats': stats,
      'values': values,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };
  }
}
