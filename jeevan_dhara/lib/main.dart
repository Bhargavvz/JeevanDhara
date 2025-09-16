import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/app_theme.dart';
import 'utils/app_routes.dart';
import 'utils/app_localization.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  Get.put(NotificationService());
  
  runApp(const JeevanDharaApp());
}

class JeevanDharaApp extends StatefulWidget {
  const JeevanDharaApp({Key? key}) : super(key: key);

  @override
  State<JeevanDharaApp> createState() => _JeevanDharaAppState();
}

class _JeevanDharaAppState extends State<JeevanDharaApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Request notification permissions
      await Get.find<NotificationService>().requestPermissions();
      
      // Add any other initialization logic here
      await Future.delayed(const Duration(milliseconds: 500)); // Minimum splash time
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('App initialization error: $e');
      // Even if initialization fails, show the app
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: AppTheme.primaryGreen,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    size: 50,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Jeevan Dhara',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Clean Water, Healthy Life',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GetMaterialApp(
      title: 'Jeevan Dhara',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [AppRouteObserver()],
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      translations: AppLocalization(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}
