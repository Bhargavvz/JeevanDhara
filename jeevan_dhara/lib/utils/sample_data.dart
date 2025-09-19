import '../models/case_report_model.dart';
import '../models/water_quality_report_model.dart';
import '../models/alert_model.dart';
import '../models/user_model.dart';
import 'app_constants.dart';

class SampleData {
  // Sample users for testing
  static List<UserModel> getSampleUsers() {
    return [
      UserModel(
        id: 'asha_user_1',
        email: 'asha1@example.com',
        name: 'Priya Sharma',
        role: UserRole.asha,
        phone: '+91-9876543210',
        district: 'Kamrup',
        village: 'Guwahati',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
        isActive: true,
        profileCompleted: true,
      ),
      UserModel(
        id: 'health_official_1',
        email: 'official1@example.com',
        name: 'Dr. Rajesh Kumar',
        role: UserRole.healthOfficial,
        phone: '+91-9876543211',
        district: 'Kamrup',
        village: 'Guwahati',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        lastLogin: DateTime.now().subtract(const Duration(minutes: 30)),
        isActive: true,
        profileCompleted: true,
      ),
      UserModel(
        id: 'public_user_1',
        email: 'public1@example.com',
        name: 'Anjali Devi',
        role: UserRole.public,
        phone: '+91-9876543212',
        district: 'Dibrugarh',
        village: 'Dibrugarh',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastLogin: DateTime.now().subtract(const Duration(hours: 1)),
        isActive: true,
        profileCompleted: true,
      ),
    ];
  }

  // Sample case reports for testing
  static List<CaseReportModel> getSampleCaseReports() {
    return [
      CaseReportModel(
        id: 'case_report_1',
        reporterId: 'asha_user_1',
        reporterName: 'Priya Sharma',
        district: 'Kamrup',
        village: 'Guwahati',
        numberOfCases: 5,
        symptoms: ['Diarrhea', 'Fever', 'Vomiting'],
        waterConditions: ['Turbid/Cloudy', 'Foul Smell'],
        notes: 'Multiple cases reported near the main water source. Immediate attention required.',
        reportDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'pending',
        isSynced: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CaseReportModel(
        id: 'case_report_2',
        reporterId: 'asha_user_1',
        reporterName: 'Priya Sharma',
        district: 'Jorhat',
        village: 'Majuli',
        numberOfCases: 3,
        symptoms: ['Diarrhea', 'Abdominal Pain', 'Dehydration'],
        waterConditions: ['Visible Contamination', 'Unusual Color'],
        notes: 'Cases observed after heavy rainfall. Water source contaminated.',
        reportDate: DateTime.now().subtract(const Duration(days: 5)),
        status: 'reviewed',
        reviewerNotes: 'Water quality testing ordered. Local authorities notified.',
        reviewedAt: DateTime.now().subtract(const Duration(days: 3)),
        reviewedBy: 'health_official_1',
        isSynced: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      CaseReportModel(
        id: 'case_report_3',
        reporterId: 'asha_user_1',
        reporterName: 'Priya Sharma',
        district: 'Dibrugarh',
        village: 'Tinsukia',
        numberOfCases: 8,
        symptoms: ['Fever', 'Vomiting', 'Nausea', 'Headache'],
        waterConditions: ['Industrial Waste', 'Chemicals/Oil'],
        notes: 'Suspected cholera outbreak. Industrial contamination likely cause.',
        reportDate: DateTime.now().subtract(const Duration(days: 10)),
        status: 'verified',
        reviewerNotes: 'Cholera confirmed. Emergency response activated.',
        reviewedAt: DateTime.now().subtract(const Duration(days: 8)),
        reviewedBy: 'health_official_1',
        isSynced: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  // Sample water quality reports for testing
  static List<WaterQualityReportModel> getSampleWaterQualityReports() {
    return [
      WaterQualityReportModel(
        id: 'water_report_1',
        reporterId: 'public_user_1',
        reporterName: 'Anjali Devi',
        reporterContact: '+91-9876543212',
        waterSourceName: 'Village Well',
        waterSourceType: 'Well',
        location: 'Village Center',
        color: 'Cloudy',
        odor: 'Slight Smell',
        taste: 'Normal',
        debris: 'Few Particles',
        description: 'Water appears cloudy after recent rains.',
        status: 'poor',
        reportDate: DateTime.now().subtract(const Duration(days: 1)),
        isSynced: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      WaterQualityReportModel(
        id: 'water_report_2',
        reporterId: 'public_user_1',
        reporterName: 'Anjali Devi',
        reporterContact: '+91-9876543212',
        waterSourceName: 'Hand Pump #1',
        waterSourceType: 'Hand Pump',
        location: 'School Area',
        color: 'Clear',
        odor: 'No Smell',
        taste: 'Normal',
        debris: 'None',
        description: 'Water quality is good. No issues observed.',
        status: 'good',
        reportDate: DateTime.now().subtract(const Duration(days: 7)),
        isSynced: true,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      WaterQualityReportModel(
        id: 'water_report_3',
        reporterId: 'asha_user_1',
        reporterName: 'Priya Sharma',
        reporterContact: '+91-9876543210',
        waterSourceName: 'River Stream',
        waterSourceType: 'River',
        location: 'East Side',
        color: 'Colored',
        odor: 'Foul Smell',
        taste: 'Chemical',
        debris: 'Heavy Contamination',
        description: 'Severe contamination observed. Industrial waste suspected.',
        status: 'critical',
        reportDate: DateTime.now().subtract(const Duration(days: 3)),
        isSynced: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  // Sample alerts for testing
  static List<AlertModel> getSampleAlerts() {
    return [
      AlertModel(
        id: 'alert_1',
        title: 'Water Contamination Alert',
        message: 'High levels of contamination detected in Guwahati water sources. Avoid consumption until further notice.',
        severity: 'high',
        type: 'water_contamination',
        affectedAreas: ['Kamrup', 'Guwahati'],
        actionRequired: 'Boil water before consumption. Use alternative water sources.',
        createdBy: 'health_official_1',
        targetRoles: ['all'],
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        isActive: true,
      ),
      AlertModel(
        id: 'alert_2',
        title: 'Disease Outbreak Warning',
        message: 'Cholera cases reported in Tinsukia region. Enhanced surveillance activated.',
        severity: 'high',
        type: 'disease_outbreak',
        affectedAreas: ['Dibrugarh', 'Tinsukia'],
        actionRequired: 'Report any symptoms immediately. Maintain hygiene protocols.',
        createdBy: 'health_official_1',
        targetRoles: ['asha', 'health_official'],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        expiresAt: DateTime.now().add(const Duration(days: 14)),
        isActive: true,
      ),
      AlertModel(
        id: 'alert_3',
        title: 'Health Survey Reminder',
        message: 'Monthly health survey due for completion. Please submit reports by end of month.',
        severity: 'medium',
        type: 'general',
        affectedAreas: ['all'],
        actionRequired: 'Complete and submit monthly health survey forms.',
        createdBy: 'health_official_1',
        targetRoles: ['asha'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        expiresAt: DateTime.now().add(const Duration(days: 5)),
        isActive: true,
      ),
      AlertModel(
        id: 'alert_4',
        title: 'Water Quality Testing Schedule',
        message: 'Routine water quality testing scheduled for all districts this week.',
        severity: 'low',
        type: 'general',
        affectedAreas: ['all'],
        actionRequired: 'Coordinate with local teams for sample collection.',
        createdBy: 'health_official_1',
        targetRoles: ['asha', 'health_official'],
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        expiresAt: DateTime.now().add(const Duration(days: 3)),
        isActive: true,
      ),
    ];
  }

  // Sample dashboard statistics
  static Map<String, dynamic> getSampleDashboardStats() {
    return {
      'totalCaseReports': 156,
      'totalWaterReports': 89,
      'activeAlerts': 4,
      'timeRange': 'month',
      'district': 'all',
      'symptomDistribution': {
        'Diarrhea': 45,
        'Fever': 38,
        'Vomiting': 32,
        'Abdominal Pain': 28,
        'Dehydration': 25,
        'Nausea': 22,
        'Headache': 18,
        'Fatigue': 15,
      },
      'waterQualityDistribution': {
        'good': 34,
        'poor': 41,
        'critical': 14,
      },
      'districtDistribution': {
        'Kamrup': 42,
        'Dibrugarh': 38,
        'Jorhat': 31,
        'Nagaon': 25,
        'Sivasagar': 20,
      },
      'weeklyTrends': [
        {'week': 'Week 1', 'cases': 12, 'waterReports': 8},
        {'week': 'Week 2', 'cases': 18, 'waterReports': 12},
        {'week': 'Week 3', 'cases': 25, 'waterReports': 15},
        {'week': 'Week 4', 'cases': 22, 'waterReports': 11},
      ],
    };
  }

  // Educational content samples
  static List<Map<String, dynamic>> getSampleEducationalContent() {
    return [
      {
        'id': 'edu_1',
        'title': 'Water Purification Methods',
        'description': 'Learn safe methods to purify water at home',
        'type': 'video',
        'duration': '5 min',
        'category': 'Water Safety',
        'content': 'Step-by-step guide on boiling, filtering, and chemical treatment of water.',
        'language': 'english',
        'difficulty': 'beginner',
      },
      {
        'id': 'edu_2',
        'title': 'Cholera Prevention',
        'description': 'Understanding and preventing cholera outbreaks',
        'type': 'article',
        'duration': '8 min read',
        'category': 'Disease Prevention',
        'content': 'Comprehensive guide on cholera symptoms, transmission, and prevention.',
        'language': 'english',
        'difficulty': 'intermediate',
      },
      {
        'id': 'edu_3',
        'title': 'Hand Hygiene Practices',
        'description': 'Proper handwashing techniques for disease prevention',
        'type': 'interactive',
        'duration': '3 min',
        'category': 'Hygiene',
        'content': 'Interactive guide demonstrating correct handwashing procedures.',
        'language': 'assamese',
        'difficulty': 'beginner',
      },
    ];
  }

  // Emergency contacts samples
  static List<Map<String, dynamic>> getSampleEmergencyContacts() {
    return [
      {
        'name': 'State Health Emergency',
        'phone': '102',
        'type': 'emergency',
        'district': 'all',
        'available': '24/7',
      },
      {
        'name': 'Guwahati Medical College',
        'phone': '+91-361-2528007',
        'type': 'hospital',
        'district': 'Kamrup',
        'available': '24/7',
      },
      {
        'name': 'Assam Medical College',
        'phone': '+91-373-2301623',
        'type': 'hospital',
        'district': 'Dibrugarh',
        'available': '24/7',
      },
      {
        'name': 'District Health Officer - Jorhat',
        'phone': '+91-376-2320456',
        'type': 'official',
        'district': 'Jorhat',
        'available': '9 AM - 6 PM',
      },
    ];
  }

  // Nearby facilities samples
  static List<Map<String, dynamic>> getSampleNearbyFacilities() {
    return [
      {
        'name': 'Primary Health Center - Guwahati',
        'type': 'health_center',
        'address': 'Zoo Road, Guwahati, Assam 781024',
        'phone': '+91-361-2345678',
        'distance': '2.5 km',
        'services': ['General Medicine', 'Emergency Care', 'Vaccination'],
        'rating': 4.2,
        'coordinates': {'lat': 26.1445, 'lng': 91.7362},
      },
      {
        'name': 'Community Water Testing Lab',
        'type': 'testing_facility',
        'address': 'GS Road, Guwahati, Assam 781005',
        'phone': '+91-361-2567890',
        'distance': '1.8 km',
        'services': ['Water Quality Testing', 'Chemical Analysis', 'Reports'],
        'rating': 4.5,
        'coordinates': {'lat': 26.1433, 'lng': 91.7898},
      },
      {
        'name': 'District Hospital - Dibrugarh',
        'type': 'hospital',
        'address': 'Hospital Road, Dibrugarh, Assam 786001',
        'phone': '+91-373-2234567',
        'distance': '5.2 km',
        'services': ['Emergency', 'Infectious Disease', 'ICU', 'Laboratory'],
        'rating': 4.0,
        'coordinates': {'lat': 27.4728, 'lng': 94.9120},
      },
    ];
  }
}