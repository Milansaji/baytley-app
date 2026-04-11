import 'package:cloud_firestore/cloud_firestore.dart';

class UpcomingProjectModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String location;
  final String expectedCompletion;
  final List<String> features;
  final double lat;
  final double lng;
  final DateTime createdAt;

  const UpcomingProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.location,
    required this.expectedCompletion,
    required this.features,
    required this.lat,
    required this.lng,
    required this.createdAt,
  });

  factory UpcomingProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UpcomingProjectModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      location: data['location'] ?? '',
      expectedCompletion: data['expectedCompletion'] ?? '',
      features: List<String>.from(data['features'] ?? []),
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'location': location,
      'expectedCompletion': expectedCompletion,
      'features': features,
      'lat': lat,
      'lng': lng,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
