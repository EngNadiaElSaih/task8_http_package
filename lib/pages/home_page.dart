import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = 'https://jsonplaceholder.typicode.com';
  List posts = [];
  Map<String, dynamic> post = {};
  List comments = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
    fetchPost(1);
    fetchCommentsForPost(1);
    fetchCommentsWithQuery(1);
  }

  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('$url/posts'));
    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
      });
    } else {
      print('Failed to load posts');
    }
  }

  Future<void> fetchPost(int postId) async {
    final response = await http.get(Uri.parse('$url/posts/$postId'));
    if (response.statusCode == 200) {
      setState(() {
        post = json.decode(response.body);
      });
    } else {
      print('Failed to load post');
    }
  }

  Future<void> fetchCommentsForPost(int postId) async {
    final response = await http.get(Uri.parse('$url/posts/$postId/comments'));
    if (response.statusCode == 200) {
      setState(() {
        comments = json.decode(response.body);
      });
    } else {
      print('Failed to load comments for post');
    }
  }

  Future<void> fetchCommentsWithQuery(int postId) async {
    final response = await http.get(Uri.parse('$url/comments?postId=$postId'));
    if (response.statusCode == 200) {
      setState(() {
        comments = json.decode(response.body);
      });
    } else {
      print('Failed to load comments with query');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(147, 220, 217, 187),
        title: Text('usig http package'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('All Posts:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
              for (var p in posts)
                Text('Post ID: ${p['id']}, Title: ${p['title']}'),
              SizedBox(height: 20),
              Text('Single Post:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
              if (post.isNotEmpty)
                Text(
                    'Post ID: ${post['id']}, Title: ${post['title']}, Body: ${post['body']}'),
              SizedBox(height: 20),
              Text('Comments for Post ID 1:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
              for (var c in comments)
                Text(
                    'Comment ID: ${c['id']}, Name: ${c['name']}, Body: ${c['body']}'),
            ],
          ),
        ),
      ),
    );
  }
}
