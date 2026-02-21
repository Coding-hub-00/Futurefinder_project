import 'package:flutter/material.dart';

class ResourcesScreen extends StatelessWidget {
  final List<Map<String, String>> resources = [
    {
      'title': 'Resume Writing Tips',
      'content': 'Learn how to create an effective resume that stands out to employers.',
    },
    {
      'title': 'Interview Preparation',
      'content': 'Master the art of interviewing with these proven strategies.',
    },
    {
      'title': 'Networking Guide',
      'content': 'Build professional relationships that advance your career.',
    },
    {
      'title': 'Skill Development',
      'content': 'Identify and develop the skills most valued in your field.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Career Resources')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource['title']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(resource['content']!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}