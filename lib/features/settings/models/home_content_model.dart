import 'package:cloud_firestore/cloud_firestore.dart';

class HomeContentModel {
  final String featuredPropertiesTitle;
  final String heroBackgroundImage;
  final String heroSubtitle;
  final String heroTitle;
  final String heroVideo;
  final String upcomingProjectsTitle;
  final DateTime updatedAt;

  const HomeContentModel({
    required this.featuredPropertiesTitle,
    required this.heroBackgroundImage,
    required this.heroSubtitle,
    required this.heroTitle,
    required this.heroVideo,
    required this.upcomingProjectsTitle,
    required this.updatedAt,
  });

  factory HomeContentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HomeContentModel(
      featuredPropertiesTitle: data['featuredPropertiesTitle'] ?? '',
      heroBackgroundImage: data['heroBackgroundImage'] ?? '',
      heroSubtitle: data['heroSubtitle'] ?? '',
      heroTitle: data['heroTitle'] ?? '',
      heroVideo: data['heroVideo'] ?? '',
      upcomingProjectsTitle: data['upcomingProjectsTitle'] ?? '',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'featuredPropertiesTitle': featuredPropertiesTitle,
      'heroBackgroundImage': heroBackgroundImage,
      'heroSubtitle': heroSubtitle,
      'heroTitle': heroTitle,
      'heroVideo': heroVideo,
      'upcomingProjectsTitle': upcomingProjectsTitle,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };
  }
}
