import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/career_provider.dart';
import 'providers/goal_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/recommendations_screen.dart';
import 'screens/live_jobs_screen.dart';
import 'screens/login_activity_screen.dart';
import 'screens/goals_screen.dart';
import 'screens/job_applications_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CareerProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
      ],
      child: MaterialApp(
        title: 'FutureFinder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: Color(0xFF2874F0),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF2874F0),
            brightness: Brightness.light,
          ),
          fontFamily: 'Inter',
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF2874F0),
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        home: SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/profile': (context) => ProfileScreen(),
          '/recommendations': (context) => RecommendationsScreen(),
          '/live-jobs': (context) => LiveJobsScreen(),
          '/login-activity': (context) => LoginActivityScreen(),
          '/goals': (context) => GoalsScreen(),
          '/job-applications': (context) => JobApplicationsScreen(),
        },
      ),
    );
  }
}