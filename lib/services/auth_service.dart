import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../utils/logger_util.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      LoggerUtil.info('Attempting to sign in with email: $email');

      // Validate inputs before attempting sign in
      if (email.isEmpty || password.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Email and password cannot be empty',
        );
      }

      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      LoggerUtil.info('Sign in successful for user: ${result.user?.uid}');
      return result;
    } catch (e) {
      LoggerUtil.error('Error in signInWithEmailAndPassword', e);
      if (e is FirebaseAuthException) {
        LoggerUtil.error('Firebase Auth Error Code: ${e.code}');
        LoggerUtil.error('Firebase Auth Error Message: ${e.message}');
      }
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      LoggerUtil.info('Attempting to create user with email: $email');

      // Check if Firebase is initialized - this is not needed as _auth is a final field
      // and cannot be null, but we'll keep the logging
      LoggerUtil.debug('Firebase Auth instance: $_auth');

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      LoggerUtil.info(
        'User created successfully with ID: ${userCredential.user?.uid}',
      );
      return userCredential;
    } catch (e) {
      LoggerUtil.error('Error in signUpWithEmailAndPassword', e);
      if (e is FirebaseAuthException) {
        LoggerUtil.error('Firebase Auth Error Code: ${e.code}');
        LoggerUtil.error('Firebase Auth Error Message: ${e.message}');
      }
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      LoggerUtil.info('Attempting to sign out user');
      await _auth.signOut();
      LoggerUtil.info('User signed out successfully');
    } catch (e) {
      LoggerUtil.error('Error in signOut', e);
      throw _handleAuthException(e);
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  }) async {
    try {
      // Check if user is authenticated
      if (_auth.currentUser == null) {
        LoggerUtil.error(
          'Error: Current user is null when trying to update profile',
        );
        throw Exception('User not authenticated');
      }

      // Add a small delay to ensure Firebase Auth is ready
      await Future.delayed(const Duration(milliseconds: 500));

      // Update auth profile (name and photo)
      if (displayName != null) {
        LoggerUtil.info('Updating display name to: $displayName');
        await _auth.currentUser?.updateDisplayName(displayName);

        // Add another small delay after updating display name
        await Future.delayed(const Duration(milliseconds: 300));
      }

      if (photoURL != null) {
        LoggerUtil.info('Updating photo URL');
        await _auth.currentUser?.updatePhotoURL(photoURL);
      }

      // Store additional user data in Firestore
      if (_auth.currentUser != null) {
        LoggerUtil.info(
          'Saving user data to Firestore for user: ${_auth.currentUser!.uid}',
        );

        // Check if Firestore is initialized - this is not needed as _firestore is a final field
        // and cannot be null, but we'll keep the logging
        LoggerUtil.debug('Firestore instance: $_firestore');

        try {
          await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
            'displayName': displayName ?? _auth.currentUser?.displayName,
            'email': _auth.currentUser!.email,
            'phoneNumber': phoneNumber,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          LoggerUtil.info('User data saved successfully to Firestore');
        } catch (firestoreError) {
          LoggerUtil.error('Error saving to Firestore', firestoreError);
          // Don't throw the error here, as we've already updated the Auth profile
          // This allows the process to continue even if Firestore update fails
        }
      }
    } catch (e) {
      LoggerUtil.error('Error in updateUserProfile', e);
      if (e is FirebaseException) {
        LoggerUtil.error('Firebase Error Code: ${e.code}');
        LoggerUtil.error('Firebase Error Message: ${e.message}');
      }
      throw _handleAuthException(e);
    }
  }

  // Get user additional data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (_auth.currentUser != null) {
        LoggerUtil.info('Fetching user data for: ${_auth.currentUser!.uid}');

        final docSnapshot =
            await _firestore
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .get();

        if (docSnapshot.exists) {
          LoggerUtil.info('User data found in Firestore');
          return docSnapshot.data();
        } else {
          LoggerUtil.warning('No user data found in Firestore');
        }
      } else {
        LoggerUtil.warning('Cannot fetch user data: No authenticated user');
      }
      return null;
    } catch (e) {
      LoggerUtil.error('Error in getUserData', e);
      throw _handleAuthException(e);
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      LoggerUtil.info('Attempting to send password reset email to: $email');

      // Validate email
      if (email.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'Email cannot be empty',
        );
      }

      // Send password reset email
      await _auth.sendPasswordResetEmail(email: email);

      LoggerUtil.info('Password reset email sent successfully to: $email');
    } catch (e) {
      LoggerUtil.error('Error sending password reset email', e);
      if (e is FirebaseAuthException) {
        LoggerUtil.error('Firebase Auth Error Code: ${e.code}');
        LoggerUtil.error('Firebase Auth Error Message: ${e.message}');
      }
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(dynamic e) {
    LoggerUtil.debug('Handling auth exception: $e');

    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email. Please check your email or sign up.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-credential':
          return 'Incorrect email or password. Please try again.';
        case 'invalid-email':
          return 'The email address is invalid. Please enter a valid email.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'email-already-in-use':
          return 'This email is already registered. Please use a different email or try logging in.';
        case 'weak-password':
          return 'Password is too weak. Please use a stronger password.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection and try again.';
        case 'operation-not-allowed':
          return 'This operation is not allowed. Please contact support.';
        case 'too-many-requests':
          return 'Too many unsuccessful login attempts. Please try again later.';
        case 'account-exists-with-different-credential':
          return 'An account already exists with the same email but different sign-in credentials.';
        default:
          // For any other Firebase Auth errors, provide a generic but friendly message
          if (e.message != null &&
              e.message.toString().contains('credential')) {
            return 'Incorrect email or password. Please try again.';
          }
          return 'Authentication error. Please try again.';
      }
    } else if (e is FirebaseException) {
      return 'Firebase error: Please try again later.';
    } else if (e is Exception) {
      return 'An error occurred. Please try again.';
    }
    return 'An error occurred. Please try again.';
  }
}
