import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String id;
  final String title;
  final String author;
  final String category;
  final String content;
  final String imageUrl;
  final DateTime updatedAt;

  const BlogModel({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.content,
    this.imageUrl = '',
    required this.updatedAt,
  });

  factory BlogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BlogModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      author: data['author'] as String? ?? '',
      category: data['category'] as String? ?? '',
      content: data['content'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'content': content,
      'imageUrl': imageUrl,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Returns the first ~200 characters of content as a preview.
  String get preview {
    final plain = content.replaceAll(RegExp(r'##? '), '').trim();
    return plain.length > 200 ? '${plain.substring(0, 200)}…' : plain;
  }
}
