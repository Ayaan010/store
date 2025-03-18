import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../utils/logger_util.dart';
import 'login_screen.dart';
// import 'package:flutter/foundation.dart' show kDebugMode;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from Firestore
  Future<void> _loadUserData() async {
    LoggerUtil.info('Starting to load user data');

    setState(() {
      _isLoading = true;
    });

    try {
      if (_currentUser == null) {
        LoggerUtil.warning('No current user found');
        throw Exception('No authenticated user');
      }

      LoggerUtil.info('Attempting to load user data for: ${_currentUser.uid}');

      final userData = await _authService.getUserData();

      LoggerUtil.info('User data received: $userData');

      if (mounted) {
        setState(() {
          _userData =
              userData ??
              {
                'displayName': _currentUser.displayName,
                'email': _currentUser.email,
                'phoneNumber': 'Not available',
              };
        });
      }
    } catch (e) {
      LoggerUtil.error('Error loading user data', e);

      if (mounted) {
        setState(() {
          // Create default userData from Firebase Auth if Firestore data is not available
          _userData = {
            'displayName': _currentUser?.displayName,
            'email': _currentUser?.email,
            'phoneNumber': 'Not available',
          };
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not load additional user data: ${e.toString()}',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Sign out method
  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFAB40),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFF2D3250),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF2D3250)),
            onPressed: () {
              // Edit profile functionality can be added here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile coming soon!')),
              );
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                slivers: [
                  // Profile header with avatar
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          // Profile avatar
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(51),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child:
                                  _currentUser?.photoURL != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: Image.network(
                                          _currentUser!.photoURL!,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                      : const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Color(0xFF628673),
                                      ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // User name
                          Text(
                            _currentUser?.displayName ?? 'User',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3250),
                            ),
                          ),
                          const SizedBox(height: 5),
                          // User email
                          Text(
                            _currentUser?.email ?? 'No email',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xFF2D3250).withAlpha(179),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Profile details section
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF628673),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Account Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Profile details list
                          _buildProfileItem(
                            icon: Icons.person_outline,
                            title: 'Full Name',
                            value: _currentUser?.displayName ?? 'Not set',
                          ),
                          _buildProfileItem(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: _currentUser?.email ?? 'Not set',
                          ),
                          _buildProfileItem(
                            icon: Icons.phone_outlined,
                            title: 'Phone',
                            value: _userData?['phoneNumber'] ?? 'Not set',
                          ),
                          _buildProfileItem(
                            icon: Icons.verified_outlined,
                            title: 'Email Verified',
                            value:
                                _currentUser?.emailVerified ?? false
                                    ? 'Yes'
                                    : 'No',
                          ),
                          _buildProfileItem(
                            icon: Icons.calendar_today_outlined,
                            title: 'Account Created',
                            value:
                                _currentUser?.metadata.creationTime != null
                                    ? _formatDate(
                                      _currentUser!.metadata.creationTime!,
                                    )
                                    : 'Unknown',
                          ),

                          const SizedBox(height: 40),

                          // Sign out button
                          Center(
                            child: SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signOut,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF004D40),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.logout),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isLoading
                                          ? 'Signing Out...'
                                          : 'Sign Out',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  // Helper method to build profile information items
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFAB40).withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFFFAB40), size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format date
  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
