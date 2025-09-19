import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import existing screens only
import '../screens/splash_screen.dart';
import '../screens/role_selection_screen.dart';

// ASHA screens
import '../screens/asha/asha_login_screen.dart';
import '../screens/asha/asha_dashboard_screen.dart';
import '../screens/asha/case_reporting_screen.dart';
import '../screens/asha/my_reports_screen.dart';
import '../screens/asha/asha_training_materials_screen.dart';

// Health Officials screens
import '../screens/health_officials/official_login_screen.dart';
import '../screens/health_officials/official_dashboard_screen.dart';
import '../screens/health_officials/data_visualization_screen.dart';
import '../screens/health_officials/alerts_notifications_screen.dart';
import '../screens/health_officials/outbreak_prediction_screen.dart';

// Public screens
import '../screens/public/public_login_screen.dart';
import '../screens/public/public_signup_screen.dart';
import '../screens/public/public_home_screen.dart';
import '../screens/public/symptom_checker_screen.dart';
import '../screens/public/nearby_facilities_screen.dart';
import '../screens/public/emergency_contacts_screen.dart';
import '../screens/public/awareness_campaigns_screen.dart';
import '../screens/public/educational_modules_screen.dart';
import '../screens/public/community_forums_screen.dart';
import '../screens/public/water_quality_reporting_screen.dart';
import '../screens/public/health_self_assessment_screen.dart';
import '../screens/public/iot_sensor_monitoring_screen.dart';

// Common screens
import '../screens/common/profile_management_screen.dart';
import '../screens/common/settings_screen.dart';
import '../screens/common/help_support_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  
  // ASHA routes
  static const String ashaLogin = '/asha/login';
  static const String ashaDashboard = '/asha/dashboard';
  static const String caseReporting = '/asha/case-reporting';
  static const String myReports = '/asha/my-reports';
  static const String ashaTrainingMaterials = '/asha/training-materials';
  
  // Health Officials routes
  static const String officialLogin = '/official/login';
  static const String officialDashboard = '/official/dashboard';
  static const String dataVisualization = '/official/data-visualization';
  static const String alertsNotifications = '/official/alerts-notifications';
  static const String outbreakPrediction = '/official/outbreak-prediction';
  
  // Public routes
  static const String publicLogin = '/public/login';
  static const String publicSignup = '/public/signup';
  static const String publicHome = '/public/home';
  static const String symptomChecker = '/public/symptom-checker';
  static const String nearbyFacilities = '/public/nearby-facilities';
  static const String emergencyContacts = '/public/emergency-contacts';
  static const String awarenessCampaigns = '/public/awareness-campaigns';
  static const String educationalModules = '/public/educational-modules';
  static const String communityForums = '/public/community-forums';
  static const String waterQualityReporting = '/public/water-quality-reporting';
  static const String healthSelfAssessment = '/public/health-self-assessment';
  static const String iotSensorMonitoring = '/public/iot-sensor-monitoring';
  
  // Common routes
  static const String profileManagement = '/common/profile-management';
  static const String settings = '/common/settings';
  static const String helpSupport = '/common/help-support';

  // Route definitions
  static List<GetPage> routes = [
    // Initial routes
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: roleSelection,
      page: () => const RoleSelectionScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // ASHA routes
    GetPage(
      name: ashaLogin,
      page: () => const ASHALoginScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: ashaDashboard,
      page: () => const ASHADashboardScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: caseReporting,
      page: () => const CaseReportingScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: myReports,
      page: () => const MyReportsScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: ashaTrainingMaterials,
      page: () => const ASHATrainingMaterialsScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    
    // Health Officials routes
    GetPage(
      name: officialLogin,
      page: () => const OfficialLoginScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: officialDashboard,
      page: () => const OfficialDashboardScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: dataVisualization,
      page: () => const DataVisualizationScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: alertsNotifications,
      page: () => const AlertsNotificationsScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: outbreakPrediction,
      page: () => const OutbreakPredictionScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    
    // Public routes
    GetPage(
      name: publicLogin,
      page: () => const PublicLoginScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: publicSignup,
      page: () => const PublicSignupScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: publicHome,
      page: () => const PublicHomeScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: symptomChecker,
      page: () => const SymptomCheckerScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: nearbyFacilities,
      page: () => const NearbyFacilitiesScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: emergencyContacts,
      page: () => const EmergencyContactsScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: awarenessCampaigns,
      page: () => const AwarenessCampaignsScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: educationalModules,
      page: () => const EducationalModulesScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: communityForums,
      page: () => const CommunityForumsScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: waterQualityReporting,
      page: () => const WaterQualityReportingScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: healthSelfAssessment,
      page: () => const HealthSelfAssessmentScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: iotSensorMonitoring,
      page: () => const IoTSensorMonitoringScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    
    // Common routes
    GetPage(
      name: profileManagement,
      page: () => const ProfileManagementScreen(),
      transition: Transition.upToDown,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: helpSupport,
      page: () => const HelpSupportScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];

  // Navigation helper methods
  static void toRoleSelection() => Get.offNamed(roleSelection);
  
  // ASHA navigation
  static void toAshaLogin() => Get.toNamed(ashaLogin);
  static void toAshaDashboard() => Get.offNamed(ashaDashboard);
  static void toCaseReporting() => Get.toNamed(caseReporting);
  static void toMyReports() => Get.toNamed(myReports);
  static void toASHATrainingMaterials() => Get.toNamed(ashaTrainingMaterials);
  
  // Health Officials navigation
  static void toOfficialLogin() => Get.toNamed(officialLogin);
  static void toOfficialDashboard() => Get.offNamed(officialDashboard);
  static void toDataVisualization() => Get.toNamed(dataVisualization);
  static void toAlertsNotifications() => Get.toNamed(alertsNotifications);
  static void toOutbreakPrediction() => Get.toNamed(outbreakPrediction);
  
  // Public navigation
  static void toPublicLogin() => Get.toNamed(publicLogin);
  static void toPublicSignup() => Get.toNamed(publicSignup);
  static void toPublicHome() => Get.offNamed(publicHome);
  static void toSymptomChecker() => Get.toNamed(symptomChecker);
  static void toNearbyFacilities() => Get.toNamed(nearbyFacilities);
  static void toEmergencyContacts() => Get.toNamed(emergencyContacts);
  static void toAwarenessCampaigns() => Get.toNamed(awarenessCampaigns);
  static void toEducationalModules() => Get.toNamed(educationalModules);
  static void toCommunityForums() => Get.toNamed(communityForums);
  static void toWaterQualityReporting() => Get.toNamed(waterQualityReporting);
  static void toHealthSelfAssessment() => Get.toNamed(healthSelfAssessment);
  static void toIoTSensorMonitoring() => Get.toNamed(iotSensorMonitoring);
  
  // Common navigation
  static void toProfileManagement() => Get.toNamed(profileManagement);
  static void toSettings() => Get.toNamed(settings);
  static void toHelpSupport() => Get.toNamed(helpSupport);

  // Back navigation
  static void back() => Get.back();
  
  // Navigate with custom transition
  static void navigateWithTransition(
    String routeName, {
    Transition? transition,
    Duration? duration,
    dynamic arguments,
  }) {
    Get.toNamed(
      routeName,
      arguments: arguments,
    );
  }

  // Navigate and clear stack
  static void navigateAndClear(String routeName) {
    Get.offAllNamed(routeName);
  }

  // Replace current route
  static void replaceWith(String routeName) {
    Get.offNamed(routeName);
  }
}

// Route observer for tracking navigation
class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    debugPrint('Route pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    debugPrint('Route popped: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint('Route replaced: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    debugPrint('Route removed: ${route.settings.name}');
  }
}