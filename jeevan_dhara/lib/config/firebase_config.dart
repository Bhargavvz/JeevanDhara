import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDbiy0hKjlhQo5YFwV23L1w9YTgydRwduQ",
          authDomain: "jeevan-dharaa.firebaseapp.com",
          projectId: "jeevan-dharaa",
          storageBucket: "jeevan-dharaa.firebasestorage.app",
          messagingSenderId: "861335800169",
          appId: "1:861335800169:android:2774d787fb6a64945995f8",
          measurementId: "G-1KRGS0WP50"
        ),
      );

      // Configure Crashlytics
      if (!kDebugMode) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      // Configure Analytics
      await analytics.setAnalyticsCollectionEnabled(!kDebugMode);
      
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
      rethrow;
    }
  }

  // Log custom analytics events
  static Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    try {
      await analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Log user properties
  static Future<void> setUserProperty(String name, String value) async {
    try {
      await analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      debugPrint('Analytics user property error: $e');
    }
  }

  // Set user ID for analytics
  static Future<void> setUserId(String userId) async {
    try {
      await analytics.setUserId(id: userId);
    } catch (e) {
      debugPrint('Analytics user ID error: $e');
    }
  }
}