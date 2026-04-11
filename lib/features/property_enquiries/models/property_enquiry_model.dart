import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyEnquiryModel {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String name;
  final String email;
  final String message;
  final String status;
  final DateTime createdAt;

  const PropertyEnquiryModel({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.name,
    required this.email,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  factory PropertyEnquiryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PropertyEnquiryModel(
      id: doc.id,
      propertyId: data['propertyId'] ?? '',
      propertyTitle: data['propertyTitle'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      message: data['message'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
