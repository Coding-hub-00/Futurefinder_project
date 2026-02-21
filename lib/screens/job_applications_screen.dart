import 'package:flutter/material.dart';

class JobApplicationsScreen extends StatefulWidget {
  @override
  _JobApplicationsScreenState createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends State<JobApplicationsScreen> {
  List<Map<String, dynamic>> applications = [
    {
      'company': 'TechCorp India',
      'position': 'Software Developer',
      'status': 'Applied',
      'date': '2024-01-15',
      'color': Colors.blue
    },
    {
      'company': 'DataTech Solutions',
      'position': 'Data Scientist',
      'status': 'Interview',
      'date': '2024-01-10',
      'color': Colors.orange
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Applications'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final app = applications[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: app['color'],
                child: Icon(Icons.work, color: Colors.white),
              ),
              title: Text(app['position']),
              subtitle: Text('${app['company']} • ${app['date']}'),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: app['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  app['status'],
                  style: TextStyle(color: app['color'], fontSize: 12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}