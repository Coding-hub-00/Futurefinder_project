import 'dart:convert';

import 'package:ffvs/screens/career_path_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/career_provider.dart';
import '../models/career.dart';

class AIMatchingScreen extends StatefulWidget {
  @override
  _AIMatchingScreenState createState() => _AIMatchingScreenState();
}

class _AIMatchingScreenState extends State<AIMatchingScreen> {
  String academicLevel = 'undergraduate';
  String stream = 'engineering';
  List<String> skills = [];
  List<String> interests = [];
  List<dynamic> recommendations = [];
  bool isLoading = false;
  bool showRecommendations = false;
  bool showChat = false;
  List<Map<String, dynamic>> chatMessages = [
    {
      'text': 'Hi! I\'m your AI Career Advisor 🤖\n\nI can help you with:\n• Career recommendations\n• Skill development advice\n• Salary insights\n• Learning paths\n\nWhat would you like to know?',
      'isBot': true
    }
  ];
  String botMessage = '';

  final skillController = TextEditingController();
  final interestController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    if (chatMessages.isEmpty) {
      chatMessages.add({
        'text': 'Hello! I\'m your AI career advisor. I can help you discover the perfect career path based on your skills and interests. How can I assist you today? 🚀',
        'isBot': true
      });
    }
  }
  
  @override
  void dispose() {
    skillController.dispose();
    interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'AI Career Matching',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: showChat ? buildChatBot() : (showRecommendations ? buildRecommendations() : buildProfileSetup()),
      floatingActionButton: !showChat ? FloatingActionButton(
        onPressed: () => setState(() => showChat = true),
        backgroundColor: Color(0xFF2874F0),
        child: Icon(Icons.chat, color: Colors.white),
      ) : null,
    );
  }

  Widget buildProfileSetup() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set up your profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Help us understand you better for personalized recommendations',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 32),

          // Academic Level
          Text('Academic Level', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: academicLevel,
                items: [
                  DropdownMenuItem(value: 'high_school', child: Text('High School')),
                  DropdownMenuItem(value: 'undergraduate', child: Text('Undergraduate')),
                  DropdownMenuItem(value: 'postgraduate', child: Text('Postgraduate')),
                  DropdownMenuItem(value: 'phd', child: Text('PhD')),
                ],
                onChanged: (value) => setState(() => academicLevel = value!),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Stream
          Text('Stream/Field', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: stream,
                items: [
                  DropdownMenuItem(value: 'engineering', child: Text('Engineering')),
                  DropdownMenuItem(value: 'business', child: Text('Business')),
                  DropdownMenuItem(value: 'science', child: Text('Science')),
                  DropdownMenuItem(value: 'arts', child: Text('Arts')),
                  DropdownMenuItem(value: 'commerce', child: Text('Commerce')),
                  DropdownMenuItem(value: 'medicine', child: Text('Medicine')),
                ],
                onChanged: (value) => setState(() => stream = value!),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Skills
          Text('Skills', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          TextField(
            controller: skillController,
            decoration: InputDecoration(
              hintText: 'Type a skill and press Enter (e.g., Python, Design)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: Icon(Icons.add, color: Color(0xFF2874F0)),
            ),
            onSubmitted: (value) => _addSkill(value),
          ),
          SizedBox(height: 8),
          _buildSkillSuggestions(),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: skills.map((skill) => Chip(
              label: Text(skill),
              onDeleted: () => setState(() => skills.remove(skill)),
              backgroundColor: Color(0xFF2874F0).withOpacity(0.1),
            )).toList(),
          ),
          SizedBox(height: 24),

          // Interests
          Text('Interests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          TextField(
            controller: interestController,
            decoration: InputDecoration(
              hintText: 'Type an interest and press Enter (e.g., AI, Finance)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: Icon(Icons.add, color: Color(0xFF2874F0)),
            ),
            onSubmitted: (value) => _addInterest(value),
          ),
          SizedBox(height: 8),
          _buildInterestSuggestions(),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: interests.map((interest) => Chip(
              label: Text(interest),
              onDeleted: () => setState(() => interests.remove(interest)),
              backgroundColor: Colors.orange.withOpacity(0.1),
            )).toList(),
          ),
          SizedBox(height: 40),

          // Get Recommendations Button
          Container(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isProfileComplete() ? getAIRecommendations : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isProfileComplete() ? Color(0xFF2874F0) : Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: isLoading
                ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Text(
                    isProfileComplete() ? 'Get AI Recommendations' : 'Complete Profile First',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
            ),
          ),
          SizedBox(height: 16),
          
          // Profile Completion Indicator
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isProfileComplete() ? Colors.green[50] : Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isProfileComplete() ? Colors.green[200]! : Colors.orange[200]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isProfileComplete() ? Icons.check_circle : Icons.info,
                  color: isProfileComplete() ? Colors.green : Colors.orange,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isProfileComplete() 
                      ? 'Profile complete! Ready for AI recommendations'
                      : 'Add at least 2 skills and 1 interest to get recommendations',
                    style: TextStyle(
                      fontSize: 14,
                      color: isProfileComplete() ? Colors.green[700] : Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecommendations() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => showRecommendations = false),
                icon: Icon(Icons.arrow_back),
              ),
              Text(
                'Career Recommendations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final career = recommendations[index];
              final matchScore = career['match_score'].toDouble();
              final matchColor = matchScore >= 80 ? Colors.green : matchScore >= 60 ? Colors.orange : Colors.red;
              
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey[200]!, blurRadius: 4, offset: Offset(0, 2))],
                  border: Border.all(
                    color: matchScore >= 80 ? Colors.green[200]! : Colors.transparent,
                    width: matchScore >= 80 ? 2 : 0,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (matchScore >= 80) Icon(Icons.star, color: Colors.amber, size: 20),
                          if (matchScore >= 80) SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              career['career'],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: matchColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${matchScore.toStringAsFixed(0)}% Match',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: matchColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (matchScore >= 80) ...[
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '🎆 Top AI Recommendation',
                            style: TextStyle(fontSize: 12, color: Colors.green[700], fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                      SizedBox(height: 12),
                      Text(
                        career['description'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 16),
                      
                      // AI Reasoning
                      if (career['reasoning'] != null && career['reasoning'].isNotEmpty) ...[
                        Text('AI Analysis:', style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF2874F0))),
                        SizedBox(height: 8),
                        ...career['reasoning'].map<Widget>((reason) => 
                          Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              reason,
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                          )
                        ).toList(),
                        SizedBox(height: 16),
                      ],
                      
                      // Skills to Learn
                      if (career['skill_gaps'].isNotEmpty) ...[
                        Text('Skills to Develop:', style: TextStyle(fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: career['skill_gaps'].map<Widget>((skill) => 
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFF2874F0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(fontSize: 12, color: Color(0xFF2874F0)),
                              ),
                            )
                          ).toList(),
                        ),
                        SizedBox(height: 16),
                      ],
                      
                      // Market Info
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('💰 Salary Range', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  Text(
                                    career['market_outlook']['avg_salary'],
                                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green[700]),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('📈 Growth Rate', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  Text(
                                    career['market_outlook']['growth_rate'],
                                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue[700]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CareerPathScreen(
                                      career: {
                                        ...career,
                                        'learning_path': [
                                          'Master the core skills: ${career['skill_gaps'].take(2).join(", ")}',
                                          'Build portfolio projects in ${career['career'].toLowerCase()}',
                                          'Complete relevant certifications',
                                          'Apply for internships or entry-level positions',
                                          'Network with professionals in the field'
                                        ],
                                        'market_outlook': {
                                          ...career['market_outlook'],
                                          'demand': 'High'
                                        }
                                      },
                                      userProfile: {
                                        'skills': skills,
                                        'academic_level': academicLevel,
                                        'stream': stream,
                                        'interests': interests,
                                      },
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2874F0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text('Explore Path', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setState(() => showChat = true),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0xFF2874F0)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text('Ask AI', style: TextStyle(color: Color(0xFF2874F0))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool isProfileComplete() {
    return skills.length >= 2 && interests.length >= 1;
  }

  getAIRecommendations() async {
    if (!isProfileComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least 2 skills and 1 interest'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    
    try {
      // Offline AI recommendations based on user profile
      List<Map<String, dynamic>> aiRecommendations = _generateOfflineRecommendations();
      
      setState(() {
        recommendations = aiRecommendations;
        botMessage = 'AI found ${aiRecommendations.length} perfect matches for your ${stream} profile!';
        isLoading = false;
        showRecommendations = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎯 ${aiRecommendations.length} AI-powered matches found!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating recommendations'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  List<Map<String, dynamic>> _generateOfflineRecommendations() {
    Map<String, List<Map<String, dynamic>>> careerDatabase = {
      'engineering': [
        {
          'career': 'Software Developer',
          'description': 'Design and build software applications using programming languages',
          'required_skills': ['Python', 'JavaScript', 'Java', 'Git', 'Problem Solving'],
          'salary_range': '₹6-15 LPA',
          'job_outlook': 'Excellent growth prospects'
        },
        {
          'career': 'Data Scientist',
          'description': 'Analyze complex data to extract insights and build predictive models',
          'required_skills': ['Python', 'Statistics', 'Machine Learning', 'SQL', 'Data Analysis'],
          'salary_range': '₹8-20 LPA',
          'job_outlook': 'Very high demand'
        },
        {
          'career': 'AI/ML Engineer',
          'description': 'Develop artificial intelligence and machine learning systems',
          'required_skills': ['Python', 'TensorFlow', 'Machine Learning', 'Deep Learning', 'AI'],
          'salary_range': '₹10-25 LPA',
          'job_outlook': 'Rapidly growing field'
        }
      ],
      'business': [
        {
          'career': 'Business Analyst',
          'description': 'Analyze business processes and recommend improvements',
          'required_skills': ['Analytics', 'Excel', 'Communication', 'Problem Solving', 'Strategy'],
          'salary_range': '₹5-12 LPA',
          'job_outlook': 'Strong demand'
        },
        {
          'career': 'Digital Marketing Manager',
          'description': 'Plan and execute digital marketing campaigns',
          'required_skills': ['Marketing', 'Analytics', 'Social Media', 'Communication', 'Strategy'],
          'salary_range': '₹4-10 LPA',
          'job_outlook': 'Growing rapidly'
        }
      ],
      'commerce': [
        {
          'career': 'Financial Analyst',
          'description': 'Analyze financial data and investment opportunities',
          'required_skills': ['Finance', 'Excel', 'Accounting', 'Analytics', 'Investment'],
          'salary_range': '₹4-12 LPA',
          'job_outlook': 'Stable growth'
        },
        {
          'career': 'Investment Banker',
          'description': 'Help companies raise capital and manage financial transactions',
          'required_skills': ['Finance', 'Investment', 'Analytics', 'Communication', 'Business'],
          'salary_range': '₹8-25 LPA',
          'job_outlook': 'High earning potential'
        }
      ],
      'science': [
        {
          'career': 'Research Scientist',
          'description': 'Conduct scientific research and experiments',
          'required_skills': ['Research', 'Data Analysis', 'Statistics', 'Critical Thinking', 'Innovation'],
          'salary_range': '₹5-15 LPA',
          'job_outlook': 'Steady demand'
        },
        {
          'career': 'Biotechnology Specialist',
          'description': 'Apply biological processes to develop products and technologies',
          'required_skills': ['Biology', 'Research', 'Laboratory Skills', 'Innovation', 'Analysis'],
          'salary_range': '₹4-12 LPA',
          'job_outlook': 'Growing field'
        }
      ],
      'arts': [
        {
          'career': 'UX/UI Designer',
          'description': 'Design user experiences and interfaces for digital products',
          'required_skills': ['Design', 'Creativity', 'Figma', 'User Research', 'Visual Arts'],
          'salary_range': '₹4-15 LPA',
          'job_outlook': 'High demand'
        },
        {
          'career': 'Content Creator',
          'description': 'Create engaging content for digital platforms',
          'required_skills': ['Creativity', 'Writing', 'Content Creation', 'Social Media', 'Storytelling'],
          'salary_range': '₹3-10 LPA',
          'job_outlook': 'Rapidly expanding'
        }
      ],
      'medicine': [
        {
          'career': 'Medical Doctor',
          'description': 'Diagnose and treat patients in various medical specialties',
          'required_skills': ['Medical Knowledge', 'Patient Care', 'Biology', 'Communication', 'Critical Thinking'],
          'salary_range': '₹8-30 LPA',
          'job_outlook': 'Always in demand'
        },
        {
          'career': 'Healthcare Data Analyst',
          'description': 'Analyze healthcare data to improve patient outcomes',
          'required_skills': ['Data Analysis', 'Healthcare', 'Statistics', 'Medical Knowledge', 'Research'],
          'salary_range': '₹5-15 LPA',
          'job_outlook': 'Growing field'
        }
      ]
    };
    
    List<Map<String, dynamic>> allCareers = [];
    careerDatabase.forEach((field, careers) {
      allCareers.addAll(careers);
    });
    
    // Calculate match scores for all careers
    List<Map<String, dynamic>> scoredCareers = allCareers.map((career) {
      int matchScore = _calculateOfflineMatchScore(career, stream, skills, interests);
      return {
        'career': career['career'],
        'description': career['description'],
        'match_score': matchScore,
        'reasoning': _generateOfflineReasoning(career, skills, interests, matchScore),
        'skill_gaps': _getOfflineSkillGaps(career['required_skills'], skills),
        'market_outlook': {
          'avg_salary': career['salary_range'],
          'growth_rate': career['job_outlook'],
        }
      };
    }).toList();
    
    // Sort by match score and return top 4
    scoredCareers.sort((a, b) => b['match_score'].compareTo(a['match_score']));
    return scoredCareers.take(4).toList();
  }
  
  int _calculateOfflineMatchScore(Map<String, dynamic> career, String userStream, List<String> userSkills, List<String> userInterests) {
    int score = 40; // Base score
    
    // Stream matching (30 points)
    String careerTitle = career['career'].toLowerCase();
    if (_matchesStream(careerTitle, userStream)) {
      score += 30;
    } else if (_relatedToStream(careerTitle, userStream)) {
      score += 20;
    }
    
    // Skill matching (25 points)
    List<String> requiredSkills = List<String>.from(career['required_skills']);
    int skillMatches = 0;
    for (String skill in userSkills) {
      if (requiredSkills.any((req) => req.toLowerCase().contains(skill.toLowerCase()) || skill.toLowerCase().contains(req.toLowerCase()))) {
        skillMatches++;
      }
    }
    score += (skillMatches * 5).clamp(0, 25);
    
    // Interest matching (15 points)
    String careerText = '${career['career']} ${career['description']}'.toLowerCase();
    int interestMatches = 0;
    for (String interest in userInterests) {
      if (careerText.contains(interest.toLowerCase()) || requiredSkills.any((skill) => skill.toLowerCase().contains(interest.toLowerCase()))) {
        interestMatches++;
      }
    }
    score += (interestMatches * 5).clamp(0, 15);
    
    return score.clamp(40, 100);
  }
  
  bool _matchesStream(String careerTitle, String stream) {
    Map<String, List<String>> streamKeywords = {
      'engineering': ['software', 'developer', 'engineer', 'data scientist', 'ai', 'ml'],
      'business': ['business', 'analyst', 'marketing', 'manager'],
      'commerce': ['financial', 'investment', 'banking', 'finance'],
      'science': ['research', 'scientist', 'biotechnology'],
      'arts': ['designer', 'creative', 'content', 'ux', 'ui'],
      'medicine': ['medical', 'doctor', 'healthcare', 'patient']
    };
    
    List<String> keywords = streamKeywords[stream.toLowerCase()] ?? [];
    return keywords.any((keyword) => careerTitle.contains(keyword));
  }
  
  bool _relatedToStream(String careerTitle, String stream) {
    return careerTitle.contains('analyst') || careerTitle.contains('specialist') || careerTitle.contains('manager');
  }
  
  List<String> _generateOfflineReasoning(Map<String, dynamic> career, List<String> userSkills, List<String> userInterests, int matchScore) {
    List<String> reasons = [];
    
    if (matchScore >= 80) {
      reasons.add('🎯 Excellent match for your profile and interests');
    } else if (matchScore >= 70) {
      reasons.add('✅ Strong alignment with your skills and background');
    }
    
    List<String> requiredSkills = List<String>.from(career['required_skills']);
    List<String> matchedSkills = userSkills.where((skill) => 
      requiredSkills.any((req) => req.toLowerCase().contains(skill.toLowerCase()) || skill.toLowerCase().contains(req.toLowerCase()))
    ).toList();
    
    if (matchedSkills.isNotEmpty) {
      reasons.add('💪 Your ${matchedSkills.take(2).join(", ")} skills are highly relevant');
    }
    
    String careerText = '${career['career']} ${career['description']}'.toLowerCase();
    List<String> matchedInterests = userInterests.where((interest) => 
      careerText.contains(interest.toLowerCase())
    ).toList();
    
    if (matchedInterests.isNotEmpty) {
      reasons.add('❤️ Aligns with your passion for ${matchedInterests.take(2).join(", ")}');
    }
    
    if (career['job_outlook'].toString().toLowerCase().contains('excellent') || 
        career['job_outlook'].toString().toLowerCase().contains('high')) {
      reasons.add('📈 Excellent career growth and market demand');
    }
    
    return reasons.take(3).toList();
  }
  
  List<String> _getOfflineSkillGaps(List<String> requiredSkills, List<String> userSkills) {
    return requiredSkills.where((skill) => 
      !userSkills.any((userSkill) => userSkill.toLowerCase().contains(skill.toLowerCase()) || skill.toLowerCase().contains(userSkill.toLowerCase()))
    ).toList();
  }
  
  int _calculateAdvancedMatchScore(Career career, String userStream, List<String> userSkills, List<String> userInterests) {
    double score = 50; // Base score
    
    // Stream matching (30 points)
    if (_isExactStreamMatch(career.title, userStream)) {
      score += 30;
    } else if (_isRelatedStreamMatch(career.title, userStream)) {
      score += 20;
    } else if (_isCrossStreamMatch(career.title, userStream)) {
      score += 10;
    }
    
    // Advanced skill matching (25 points)
    double skillScore = _calculateSkillMatchScore(career.requiredSkills, userSkills);
    score += skillScore * 25;
    
    // Interest matching (20 points)
    double interestScore = _calculateInterestMatchScore(career, userInterests);
    score += interestScore * 20;
    
    // Market demand bonus (5 points)
    if (career.jobOutlook.toLowerCase().contains('excellent') || 
        career.jobOutlook.toLowerCase().contains('very good')) {
      score += 5;
    }
    
    return score.round().clamp(50, 100);
  }
  
  bool _isExactStreamMatch(String careerTitle, String stream) {
    Map<String, List<String>> exactMatches = {
      'engineering': ['software engineer', 'data scientist', 'engineer'],
      'business': ['business analyst', 'marketing', 'manager'],
      'commerce': ['financial analyst', 'business', 'marketing'],
      'science': ['data scientist', 'research', 'analyst'],
      'arts': ['designer', 'creative', 'content'],
      'medicine': ['medical', 'health', 'clinical'],
    };
    
    List<String> keywords = exactMatches[stream.toLowerCase()] ?? [];
    return keywords.any((keyword) => careerTitle.toLowerCase().contains(keyword));
  }
  
  bool _isRelatedStreamMatch(String careerTitle, String stream) {
    Map<String, List<String>> relatedMatches = {
      'engineering': ['technical', 'developer', 'analyst'],
      'business': ['analyst', 'consultant', 'specialist'],
      'commerce': ['analyst', 'specialist', 'consultant'],
      'science': ['technical', 'specialist', 'engineer'],
      'arts': ['digital', 'marketing', 'specialist'],
      'medicine': ['research', 'analyst', 'specialist'],
    };
    
    List<String> keywords = relatedMatches[stream.toLowerCase()] ?? [];
    return keywords.any((keyword) => careerTitle.toLowerCase().contains(keyword));
  }
  
  bool _isCrossStreamMatch(String careerTitle, String stream) {
    // Cross-disciplinary matches
    return careerTitle.toLowerCase().contains('digital') || 
           careerTitle.toLowerCase().contains('technical') ||
           careerTitle.toLowerCase().contains('analyst');
  }
  
  double _calculateSkillMatchScore(List<String> requiredSkills, List<String> userSkills) {
    if (requiredSkills.isEmpty || userSkills.isEmpty) return 0.3;
    
    int exactMatches = 0;
    int partialMatches = 0;
    
    for (String reqSkill in requiredSkills) {
      for (String userSkill in userSkills) {
        if (reqSkill.toLowerCase() == userSkill.toLowerCase()) {
          exactMatches++;
          break;
        } else if (reqSkill.toLowerCase().contains(userSkill.toLowerCase()) ||
                   userSkill.toLowerCase().contains(reqSkill.toLowerCase())) {
          partialMatches++;
          break;
        }
      }
    }
    
    double matchRatio = (exactMatches * 1.0 + partialMatches * 0.7) / requiredSkills.length;
    return matchRatio.clamp(0.0, 1.0);
  }
  
  double _calculateInterestMatchScore(Career career, List<String> userInterests) {
    if (userInterests.isEmpty) return 0.3;
    
    int matches = 0;
    String careerText = '${career.title} ${career.description}'.toLowerCase();
    
    for (String interest in userInterests) {
      if (careerText.contains(interest.toLowerCase()) ||
          career.requiredSkills.any((skill) => skill.toLowerCase().contains(interest.toLowerCase()))) {
        matches++;
      }
    }
    
    return (matches / userInterests.length).clamp(0.0, 1.0);
  }
  
  List<String> _generateAdvancedReasoning(Career career, List<String> userSkills, List<String> userInterests) {
    List<String> reasons = [];
    
    // Stream alignment
    if (_isExactStreamMatch(career.title, stream)) {
      reasons.add('🎯 Perfect alignment with your ${stream} background');
    } else if (_isRelatedStreamMatch(career.title, stream)) {
      reasons.add('🔗 Strong connection to your ${stream} field');
    }
    
    // Skill analysis
    List<String> matchedSkills = career.requiredSkills.where((skill) => 
      userSkills.any((userSkill) => 
        skill.toLowerCase().contains(userSkill.toLowerCase()) ||
        userSkill.toLowerCase().contains(skill.toLowerCase())
      )
    ).toList();
    
    if (matchedSkills.isNotEmpty) {
      reasons.add('💪 Your ${matchedSkills.take(2).join(", ")} skills are highly relevant');
    }
    
    // Interest alignment
    List<String> matchedInterests = userInterests.where((interest) => 
      career.title.toLowerCase().contains(interest.toLowerCase()) ||
      career.description.toLowerCase().contains(interest.toLowerCase()) ||
      career.requiredSkills.any((skill) => skill.toLowerCase().contains(interest.toLowerCase()))
    ).toList();
    
    if (matchedInterests.isNotEmpty) {
      reasons.add('❤️ Matches your passion for ${matchedInterests.take(2).join(", ")}');
    }
    
    // Market insights
    if (career.jobOutlook.toLowerCase().contains('excellent')) {
      reasons.add('📈 Excellent market growth and job opportunities');
    } else if (career.jobOutlook.toLowerCase().contains('good')) {
      reasons.add('📊 Strong market demand and career stability');
    }
    
    // Academic level fit
    if (academicLevel == 'undergraduate') {
      reasons.add('🎓 Great entry-level opportunities for fresh graduates');
    } else if (academicLevel == 'postgraduate') {
      reasons.add('🎓 Advanced roles matching your higher education');
    }
    
    return reasons.take(4).toList();
  }
  
  List<String> _getSkillGaps(List<String> requiredSkills, List<String> userSkills) {
    return requiredSkills.where((skill) => 
      !userSkills.any((userSkill) => userSkill.toLowerCase().contains(skill.toLowerCase()))
    ).toList();
  }
  
  void _addSkill(String skill) {
    if (skill.trim().isNotEmpty && !skills.contains(skill.trim())) {
      setState(() {
        skills.add(skill.trim());
        skillController.clear();
      });
    }
  }
  
  void _addInterest(String interest) {
    if (interest.trim().isNotEmpty && !interests.contains(interest.trim())) {
      setState(() {
        interests.add(interest.trim());
        interestController.clear();
      });
    }
  }
  
  Widget _buildSkillSuggestions() {
    List<String> suggestions = _getSkillSuggestions();
    if (suggestions.isEmpty) return SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Suggested Skills:', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 4),
        Wrap(
          spacing: 6,
          children: suggestions.map((skill) => 
            GestureDetector(
              onTap: () => _addSkill(skill),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF2874F0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF2874F0).withOpacity(0.3)),
                ),
                child: Text(
                  skill,
                  style: TextStyle(fontSize: 11, color: Color(0xFF2874F0)),
                ),
              ),
            )
          ).toList(),
        ),
      ],
    );
  }
  
  Widget _buildInterestSuggestions() {
    List<String> suggestions = _getInterestSuggestions();
    if (suggestions.isEmpty) return SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Suggested Interests:', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 4),
        Wrap(
          spacing: 6,
          children: suggestions.map((interest) => 
            GestureDetector(
              onTap: () => _addInterest(interest),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Text(
                  interest,
                  style: TextStyle(fontSize: 11, color: Colors.orange[700]),
                ),
              ),
            )
          ).toList(),
        ),
      ],
    );
  }
  
  List<String> _getSkillSuggestions() {
    Map<String, List<String>> streamSkills = {
      'engineering': ['Python', 'JavaScript', 'Java', 'React', 'Node.js', 'SQL', 'Git'],
      'business': ['Excel', 'PowerPoint', 'Analytics', 'Communication', 'Leadership'],
      'commerce': ['Accounting', 'Finance', 'Excel', 'Marketing', 'Sales'],
      'science': ['Research', 'Data Analysis', 'Statistics', 'Python', 'R'],
      'arts': ['Design', 'Creativity', 'Photoshop', 'Illustrator', 'Writing'],
      'medicine': ['Biology', 'Chemistry', 'Research', 'Patient Care', 'Medical Knowledge'],
    };
    
    List<String> suggestions = streamSkills[stream.toLowerCase()] ?? [];
    return suggestions.where((skill) => !skills.contains(skill)).take(5).toList();
  }
  
  List<String> _getInterestSuggestions() {
    Map<String, List<String>> streamInterests = {
      'engineering': ['Technology', 'Innovation', 'Problem Solving', 'AI', 'Robotics'],
      'business': ['Entrepreneurship', 'Strategy', 'Leadership', 'Marketing', 'Finance'],
      'commerce': ['Finance', 'Investment', 'Business', 'Economics', 'Trading'],
      'science': ['Research', 'Discovery', 'Data Science', 'Innovation', 'Analysis'],
      'arts': ['Creativity', 'Design', 'Visual Arts', 'Content Creation', 'Storytelling'],
      'medicine': ['Healthcare', 'Helping Others', 'Medical Research', 'Biology', 'Wellness'],
    };
    
    List<String> suggestions = streamInterests[stream.toLowerCase()] ?? [];
    return suggestions.where((interest) => !interests.contains(interest)).take(5).toList();
  }

  Widget buildChatBot() {
    final messageController = TextEditingController();
    
    // Auto-scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatMessages.isNotEmpty) {
        // Scroll to bottom logic can be added here if needed
      }
    });
    
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => showChat = false),
                icon: Icon(Icons.arrow_back),
              ),
              Icon(Icons.smart_toy, color: Color(0xFF2874F0)),
              SizedBox(width: 8),
              Text(
                'AI Career Advisor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              final message = chatMessages[index];
              final isBot = message['isBot'] ?? false;
              
              final isTyping = message['isTyping'] ?? false;
              
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    if (isBot) ...[
                      CircleAvatar(
                        backgroundColor: Color(0xFF2874F0),
                        radius: 16,
                        child: Icon(Icons.smart_toy, color: Colors.white, size: 16),
                      ),
                      SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isBot ? Colors.grey[100] : Color(0xFF2874F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: isTyping 
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Typing...',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                message['text'],
                                style: TextStyle(
                                  color: isBot ? Colors.black87 : Colors.white,
                                ),
                              ),
                      ),
                    ),
                    if (!isBot) ...[
                      SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 16,
                        child: Icon(Icons.person, color: Colors.grey[600], size: 16),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        // Quick Actions
        if (chatMessages.length <= 1) // Show only initially
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildQuickActionChip('Career recommendations', messageController),
                    _buildQuickActionChip('Salary insights', messageController),
                    _buildQuickActionChip('Skill development', messageController),
                    _buildQuickActionChip('Learning path', messageController),
                  ],
                ),
              ],
            ),
          ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
          color: Colors.white,
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    onSubmitted: (text) => sendMessage(messageController),
                    decoration: InputDecoration(
                      hintText: 'Ask me about careers...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Color(0xFF2874F0),
                  onPressed: () => sendMessage(messageController),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  sendMessage(TextEditingController controller) async {
    if (controller.text.trim().isEmpty) return;
    
    final userMessage = controller.text;
    setState(() {
      chatMessages.add({'text': userMessage, 'isBot': false});
    });
    controller.clear();
    
    // Show typing indicator
    setState(() {
      chatMessages.add({'text': 'Typing...', 'isBot': true, 'isTyping': true});
    });
    
    try {
      final response = await http.post(
        Uri.parse('http://192.168.94.161:8000/api/ai/chat-bot/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'message': userMessage,
          'profile': {
            'skills': skills,
            'academic_level': academicLevel,
            'stream': stream,
            'interests': interests,
          }
        }),
      ).timeout(Duration(seconds: 10));
      
      // Remove typing indicator
      setState(() {
        chatMessages.removeWhere((msg) => msg['isTyping'] == true);
      });
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          chatMessages.add({
            'text': data['bot_response'] ?? 'Sorry, I couldn\'t process that.',
            'isBot': true
          });
        });
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        _addOfflineBotResponse(userMessage);
      }
    } catch (e) {
      print('Network Error: $e');
      // Remove typing indicator
      setState(() {
        chatMessages.removeWhere((msg) => msg['isTyping'] == true);
      });
      _addOfflineBotResponse(userMessage);
    }
  }
  
  void _addOfflineBotResponse(String userMessage) {
    String botResponse = _generateOfflineBotResponse(userMessage);
    setState(() {
      chatMessages.add({
        'text': botResponse,
        'isBot': true
      });
    });
  }
  
  Widget _buildQuickActionChip(String text, TextEditingController controller) {
    return GestureDetector(
      onTap: () {
        controller.text = text;
        sendMessage(controller);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFF2874F0).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF2874F0).withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFF2874F0),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _generateOfflineBotResponse(String message) {
    String msg = message.toLowerCase();
    
    if (msg.contains('hello') || msg.contains('hi') || msg.contains('hey')) {
      return "Hello! 👋 Great to see you again! I'm here to help with your career journey. Based on your ${stream} background and ${skills.length} skills, what specific guidance can I provide today?";
    }
    
    if (msg.contains('career') || msg.contains('job')) {
      if (skills.isNotEmpty) {
        return "🚀 Excellent! With your skills in ${skills.take(3).join(', ')}, you have great potential in ${stream}. I can see opportunities in:\n\n• Software Development\n• Data Analysis\n• Product Management\n• Consulting\n\nWould you like detailed recommendations for any of these?";
      }
      return "🎯 Perfect! ${stream} offers amazing career opportunities. Let me help you discover the best paths. What type of work environment do you prefer - technical, creative, or business-focused?";
    }
    
    if (msg.contains('skill')) {
      List<String> suggestions = _getSkillSuggestions();
      if (suggestions.isNotEmpty) {
        return "📚 Perfect timing! For ${stream}, I highly recommend:\n\n${suggestions.take(3).map((s) => '• $s').join('\n')}\n\nThese skills are trending and will significantly boost your career prospects. Which one interests you most?";
      }
      return "🎯 Skills are your career superpower! What area excites you most - technical skills, soft skills, or industry-specific knowledge? I can create a personalized learning plan!";
    }
    
    if (msg.contains('salary') || msg.contains('pay')) {
      return "💰 Great question! In ${stream}:\n\n• Entry Level: ₹4-8 LPA\n• Mid Level: ₹8-15 LPA\n• Senior Level: ₹15-30+ LPA\n• Expert Level: ₹30+ LPA\n\nYour skills in ${skills.take(2).join(' and ')} are in high demand! Location and company size also impact salaries significantly.";
    }
    
    if (msg.contains('learn') || msg.contains('study')) {
      return "🎓 Awesome mindset! For ${stream}, I recommend:\n\n• Online courses (Coursera, Udemy)\n• Hands-on projects\n• Industry certifications\n• Building a portfolio\n\nWhat specific skill or technology would you like to master first? I can suggest the best learning path!";
    }
    
    if (msg.contains('future') || msg.contains('trend')) {
      return "🔮 The future is exciting for ${stream}! Key trends:\n\n• AI & Machine Learning integration\n• Automation & Digital transformation\n• Remote work opportunities\n• Sustainability focus\n\nYour current skills position you well for these emerging opportunities. Ready to future-proof your career?";
    }
    
    return "I'm here to help! 🎯 As your AI career advisor, I can assist with:\n\n• Career matching & recommendations\n• Skill gap analysis\n• Salary & market insights\n• Learning roadmaps\n\nBased on your ${stream} background, what would you like to explore first?";
  }
}