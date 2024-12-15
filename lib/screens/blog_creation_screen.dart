import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/blog_post.dart';
import '../providers/blog_provider.dart';

class BlogCreationScreen extends StatefulWidget {
  @override
  _BlogCreationScreenState createState() => _BlogCreationScreenState();
}

class _BlogCreationScreenState extends State<BlogCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  String _category = 'Technology';

  void _saveBlog() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final newBlog = BlogPost(
      id: DateTime.now().toString(),
      title: _title,
      authorId: 'userId',
      authorName: 'Author Name',
      excerpt: _content.substring(0, 100),
      content: _content,
      category: _category,
      tags: [],
      mediaUrl: '',
      date: DateTime.now(),
      likes: 0,
      comments: [],
    );

    Provider.of<BlogProvider>(context, listen: false).addBlog(newBlog);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Blog')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 8,
                validator: (value) => value!.isEmpty ? 'Enter content' : null,
                onSaved: (value) => _content = value!,
              ),
              DropdownButtonFormField(
                value: _category,
                items: ['Technology', 'Lifestyle', 'Education']
                    .map((category) => DropdownMenuItem(
                  child: Text(category),
                  value: category,
                ))
                    .toList(),
                onChanged: (value) => setState(() => _category = value.toString()),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBlog,
                child: Text('Publish Blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}