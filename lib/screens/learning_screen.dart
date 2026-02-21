import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningScreen extends StatefulWidget {
  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {

  Widget _buildLearningCard(String name, String url, IconData icon, Color color) {
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
            Text('Tap to learn', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
        title: Text('Learning Platforms', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Learn New Skills', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('Access courses from top learning platforms', 
              style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildLearningCard('Coursera', 'https://coursera.org', Icons.school, Colors.blue),
                  _buildLearningCard('Udemy', 'https://udemy.com', Icons.play_circle, Colors.purple),
                  _buildLearningCard('edX', 'https://edx.org', Icons.book, Colors.blue[800]!),
                  _buildLearningCard('Khan Academy', 'https://khanacademy.org', Icons.lightbulb, Colors.green),
                  _buildLearningCard('Pluralsight', 'https://pluralsight.com', Icons.code, Colors.pink),
                  _buildLearningCard('LinkedIn Learning', 'https://linkedin.com/learning', Icons.work, Colors.blue[700]!),
                  _buildLearningCard('Skillshare', 'https://skillshare.com', Icons.palette, Colors.green[600]!),
                  _buildLearningCard('YouTube', 'https://youtube.com', Icons.play_arrow, Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}