import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/upcoming_project_model.dart';

class UpcomingProjectRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'upcoming_projects',
  );

  Future<List<UpcomingProjectModel>> fetchProjects() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map(UpcomingProjectModel.fromFirestore).toList();
  }

  Future<void> addProject(UpcomingProjectModel project) async {
    await _collection.add(project.toMap());
  }

  Future<void> updateProject(UpcomingProjectModel project) async {
    await _collection.doc(project.id).update(project.toMap());
  }

  Future<void> deleteProject(String id) async {
    await _collection.doc(id).delete();
  }
}
