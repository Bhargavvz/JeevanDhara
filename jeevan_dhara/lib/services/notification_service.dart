import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../utils/app_theme.dart';

// Notification types
enum NotificationType {
  success,
  error,
  warning,
  info,
  health,
  emergency
}

class NotificationService extends GetxService {
  static NotificationService get to => Get.find();
  
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  // Notification count for badge
  final RxInt notificationCount = 0.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeLocalNotifications();
    await _initializeAwesomeNotifications();
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<void> _initializeAwesomeNotifications() async {
    await AwesomeNotifications().initialize(
      null, // App icon
      [
        NotificationChannel(
          channelKey: 'health_alerts',
          channelName: 'Health Alerts',
          channelDescription: 'Critical health notifications',
          defaultColor: AppTheme.errorRed,
          ledColor: AppTheme.errorRed,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
        ),
        NotificationChannel(
          channelKey: 'general_notifications',
          channelName: 'General Notifications',
          channelDescription: 'General app notifications',
          defaultColor: AppTheme.primaryGreen,
          ledColor: AppTheme.primaryGreen,
          importance: NotificationImportance.Default,
          channelShowBadge: true,
          playSound: true,
        ),
        NotificationChannel(
          channelKey: 'emergency_alerts',
          channelName: 'Emergency Alerts',
          channelDescription: 'Emergency health alerts',
          defaultColor: AppTheme.errorRed,
          ledColor: AppTheme.errorRed,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onAwesomeNotificationTapped,
      onNotificationCreatedMethod: _onNotificationCreated,
      onNotificationDisplayedMethod: _onNotificationDisplayed,
      onDismissActionReceivedMethod: _onNotificationDismissed,
    );
  }

  // Toast Notifications
  void showToast(String message, {NotificationType type = NotificationType.info}) {
    Color backgroundColor;
    Color textColor = Colors.white;
    
    switch (type) {
      case NotificationType.success:
        backgroundColor = AppTheme.successGreen;
        break;
      case NotificationType.error:
        backgroundColor = AppTheme.errorRed;
        break;
      case NotificationType.warning:
        backgroundColor = AppTheme.warningOrange;
        break;
      case NotificationType.health:
        backgroundColor = AppTheme.primaryGreen;
        break;
      case NotificationType.emergency:
        backgroundColor = AppTheme.errorRed;
        break;
      default:
        backgroundColor = AppTheme.primaryBlue;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  // Snackbar Notifications
  void showSnackbar(
    String title,
    String message, {
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    Color backgroundColor;
    Color colorText = Colors.white;
    IconData icon;
    
    switch (type) {
      case NotificationType.success:
        backgroundColor = AppTheme.successGreen;
        icon = Icons.check_circle;
        break;
      case NotificationType.error:
        backgroundColor = AppTheme.errorRed;
        icon = Icons.error;
        break;
      case NotificationType.warning:
        backgroundColor = AppTheme.warningOrange;
        icon = Icons.warning;
        break;
      case NotificationType.health:
        backgroundColor = AppTheme.primaryGreen;
        icon = Icons.medical_services;
        break;
      case NotificationType.emergency:
        backgroundColor = AppTheme.errorRed;
        icon = Icons.emergency;
        break;
      default:
        backgroundColor = AppTheme.primaryBlue;
        icon = Icons.info;
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: colorText,
      icon: Icon(icon, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      onTap: onTap != null ? (_) => onTap() : null,
    );
  }

  // Push Notifications
  Future<void> showPushNotification({
    required String title,
    required String body,
    String? payload,
    NotificationType type = NotificationType.info,
    bool scheduled = false,
    DateTime? scheduledDate,
  }) async {
    // Add to local notification list
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
    );
    
    notifications.insert(0, notification);
    notificationCount.value = notifications.where((n) => !n.isRead).length;

    String channelKey = _getChannelKey(type);
    Color notificationColor = _getNotificationColor(type);

    if (scheduled && scheduledDate != null) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch,
          channelKey: channelKey,
          title: title,
          body: body,
          payload: {'data': payload ?? ''},
          color: notificationColor,
          badge: notificationCount.value,
        ),
        schedule: NotificationCalendar.fromDate(date: scheduledDate),
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch,
          channelKey: channelKey,
          title: title,
          body: body,
          payload: {'data': payload ?? ''},
          color: notificationColor,
          badge: notificationCount.value,
        ),
      );
    }
  }

  // Health-specific notifications
  void showHealthAlert(String title, String message) {
    showPushNotification(
      title: title,
      body: message,
      type: NotificationType.health,
    );
    showSnackbar(title, message, type: NotificationType.health);
  }

  void showEmergencyAlert(String title, String message) {
    showPushNotification(
      title: title,
      body: message,
      type: NotificationType.emergency,
    );
    showSnackbar(title, message, type: NotificationType.emergency);
  }

  void showSuccess(String message) {
    showToast(message, type: NotificationType.success);
  }

  void showError(String message) {
    showToast(message, type: NotificationType.error);
  }

  void showWarning(String message) {
    showToast(message, type: NotificationType.warning);
  }

  void showInfo(String message) {
    showToast(message, type: NotificationType.info);
  }

  // Mark notification as read
  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index].isRead = true;
      notificationCount.value = notifications.where((n) => !n.isRead).length;
    }
  }

  // Clear all notifications
  void clearAllNotifications() {
    notifications.clear();
    notificationCount.value = 0;
    AwesomeNotifications().cancelAll();
  }

  // Get unread notifications
  List<NotificationModel> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  // Helper methods
  String _getChannelKey(NotificationType type) {
    switch (type) {
      case NotificationType.emergency:
      case NotificationType.health:
        return 'health_alerts';
      default:
        return 'general_notifications';
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return AppTheme.successGreen;
      case NotificationType.error:
      case NotificationType.emergency:
        return AppTheme.errorRed;
      case NotificationType.warning:
        return AppTheme.warningOrange;
      case NotificationType.health:
        return AppTheme.primaryGreen;
      default:
        return AppTheme.primaryBlue;
    }
  }

  // Callback methods
  void _onNotificationTapped(NotificationResponse response) {
    // Handle local notification tap
    debugPrint('Local notification tapped: ${response.payload}');
  }

  static Future<void> _onAwesomeNotificationTapped(ReceivedAction receivedAction) async {
    // Handle awesome notification tap
    debugPrint('Awesome notification tapped: ${receivedAction.payload}');
  }

  static Future<void> _onNotificationCreated(ReceivedNotification receivedNotification) async {
    debugPrint('Notification created: ${receivedNotification.title}');
  }

  static Future<void> _onNotificationDisplayed(ReceivedNotification receivedNotification) async {
    debugPrint('Notification displayed: ${receivedNotification.title}');
  }

  static Future<void> _onNotificationDismissed(ReceivedAction receivedAction) async {
    debugPrint('Notification dismissed: ${receivedAction.title}');
  }

  // Request notification permissions
  Future<bool> requestPermissions() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      return await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return true;
  }
}

// Notification Model
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;
  final Map<String, dynamic>? payload;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.payload,
  });

  String get timeAgo {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.health:
        return Icons.medical_services;
      case NotificationType.emergency:
        return Icons.emergency;
      default:
        return Icons.info;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.success:
        return AppTheme.successGreen;
      case NotificationType.error:
      case NotificationType.emergency:
        return AppTheme.errorRed;
      case NotificationType.warning:
        return AppTheme.warningOrange;
      case NotificationType.health:
        return AppTheme.primaryGreen;
      default:
        return AppTheme.primaryBlue;
    }
  }
}