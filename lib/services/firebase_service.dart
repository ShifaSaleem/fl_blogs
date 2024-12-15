import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/blog_post.dart';
class FirebaseService {
  Future<void> addBlogPost(BlogPost blogData) async {
    try {
      await FirebaseFirestore.instance.collection('blogs').add(blogData as Map<String, dynamic>);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> fetchBlogs() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('blogs').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}

