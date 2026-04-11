import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyInfoModel {
  final String name;
  final String tagline;
  final String description;
  final String logo;
  final String wordmark;
  final DateTime updatedAt;

  const CompanyInfoModel({
    required this.name,
    required this.tagline,
    required this.description,
    required this.logo,
    required this.wordmark,
    required this.updatedAt,
  });

  factory CompanyInfoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CompanyInfoModel(
      name: data['name'] ?? '',
      tagline: data['tagline'] ?? '',
      description: data['description'] ?? '',
      logo: data['logo'] ?? '',
      wordmark: data['wordmark'] ?? '',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'tagline': tagline,
      'description': description,
      'logo': logo,
      'wordmark': wordmark,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };
  }
}
