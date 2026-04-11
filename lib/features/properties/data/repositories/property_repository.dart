import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property_model.dart';

class PropertyRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'properties',
  );

  Future<List<PropertyModel>> fetchProperties() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map(PropertyModel.fromFirestore).toList();
  }

  Future<void> addProperty(PropertyModel property) async {
    await _collection.add(property.toMap());
  }

  Future<void> updateProperty(PropertyModel property) async {
    await _collection.doc(property.id).update(property.toMap());
  }

  Future<void> deleteProperty(String id) async {
    await _collection.doc(id).delete();
  }
}
