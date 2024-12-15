import 'package:fl_blogs/models/category.dart';

import 'comment.dart';

class BlogPost {
  String id;
  String title;
  String authorId;
  String authorName;
  String excerpt;
  String content;
  String category;
  List<String> tags;
  String mediaUrl;
  DateTime date;
  int likes;
  List<Comment> comments;

  BlogPost({
    required this.id,
    required this.title,
    required this.authorId,
    required this.authorName,
    required this.excerpt,
    required this.content,
    required this.category,
    required this.tags,
    required this.mediaUrl,
    required this.date,
    required this.likes,
    required this.comments,
  });
}
