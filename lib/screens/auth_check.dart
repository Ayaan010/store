import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/logger_util.dart';
import 'home_screen.dart';
import 'landing_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Check if user is already signed in
      final User? user = _auth.currentUser;

      if (user != null) {
        LoggerUtil.info('User is already signed in: ${user.uid}');
        setState(() {
          _isAuthenticated = true;
          _isLoading = false;
        });
      } else {
        LoggerUtil.info('No user is signed in');
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      LoggerUtil.error('Error checking auth status', e);
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFAB40),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF004D40)),
        ),
      );
    }

    // Navigate to the appropriate screen based on authentication status
    return _isAuthenticated ? const HomeScreen() : const LandingPage();
  }
}
