import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/career_provider.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skillController = TextEditingController();
  final _interestController = TextEditingController();
  
  String? selectedStream;
  String? selectedField;
  List<String> skills = [];
  List<String> interests = [];

  final List<String> indianStreams = [
    'Science (PCM)', 'Science (PCB)', 'Commerce', 'Arts/Humanities',
    'Engineering', 'Medical', 'Management', 'Law', 'Architecture',
    'Design', 'Agriculture', 'Pharmacy', 'Nursing', 'Veterinary',
    'Mass Communication', 'Hotel Management', 'Fashion Design',
    'Fine Arts', 'Music', 'Dance', 'Sports', 'Aviation'
  ];

  final Map<String, List<String>> fieldsByStream = {
    'Engineering': ['Computer Science', 'Information Technology', 'Electronics', 'Mechanical', 'Civil', 'Chemical', 'Electrical', 'Aerospace', 'Biotechnology', 'Automobile'],
    'Medical': ['MBBS', 'BDS', 'BAMS', 'BHMS', 'Physiotherapy', 'Nursing', 'Pharmacy', 'Medical Lab Technology', 'Radiology', 'Optometry'],
    'Management': ['MBA', 'BBA', 'Hotel Management', 'Event Management', 'Supply Chain', 'Human Resources', 'Marketing', 'Finance', 'Operations'],
    'Commerce': ['CA', 'CS', 'CMA', 'B.Com', 'Economics', 'Banking', 'Insurance', 'Taxation', 'Accounting', 'Business Analytics'],
    'Arts/Humanities': ['Psychology', 'Sociology', 'Political Science', 'History', 'Geography', 'Literature', 'Philosophy', 'Journalism', 'Social Work'],
    'Science (PCM)': ['Physics', 'Mathematics', 'Chemistry', 'Statistics', 'Data Science', 'Research', 'Teaching'],
    'Science (PCB)': ['Biology', 'Biotechnology', 'Microbiology', 'Genetics', 'Environmental Science', 'Forensic Science', 'Research'],
    'Design': ['Graphic Design', 'UI/UX Design', 'Fashion Design', 'Interior Design', 'Product Design', 'Animation', 'Game Design'],
    'Law': ['Corporate Law', 'Criminal Law', 'Civil Law', 'Constitutional Law', 'International Law', 'Cyber Law', 'IPR Law'],
    'Mass Communication': ['Journalism', 'Advertising', 'Public Relations', 'Film Making', 'Photography', 'Digital Media', 'Broadcasting']
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        backgroundColor: Color(0xFF2874F0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: Icon(Icons.logout, color: Colors.white),
            tooltip: 'Sign Out',
          ),
          TextButton(
            onPressed: _saveProfile,
            child: Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Recommendation Button
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _getQuickRecommendation,
                  icon: Icon(Icons.flash_on),
                  label: Text('Get Quick Recommendation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Stream Selection
              _buildSectionTitle('Educational Stream'),
              DropdownButtonFormField<String>(
                value: selectedStream,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select your stream',
                ),
                items: indianStreams.map((stream) => DropdownMenuItem(
                  value: stream,
                  child: Text(stream),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStream = value;
                    selectedField = null; // Reset field when stream changes
                  });
                },
                validator: (value) => value == null ? 'Please select a stream' : null,
              ),
              SizedBox(height: 16),

              // Field Selection
              if (selectedStream != null && fieldsByStream.containsKey(selectedStream))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Specialization/Field'),
                    DropdownButtonFormField<String>(
                      value: selectedField,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Select your field',
                      ),
                      items: fieldsByStream[selectedStream]!.map((field) => DropdownMenuItem(
                        value: field,
                        child: Text(field),
                      )).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedField = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),

              // Skills Section
              _buildSectionTitle('Skills'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _skillController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a skill and press Enter',
                      ),
                      onFieldSubmitted: _addSkill,
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _addSkill(_skillController.text),
                    child: Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2874F0),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) => Chip(
                  label: Text(skill),
                  deleteIcon: Icon(Icons.close, size: 18),
                  onDeleted: () => _removeSkill(skill),
                  backgroundColor: Color(0xFF2874F0).withOpacity(0.1),
                  labelStyle: TextStyle(color: Color(0xFF2874F0)),
                )).toList(),
              ),
              SizedBox(height: 16),

              // Interests Section
              _buildSectionTitle('Interests'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _interestController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter an interest and press Enter',
                      ),
                      onFieldSubmitted: _addInterest,
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _addInterest(_interestController.text),
                    child: Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2874F0),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: interests.map((interest) => Chip(
                  label: Text(interest),
                  deleteIcon: Icon(Icons.close, size: 18),
                  onDeleted: () => _removeInterest(interest),
                  backgroundColor: Colors.green.withOpacity(0.1),
                  labelStyle: TextStyle(color: Colors.green[700]),
                )).toList(),
              ),
              SizedBox(height: 24),

              // Popular Skills Suggestions
              _buildSectionTitle('Popular Skills (Tap to add)'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _getPopularSkills().map((skill) => ActionChip(
                  label: Text(skill),
                  onPressed: () => _addSkill(skill),
                  backgroundColor: Colors.grey[100],
                )).toList(),
              ),
              SizedBox(height: 16),

              // Popular Interests Suggestions
              _buildSectionTitle('Popular Interests (Tap to add)'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _getPopularInterests().map((interest) => ActionChip(
                  label: Text(interest),
                  onPressed: () => _addInterest(interest),
                  backgroundColor: Colors.grey[100],
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2874F0),
        ),
      ),
    );
  }

  void _addSkill(String skill) {
    if (skill.trim().isNotEmpty && !skills.contains(skill.trim())) {
      setState(() {
        skills.add(skill.trim());
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      skills.remove(skill);
    });
  }

  void _addInterest(String interest) {
    if (interest.trim().isNotEmpty && !interests.contains(interest.trim())) {
      setState(() {
        interests.add(interest.trim());
        _interestController.clear();
      });
    }
  }

  void _removeInterest(String interest) {
    setState(() {
      interests.remove(interest);
    });
  }

  List<String> _getPopularSkills() {
    return [
      'Python', 'Java', 'JavaScript', 'React', 'Node.js', 'SQL', 'HTML/CSS',
      'Machine Learning', 'Data Analysis', 'Excel', 'PowerPoint', 'Communication',
      'Leadership', 'Problem Solving', 'Teamwork', 'Project Management'
    ];
  }

  List<String> _getPopularInterests() {
    return [
      'Technology', 'Artificial Intelligence', 'Data Science', 'Web Development',
      'Mobile Apps', 'Gaming', 'Music', 'Sports', 'Reading', 'Travel',
      'Photography', 'Cooking', 'Fitness', 'Movies', 'Art', 'Business'
    ];
  }

  void _getQuickRecommendation() {
    if (selectedStream == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select your stream first')),
      );
      return;
    }

    final careerProvider = Provider.of<CareerProvider>(context, listen: false);
    careerProvider.generateQuickRecommendation(selectedStream!, selectedField, skills, interests);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.flash_on, color: Colors.orange),
            SizedBox(width: 8),
            Text('Quick Career Recommendation'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                careerProvider.quickRecommendation ?? 'Loading...',
                style: TextStyle(height: 1.5),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '💡 Complete your profile with more skills and interests for even better recommendations!',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue[700]),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/live-jobs');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text('View Live Jobs'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              careerProvider.loadRecommendations();
              Navigator.pushNamed(context, '/recommendations');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2874F0),
              foregroundColor: Colors.white,
            ),
            child: Text('View All Recommendations'),
          ),
        ],
      ),
    );
  }



  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saving profile...'), backgroundColor: Colors.blue),
        );
        
        // Get current user email from auth provider
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final userEmail = authProvider.user ?? 'demo@example.com';
        
        // Save to Django backend
        await ApiService.saveProfileData(
          email: userEmail,
          skills: skills,
          interests: interests,
          academicLevel: selectedField ?? 'Not specified',
          stream: selectedStream ?? 'Not specified',
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile saved to database successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final auth = Provider.of<AuthProvider>(context, listen: false);
              await auth.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}