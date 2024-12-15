import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/blog_post.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogPost blogData;

  BlogDetailScreen({required this.blogData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(blogData.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('By ${blogData.authorName} - ${blogData.date}',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 10),
            Text(blogData.content, style: TextStyle(fontSize: 18)),
            if (blogData.mediaUrl != null) ...[
              SizedBox(height: 20),
              Image.network(blogData.mediaUrl),
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
                          builder: (ctx) => CommentSection(blogId: blogData.id),
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
          ],
        ),
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
