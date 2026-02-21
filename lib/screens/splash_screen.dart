import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  _checkAuth() async {
    await Future.delayed(Duration(seconds: 1)); // Shorter delay
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      // Quick auth check with timeout
      await authProvider.checkAuthState().timeout(Duration(seconds: 4));
    } catch (e) {
      // Continue even if auth check fails (offline mode)
      print('Auth check failed (offline mode): $e');
    }
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => authProvider.isAuthenticated 
            ? DashboardScreen() 
            : LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFF2874F0),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.work_outline,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 32),
            Text(
              'FutureFinder',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2874F0),
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your AI Career Navigator',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 48),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2874F0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}