import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginActivityScreen extends StatefulWidget {
  @override
  _LoginActivityScreenState createState() => _LoginActivityScreenState();
}

class _LoginActivityScreenState extends State<LoginActivityScreen> {
  Map<String, String?> loginData = {};

  @override
  void initState() {
    super.initState();
    _loadLoginActivity();
  }

  _loadLoginActivity() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final data = await auth.getLoginActivity();
    setState(() {
      loginData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Activity'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Session',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            _buildInfoCard('Email', loginData['email'] ?? 'Not available', Icons.email),
            SizedBox(height: 16),
            _buildInfoCard('Login Method', loginData['method'] ?? 'Not available', Icons.login),
            SizedBox(height: 16),
            _buildInfoCard('Last Login', _formatDate(loginData['last_login']), Icons.access_time),
            SizedBox(height: 16),
            _buildInfoCard('Status', 'Active', Icons.check_circle, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, [Color? color]) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey[200]!, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? Color(0xFF2874F0), size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Not available';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Not available';
    }
  }
}