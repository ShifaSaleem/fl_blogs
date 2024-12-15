import 'package:flutter/material.dart';
import '../models/blog_post.dart';
import '../services/firebase_service.dart'; // Or local_database_service.dart

class BlogProvider with ChangeNotifier {
  FirebaseService firebaseService = FirebaseService();
  List<BlogPost> _blogs = [];

  List<BlogPost> get blogs => [..._blogs];

  Future<void> fetchBlogs() async {
    _blogs = (await firebaseService.fetchBlogs()).cast<BlogPost>();
    notifyListeners();
  }

  Future<void> addBlog(BlogPost blog) async {
    await firebaseService.addBlogPost(blog);
    _blogs.add(blog);
    notifyListeners();
  }
}
