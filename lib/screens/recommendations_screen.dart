import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/career_provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'career_detail_screen.dart';

class RecommendationsScreen extends StatefulWidget {
  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CareerProvider>(context, listen: false).loadRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Career Recommendations'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<CareerProvider>(
        builder: (context, careerProvider, child) {
          if (careerProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (careerProvider.recommendations.isEmpty) {
            return Center(child: Text('No recommendations available'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: careerProvider.recommendations.length,
            itemBuilder: (context, index) {
              final career = careerProvider.recommendations[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CareerDetailScreen(career: career),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                career.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2874F0),
                                ),
                              ),
                            ),
                            if (career.matchPercentage > 0)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2874F0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${career.matchPercentage.toInt()}% Match',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          career.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.trending_up, size: 16, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              'Tap for career guidance',
                              style: TextStyle(
                                color: Color(0xFF2874F0),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}