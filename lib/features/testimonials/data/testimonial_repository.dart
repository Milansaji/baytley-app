import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/testimonial_model.dart';
import 'package:baytley/core/services/cloudinary_service.dart';

class TestimonialRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'testimonials',
  );

  Future<List<TestimonialModel>> fetchTestimonials() async {
    final snapshot = await _collection
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map(TestimonialModel.fromFirestore).toList();
  }

  Future<void> addTestimonial(TestimonialModel testimonial) async {
    await _collection.add(testimonial.toMap());
  }

  Future<void> updateTestimonial(TestimonialModel testimonial, {String? oldAvatarUrl}) async {
    // Delete old image if a new one was uploaded
    if (oldAvatarUrl != null && oldAvatarUrl.isNotEmpty && oldAvatarUrl != testimonial.avatarUrl) {
      await CloudinaryService.deleteFile(oldAvatarUrl);
    }
    await _collection.doc(testimonial.id).update(testimonial.toMap());
  }

  Future<void> deleteTestimonial(String id) async {
    // Get the testimonial document to retrieve the image URL
    try {
      final doc = await _collection.doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        final avatarUrl = data?['avatarUrl'] as String? ?? data?['avatar'] as String?;
        
        // Delete the image from Cloudinary
        if (avatarUrl != null && avatarUrl.isNotEmpty) {
          await CloudinaryService.deleteFile(avatarUrl);
        }
      }
    } catch (e) {
      print('Error retrieving testimonial image URL: $e');
    }
    
    // Delete the testimonial document
    await _collection.doc(id).delete();
  }
}

