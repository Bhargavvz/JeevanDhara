import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../services/notification_service.dart';
import '../services/auth_service.dart';

class FirebaseMessagingService extends GetxService {
  static FirebaseMessagingService get to => Get.find();
  
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeMessaging();
  }
  
  Future<void> _initializeMessaging() async {
    try {
      // Request permission for notifications
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      debugPrint('Notification permission: ${settings.authorizationStatus}');
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get FCM token
        String? token = await _messaging.getToken();
        debugPrint('FCM Token: $token');
        
        // Update user's FCM token in Firestore
        if (token != null) {
          await _updateUserFCMToken(token);
        }
        
        // Listen for token refresh
        _messaging.onTokenRefresh.listen(_updateUserFCMToken);
        
        // Configure message handlers
        _configureMessageHandlers();
      }
    } catch (e) {
      debugPrint('Error initializing Firebase Messaging: $e');
    }
  }
  
  void _configureMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle messages when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    
    // Handle messages when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleBackgroundMessage(message);
      }
    });
  }
  
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Received foreground message: ${message.messageId}');
    
    // Show in-app notification
    NotificationService.to.showPushNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
    
    // Process message data
    _processMessageData(message.data);
  }
  
  void _handleBackgroundMessage(RemoteMessage message) {
    debugPrint('Received background message: ${message.messageId}');
    
    // Process message data and navigate accordingly
    _processMessageData(message.data);
  }
  
  void _processMessageData(Map<String, dynamic> data) {
    try {
      String? type = data['type'];
      
      switch (type) {
        case 'alert':
          _handleAlert(data);
          break;
        case 'case_report_update':
          _handleCaseReportUpdate(data);
          break;
        case 'water_quality_alert':
          _handleWaterQualityAlert(data);
          break;
        case 'system_notification':
          _handleSystemNotification(data);
          break;
        default:
          debugPrint('Unknown message type: $type');
      }
    } catch (e) {
      debugPrint('Error processing message data: $e');
    }
  }
  
  void _handleAlert(Map<String, dynamic> data) {
    String? severity = data['severity'];
    String? alertId = data['alertId'];
    
    // Show appropriate notification based on severity
    if (severity == 'high') {
      NotificationService.to.showEmergencyAlert(
        data['title'] ?? 'Emergency Alert',
        data['message'] ?? '',
      );
    } else {
      NotificationService.to.showHealthAlert(
        data['title'] ?? 'Health Alert',
        data['message'] ?? '',
      );
    }
    
    // Navigate to alerts screen if alertId is provided
    if (alertId != null) {
      // You can add navigation logic here
      debugPrint('Navigate to alert: $alertId');
    }
  }
  
  void _handleCaseReportUpdate(Map<String, dynamic> data) {
    String? reportId = data['reportId'];
    String? status = data['status'];
    
    NotificationService.to.showInfo(
      'Case report ${status ?? 'updated'}: $reportId',
    );
    
    // Navigate to specific report if needed
    if (reportId != null) {
      debugPrint('Navigate to case report: $reportId');
    }
  }
  
  void _handleWaterQualityAlert(Map<String, dynamic> data) {
    String? location = data['location'];
    String? status = data['status'];
    
    if (status == 'critical') {
      NotificationService.to.showEmergencyAlert(
        'Critical Water Quality Alert',
        'Water quality is critical at $location. Avoid consumption.',
      );
    } else {
      NotificationService.to.showWarning(
        'Water quality alert for $location',
      );
    }
  }
  
  void _handleSystemNotification(Map<String, dynamic> data) {
    NotificationService.to.showInfo(
      data['message'] ?? 'System notification',
    );
  }
  
  Future<void> _updateUserFCMToken(String token) async {
    try {
      final authService = Get.find<AuthService>();
      if (authService.currentUserId != null) {
        await authService.updateUserProfile(
          // You'll need to add fcmToken field to UserModel
          // fcmToken: token,
        );
        debugPrint('FCM token updated for user: ${authService.currentUserId}');
      }
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }
  
  // Subscribe to topic based on user role and location
  Future<void> subscribeToTopics() async {
    try {
      final authService = Get.find<AuthService>();
      final user = authService.currentUser.value;
      
      if (user != null) {
        // Subscribe to role-based topic
        await _messaging.subscribeToTopic('role_${user.role.toString().split('.').last}');
        
        // Subscribe to district-based topic if available
        if (user.district != null) {
          await _messaging.subscribeToTopic('district_${user.district!.toLowerCase().replaceAll(' ', '_')}');
        }
        
        // Subscribe to general topics
        await _messaging.subscribeToTopic('general_alerts');
        
        debugPrint('Subscribed to FCM topics');
      }
    } catch (e) {
      debugPrint('Error subscribing to topics: $e');
    }
  }
  
  // Unsubscribe from topics
  Future<void> unsubscribeFromTopics() async {
    try {
      final authService = Get.find<AuthService>();
      final user = authService.currentUser.value;
      
      if (user != null) {
        // Unsubscribe from role-based topic
        await _messaging.unsubscribeFromTopic('role_${user.role.toString().split('.').last}');
        
        // Unsubscribe from district-based topic if available
        if (user.district != null) {
          await _messaging.unsubscribeFromTopic('district_${user.district!.toLowerCase().replaceAll(' ', '_')}');
        }
        
        // Unsubscribe from general topics
        await _messaging.unsubscribeFromTopic('general_alerts');
        
        debugPrint('Unsubscribed from FCM topics');
      }
    } catch (e) {
      debugPrint('Error unsubscribing from topics: $e');
    }
  }
  
  // Get current FCM token
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }
  
  // Send test notification (for development)
  Future<void> sendTestNotification() async {
    try {
      NotificationService.to.showPushNotification(
        title: 'Test Notification',
        body: 'This is a test notification from Firebase Messaging',
        type: NotificationType.info,
      );
    } catch (e) {
      debugPrint('Error sending test notification: $e');
    }
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
  
  // You can process the message here but avoid heavy operations
  // Most processing should be done when the app is in foreground
}