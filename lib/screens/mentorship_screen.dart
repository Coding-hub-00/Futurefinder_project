import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MentorshipScreen extends StatefulWidget {
  @override
  _MentorshipScreenState createState() => _MentorshipScreenState();
}

class _MentorshipScreenState extends State<MentorshipScreen> {
  List<dynamic> mentors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMentors();
  }

  loadMentors() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/mentorship/mentors/'));
    if (response.statusCode == 200) {
      setState(() {
        mentors = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Mentors',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: mentors.length,
        itemBuilder: (context, index) {
          final mentor = mentors[index];
          return Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mentor['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('${mentor['title']} at ${mentor['company']}'),
                            Text('${mentor['experience_years']} years experience'),
                          ]
                        )
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              Text('${mentor['rating']}')
                            ]
                          ),
                          Text('₹${mentor['hourly_rate']}/hr')
                        ]
                      )
                    ]
                  ),
                  SizedBox(height: 8),
                  Text(mentor['bio']),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: mentor['expertise'].map<Widget>((skill) => 
                      Chip(label: Text(skill))
                    ).toList()
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => showBookingDialog(mentor),
                    child: Text('Book Session')
                  )
                ]
              )
            )
          );
        }
      )
    );
  }

  showBookingDialog(dynamic mentor) {
    final nameController = TextEditingController();
    final topicController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book Session with ${mentor['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Your Name')
            ),
            TextField(
              controller: topicController,
              decoration: InputDecoration(labelText: 'Session Topic')
            )
          ]
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel')
          ),
          ElevatedButton(
            onPressed: () async {
              final response = await http.post(
                Uri.parse('http://127.0.0.1:8000/api/mentorship/book-session/'),
                headers: {'Content-Type': 'application/json'},
                body: json.encode({
                  'mentor_id': mentor['id'],
                  'student_name': nameController.text,
                  'topic': topicController.text,
                  'scheduled_time': DateTime.now().add(Duration(days: 1)).toIso8601String()
                })
              );
              
              Navigator.pop(context);
              if (response.statusCode == 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Session booked successfully!'))
                );
              }
            },
            child: Text('Book')
          )
        ]
      )
    );
  }
}