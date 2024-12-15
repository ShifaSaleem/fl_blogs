import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_blogs/screens/blog_detail_screen.dart';
import 'package:flutter/material.dart';

import '../models/blog_post.dart';

class BlogCard extends StatelessWidget {
  final BlogPost blog;
  BlogCard({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(blog.title),
            subtitle: Text('By ${blog.authorName} - ${blog.date.toLocal()}'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetailScreen(blogData: blog)));
            },
          ),
          if (blog.mediaUrl != null)
            Image.network(blog.mediaUrl!),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up_alt_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.comment_outlined),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => CommentSection(blogId: blog.id),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentSection extends StatelessWidget {
  final String blogId;
  CommentSection({required this.blogId});

  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: commentController,
            decoration: InputDecoration(
              labelText: 'Add a comment',
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  if (commentController.text.isNotEmpty) {
                    await FirebaseFirestore.instance.collection('comments').add({
                      'blogId': blogId,
                      'comment': commentController.text,
                      'author': FirebaseAuth.instance.currentUser?.email,
                      'date': DateTime.now(),
                    });
                    commentController.clear();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('comments')
                  .where('blogId', isEqualTo: blogId)
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No comments yet.'));
                }
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['author'] ?? 'Anonymous'),
                      subtitle: Text(data['comment']),
                      trailing: Text(
                        (data['date'] as Timestamp).toDate().toString(),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
