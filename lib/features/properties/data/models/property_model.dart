import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String price;
  final String location;
  final String type;
  final String status;
  final int beds;
  final int baths;
  final int sqft;
  final double lat;
  final double lng;
  final bool isFeatured;
  final String brochureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.location,
    required this.type,
    required this.status,
    required this.beds,
    required this.baths,
    required this.sqft,
    required this.lat,
    required this.lng,
    required this.isFeatured,
    required this.brochureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PropertyModel(
      id: data['id'] as String? ?? doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      image: data['image'] as String? ?? '',
      price: data['price'] as String? ?? '',
      location: data['location'] as String? ?? '',
      type: data['type'] as String? ?? '',
      status: data['status'] as String? ?? '',
      beds: (data['beds'] as num?)?.toInt() ?? 0,
      baths: (data['baths'] as num?)?.toInt() ?? 0,
      sqft: (data['sqft'] as num?)?.toInt() ?? 0,
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
      isFeatured: data['isFeatured'] as bool? ?? false,
      brochureUrl: data['brochureUrl'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'location': location,
      'type': type,
      'status': status,
      'beds': beds,
      'baths': baths,
      'sqft': sqft,
      'lat': lat,
      'lng': lng,
      'isFeatured': isFeatured,
      'brochureUrl': brochureUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
