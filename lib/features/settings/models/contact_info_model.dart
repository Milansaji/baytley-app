import 'package:cloud_firestore/cloud_firestore.dart';

class ContactInfoModel {
  final String address;
  final String email;
  final String phone;
  final String workingHours;
  final Map<String, String> socialMedia;
  final DateTime updatedAt;

  const ContactInfoModel({
    required this.address,
    required this.email,
    required this.phone,
    required this.workingHours,
    required this.socialMedia,
    required this.updatedAt,
  });

  factory ContactInfoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final Map<String, dynamic> socialData = data['socialMedia'] ?? {};
    final Map<String, String> parsedSocial = socialData.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    return ContactInfoModel(
      address: data['address'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      workingHours: data['workingHours'] ?? '',
      socialMedia: parsedSocial,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'email': email,
      'phone': phone,
      'workingHours': workingHours,
      'socialMedia': socialMedia,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };
  }
}
