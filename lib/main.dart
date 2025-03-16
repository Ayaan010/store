import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth_check.dart';
import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kDebugMode;
import 'utils/logger_util.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  bool firebaseInitialized = false;

  // Platform-specific Firebase initialization with error handling
  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDCu_xwxG4_grimF6C5UX0E4QcJrizuLnQ',
          appId: '1:563465632369:android:bf99bf9472ae89b9ee39d0',
          messagingSenderId: '563465632369',
          projectId: 'campuscart-473e1',
          storageBucket: 'campuscart-473e1.firebasestorage.app',
        ),
      );
      firebaseInitialized = true;
      LoggerUtil.info('Firebase initialized successfully for Android');
    } else {
      await Firebase.initializeApp();
      firebaseInitialized = true;
      LoggerUtil.info('Firebase initialized successfully for other platform');
    }
  } catch (e) {
    LoggerUtil.error('Error initializing Firebase', e);
    if (e is FirebaseException) {
      LoggerUtil.error('Firebase Error Code: ${e.code}');
      LoggerUtil.error('Firebase Error Message: ${e.message}');
    }
    // Continue with the app even if Firebase fails to initialize
  }

  if (!firebaseInitialized) {
    LoggerUtil.warning(
      'WARNING: Firebase was not initialized. Authentication features will not work.',
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Cart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF004D40),
          primary: const Color(0xFF004D40),
        ),
        useMaterial3: true,
      ),
      home: const AuthCheck(),
    );
  }
}
