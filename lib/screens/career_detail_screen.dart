import 'package:flutter/material.dart';
import '../models/career.dart';

class CareerDetailScreen extends StatelessWidget {
  final Career career;

  const CareerDetailScreen({Key? key, required this.career}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(career.title),
        backgroundColor: Color(0xFF2874F0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Match Percentage Card
            Card(
              color: Color(0xFF2874F0),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${career.matchPercentage.toInt()}% Match',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Based on your profile',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Description
            _buildSection('About This Career', career.description),

            // Salary Range
            if (career.salaryRange.isNotEmpty)
              _buildSection('Salary Range', career.salaryRange),

            // Job Outlook
            if (career.jobOutlook.isNotEmpty)
              _buildSection('Job Outlook', career.jobOutlook),

            // Required Skills
            _buildSkillsSection(),

            // Education Path
            if (career.educationPath.isNotEmpty)
              _buildListSection('Education Path', career.educationPath, Icons.school),

            // Career Steps
            if (career.careerSteps.isNotEmpty)
              _buildListSection('Career Progression', career.careerSteps, Icons.trending_up),

            // Top Companies
            if (career.topCompanies.isNotEmpty)
              _buildListSection('Top Hiring Companies', career.topCompanies, Icons.business),

            // Resources
            if (career.resources.isNotEmpty)
              _buildSection('Resources & Tips', career.resources),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2874F0),
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Required Skills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2874F0),
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: career.requiredSkills
                  .map((skill) => Chip(
                        label: Text(skill),
                        backgroundColor: Color(0xFF2874F0).withOpacity(0.1),
                        labelStyle: TextStyle(color: Color(0xFF2874F0)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Color(0xFF2874F0)),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2874F0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...items.asMap().entries.map((entry) {
              int index = entry.key;
              String item = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Color(0xFF2874F0),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}