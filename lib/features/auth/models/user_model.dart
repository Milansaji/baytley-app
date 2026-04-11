import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, user }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return UserModel(
      id: doc.id,
      name: data?['name'] ?? '',
      email: data?['email'] ?? '',
      role: data?['role'] == 'admin' ? UserRole.admin : UserRole.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role == UserRole.admin ? 'admin' : 'user',
    };
  }

  bool get isAdmin => role == UserRole.admin;
}
