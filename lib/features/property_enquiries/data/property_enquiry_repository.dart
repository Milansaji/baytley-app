import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property_enquiry_model.dart';

class PropertyEnquiryRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'property_enquiries',
  );

  Future<List<PropertyEnquiryModel>> fetchEnquiries() async {
    final snapshot = await _collection
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map(PropertyEnquiryModel.fromFirestore).toList();
  }
}
