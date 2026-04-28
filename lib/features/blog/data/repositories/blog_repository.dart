import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blog_model.dart';
import 'package:baytley/core/services/cloudinary_service.dart';

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

  Future<void> updateBlog(BlogModel blog, {String? oldImageUrl}) async {
    // Delete old image if a new one was uploaded
    if (oldImageUrl != null && oldImageUrl.isNotEmpty && oldImageUrl != blog.imageUrl) {
      await CloudinaryService.deleteFile(oldImageUrl);
    }
    await _collection.doc(blog.id).update(blog.toMap());
  }

  Future<void> deleteBlog(String id) async {
    // Get the blog document to retrieve the image URL
    try {
      final doc = await _collection.doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        final imageUrl = data?['imageUrl'] as String?;
        
        // Delete the image from Cloudinary
        if (imageUrl != null && imageUrl.isNotEmpty) {
          await CloudinaryService.deleteFile(imageUrl);
        }
      }
    } catch (e) {
      print('Error retrieving blog image URL: $e');
    }
    
    // Delete the blog document
    await _collection.doc(id).delete();
  }
}
