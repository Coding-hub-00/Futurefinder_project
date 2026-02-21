import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChange;
  
  HomeScreen({required this.onTabChange});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Rebuild to show/hide clear button
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'signout') {
                _signOut(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'signout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Sign Out'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good morning!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Find your dream career',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/profile'),
                          child: CircleAvatar(
                            backgroundColor: Color(0xFF2874F0),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: _performSearch,
                        decoration: InputDecoration(
                          hintText: 'Search careers, jobs, courses...',
                          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // Quick Stats
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(child: _buildStatCard('Career Matches', '12', Icons.work_outline, () => widget.onTabChange(1))),
                    SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Goals', '5', Icons.flag_outlined, () => _showGoalsDialog())),
                    SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Skills', '8', Icons.star_outline, () => _showSkillsDialog())),
                  ],
                ),
              ),
              SizedBox(height: 24),
              
              // Tabs Section
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _buildTabCard('Quick Rec', Icons.flash_on, () => Navigator.pushNamed(context, '/profile')),
                          SizedBox(width: 12),
                          _buildTabCard('AI Match', Icons.psychology, () => widget.onTabChange(1)),
                          SizedBox(width: 12),
                          _buildTabCard('Jobs', Icons.work, () => widget.onTabChange(2)),
                          SizedBox(width: 12),
                          _buildTabCard('Learning', Icons.school, () => widget.onTabChange(3)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // AI Career Match
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'AI Career Match',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () => widget.onTabChange(1),
                            child: Text(
                              'View All',
                              style: TextStyle(color: Color(0xFF2874F0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _buildAIMatchCard('Flutter Developer', '95% Match', 'Mobile App Development'),
                          SizedBox(width: 16),
                          _buildAIMatchCard('Data Scientist', '88% Match', 'AI & Machine Learning'),
                          SizedBox(width: 16),
                          _buildAIMatchCard('UI/UX Designer', '82% Match', 'Design & User Experience'),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey[200]!, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, color: Color(0xFF2874F0), size: 24),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFF2874F0).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF2874F0).withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Color(0xFF2874F0), size: 18),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF2874F0),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIMatchCard(String title, String matchScore, String category) {
    return Container(
      width: 280,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey[200]!, blurRadius: 4, offset: Offset(0, 2))],
        border: Border.all(color: Color(0xFF2874F0).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF2874F0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.psychology, color: Color(0xFF2874F0), size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 14, color: Colors.green[700]),
                SizedBox(width: 4),
                Text(
                  matchScore,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Text(
            'AI analyzed your profile and found this career matches your skills and interests perfectly.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onTabChange(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2874F0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(
                'Explore Match',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFF2874F0).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        skill,
        style: TextStyle(
          fontSize: 12,
          color: Color(0xFF2874F0),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    
    // Show search results dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Results'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Searching for: "$query"'),
            SizedBox(height: 16),
            Text('Feature coming soon! You can explore:'),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.psychology, color: Color(0xFF2874F0)),
              title: Text('AI Career Match'),
              onTap: () {
                Navigator.pop(context);
                widget.onTabChange(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.work, color: Color(0xFF2874F0)),
              title: Text('Jobs'),
              onTap: () {
                Navigator.pop(context);
                widget.onTabChange(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.school, color: Color(0xFF2874F0)),
              title: Text('Learning'),
              onTap: () {
                Navigator.pop(context);
                widget.onTabChange(3);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showGoalsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Career Goals'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.flag, color: Colors.green),
              title: Text('Complete Flutter Course'),
              subtitle: Text('In Progress'),
            ),
            ListTile(
              leading: Icon(Icons.flag, color: Colors.orange),
              title: Text('Get Job in Tech'),
              subtitle: Text('Planning'),
            ),
            ListTile(
              leading: Icon(Icons.flag, color: Colors.blue),
              title: Text('Learn Data Science'),
              subtitle: Text('Future Goal'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
            child: Text('Manage Goals'),
          ),
        ],
      ),
    );
  }

  void _showSkillsDialog() {
    List<String> skills = ['Flutter', 'Dart', 'Python', 'JavaScript', 'React', 'Node.js', 'SQL', 'Git'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Your Skills'),
        content: Container(
          width: double.maxFinite,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) => Chip(
              label: Text(skill),
              backgroundColor: Color(0xFF2874F0).withOpacity(0.1),
              labelStyle: TextStyle(color: Color(0xFF2874F0)),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
            child: Text('Edit Skills'),
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) {
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