import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobsScreen extends StatefulWidget {
  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {

  Widget _buildJobPortalCard(String name, String url, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey[200]!, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            SizedBox(height: 16),
            Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('Tap to browse', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Job Portals', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Find Jobs on Top Platforms', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('Browse thousands of job opportunities', 
              style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildJobPortalCard('LinkedIn', 'https://linkedin.com/jobs', Icons.work, Colors.blue[700]!),
                  _buildJobPortalCard('Naukri.com', 'https://naukri.com', Icons.business_center, Colors.purple),
                  _buildJobPortalCard('Indeed', 'https://indeed.co.in', Icons.search, Colors.blue),
                  _buildJobPortalCard('Monster', 'https://monster.com', Icons.work_outline, Colors.green),
                  _buildJobPortalCard('Glassdoor', 'https://glassdoor.co.in', Icons.star, Colors.green[600]!),
                  _buildJobPortalCard('AngelList', 'https://angel.co', Icons.rocket_launch, Colors.black),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}