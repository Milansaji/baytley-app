import 'package:cloud_firestore/cloud_firestore.dart';

class TestimonialModel {
  final String id;
  final String name;
  final String role;
  final String content;
  final String avatarUrl;
  final String company;
  final int rating;
  final DateTime createdAt;

  const TestimonialModel({
    required this.id,
    required this.name,
    required this.role,
    required this.content,
    this.avatarUrl = '',
    required this.company,
    required this.rating,
    required this.createdAt,
  });

  factory TestimonialModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TestimonialModel(
      id: doc.id,
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      content: data['content'] ?? '',
      avatarUrl: data['avatarUrl'] ?? data['avatar'] ?? '', // Support both old 'avatar' and new 'avatarUrl'
      company: data['company'] ?? '',
      rating: (data['rating'] as num?)?.toInt() ?? 5,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'content': content,
      'avatarUrl': avatarUrl,
      'company': company,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
