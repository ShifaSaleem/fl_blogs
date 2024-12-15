import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/blog_post.dart';
import '../providers/blog_provider.dart';
import '../components/blog_card.dart';

class BlogsFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => FilterOptions(blogProvider),
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: blogProvider.fetchBlogs(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (blogProvider.blogs.isEmpty) {
            return Center(child: Text('No blogs found.'));
          }
          return ListView.builder(
            itemCount: blogProvider.blogs.length,
            itemBuilder: (ctx, index) {
              return BlogCard(blog: blogProvider.blogs[index]);
            },
          );
        },
      ),
    );
  }
}

class FilterOptions extends StatelessWidget {
  final blogProvider;

  FilterOptions(this.blogProvider);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Filter Blogs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: Text('Technology'),
            value: blogProvider.filterTechnology,
            onChanged: (value) => blogProvider.setFilter('technology', value!),
          ),
          CheckboxListTile(
            title: Text('Lifestyle'),
            value: blogProvider.filterLifestyle,
            onChanged: (value) => blogProvider.setFilter('lifestyle', value!),
          ),
          CheckboxListTile(
            title: Text('Education'),
            value: blogProvider.filterEducation,
            onChanged: (value) => blogProvider.setFilter('education', value!),
          ),
        ],
      ),
    );
  }
}