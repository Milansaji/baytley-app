import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blog_model.dart';

class BlogRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'blogs',
  );

  Future<List<BlogModel>> fetchBlogs() async {
    final snapshot = await _collection
        .orderBy('updatedAt', descending: true)
        .get();
    return snapshot.docs.map(BlogModel.fromFirestore).toList();
  }

  Future<void> addBlog(BlogModel blog) async {
    await _collection.add(blog.toMap());
  }

  Future<void> updateBlog(BlogModel blog) async {
    await _collection.doc(blog.id).update(blog.toMap());
  }

  Future<void> deleteBlog(String id) async {
    await _collection.doc(id).delete();
  }
}
