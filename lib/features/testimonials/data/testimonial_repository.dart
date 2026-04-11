import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/testimonial_model.dart';

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

  Future<void> updateTestimonial(TestimonialModel testimonial) async {
    await _collection.doc(testimonial.id).update(testimonial.toMap());
  }

  Future<void> deleteTestimonial(String id) async {
    await _collection.doc(id).delete();
  }
}
