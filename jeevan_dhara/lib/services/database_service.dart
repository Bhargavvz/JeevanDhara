import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../models/case_report_model.dart';
import '../models/water_quality_report_model.dart';
import '../models/alert_model.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

class DatabaseService extends GetxService {
  static DatabaseService get to => Get.find();
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Collections
  static const String usersCollection = 'users';
  static const String caseReportsCollection = 'case_reports';
  static const String waterQualityReportsCollection = 'water_quality_reports';
  static const String alertsCollection = 'alerts';
  static const String analyticsCollection = 'analytics';
  
  @override
  void onInit() {
    super.onInit();
    _setupFirestoreSettings();
  }
  
  void _setupFirestoreSettings() {
    // Enable offline persistence
    _db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
  
  // CASE REPORTS CRUD OPERATIONS
  
  // Create case report
  Future<String> createCaseReport(CaseReportModel report) async {
    try {
      DocumentReference docRef = await _db.collection(caseReportsCollection).add(report.toMap());
      
      // Update the document with its ID
      await docRef.update({'id': docRef.id});
      
      debugPrint('Case report created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating case report: $e');
      throw Exception('Failed to create case report: $e');
    }
  }
  
  // Get case reports with pagination
  Future<List<CaseReportModel>> getCaseReports({
    String? reporterId,
    String? district,
    String? status,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _db.collection(caseReportsCollection)
          .orderBy('createdAt', descending: true);
      
      // Apply filters
      if (reporterId != null) {
        query = query.where('reporterId', isEqualTo: reporterId);
      }
      if (district != null) {
        query = query.where('district', isEqualTo: district);
      }
      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }
      
      // Apply pagination
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      
      query = query.limit(limit);
      
      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => CaseReportModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting case reports: $e');
      throw Exception('Failed to get case reports: $e');
    }
  }
  
  // Get case report by ID
  Future<CaseReportModel?> getCaseReportById(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection(caseReportsCollection).doc(id).get();
      
      if (doc.exists) {
        return CaseReportModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting case report: $e');
      throw Exception('Failed to get case report: $e');
    }
  }
  
  // Update case report
  Future<void> updateCaseReport(String id, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _db.collection(caseReportsCollection).doc(id).update(updates);
      debugPrint('Case report updated: $id');
    } catch (e) {
      debugPrint('Error updating case report: $e');
      throw Exception('Failed to update case report: $e');
    }
  }
  
  // Delete case report
  Future<void> deleteCaseReport(String id) async {
    try {
      await _db.collection(caseReportsCollection).doc(id).delete();
      debugPrint('Case report deleted: $id');
    } catch (e) {
      debugPrint('Error deleting case report: $e');
      throw Exception('Failed to delete case report: $e');
    }
  }
  
  // WATER QUALITY REPORTS CRUD OPERATIONS
  
  // Create water quality report
  Future<String> createWaterQualityReport(WaterQualityReportModel report) async {
    try {
      DocumentReference docRef = await _db.collection(waterQualityReportsCollection).add(report.toMap());
      
      // Update the document with its ID
      await docRef.update({'id': docRef.id});
      
      debugPrint('Water quality report created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating water quality report: $e');
      throw Exception('Failed to create water quality report: $e');
    }
  }
  
  // Get water quality reports
  Future<List<WaterQualityReportModel>> getWaterQualityReports({
    String? reporterId,
    String? location,
    String? status,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _db.collection(waterQualityReportsCollection)
          .orderBy('createdAt', descending: true);
      
      // Apply filters
      if (reporterId != null) {
        query = query.where('reporterId', isEqualTo: reporterId);
      }
      if (location != null) {
        query = query.where('location', isEqualTo: location);
      }
      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }
      
      // Apply pagination
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      
      query = query.limit(limit);
      
      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => WaterQualityReportModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting water quality reports: $e');
      throw Exception('Failed to get water quality reports: $e');
    }
  }
  
  // ALERTS CRUD OPERATIONS
  
  // Create alert
  Future<String> createAlert(AlertModel alert) async {
    try {
      DocumentReference docRef = await _db.collection(alertsCollection).add(alert.toMap());
      
      // Update the document with its ID
      await docRef.update({'id': docRef.id});
      
      debugPrint('Alert created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating alert: $e');
      throw Exception('Failed to create alert: $e');
    }
  }
  
  // Get alerts for user
  Future<List<AlertModel>> getAlertsForUser({
    required String userRole,
    String? userDistrict,
    bool onlyActive = true,
    int limit = 50,
  }) async {
    try {
      Query query = _db.collection(alertsCollection)
          .orderBy('createdAt', descending: true);
      
      if (onlyActive) {
        query = query.where('isActive', isEqualTo: true);
      }
      
      query = query.limit(limit);
      
      QuerySnapshot snapshot = await query.get();
      
      List<AlertModel> allAlerts = snapshot.docs
          .map((doc) => AlertModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      
      // Filter alerts based on user role and location
      return allAlerts.where((alert) => alert.isVisibleTo(userRole, userDistrict)).toList();
    } catch (e) {
      debugPrint('Error getting alerts: $e');
      throw Exception('Failed to get alerts: $e');
    }
  }
  
  // Update alert
  Future<void> updateAlert(String id, Map<String, dynamic> updates) async {
    try {
      await _db.collection(alertsCollection).doc(id).update(updates);
      debugPrint('Alert updated: $id');
    } catch (e) {
      debugPrint('Error updating alert: $e');
      throw Exception('Failed to update alert: $e');
    }
  }
  
  // ANALYTICS AND DASHBOARD DATA
  
  // Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats({
    String? district,
    String? timeRange, // week, month, year
  }) async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate;
      
      switch (timeRange) {
        case 'week':
          startDate = now.subtract(const Duration(days: 7));
          break;
        case 'month':
          startDate = DateTime(now.year, now.month - 1, now.day);
          break;
        case 'year':
          startDate = DateTime(now.year - 1, now.month, now.day);
          break;
        default:
          startDate = DateTime(now.year, now.month, 1); // Current month
      }
      
      // Get case reports count
      Query caseQuery = _db.collection(caseReportsCollection)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      
      if (district != null) {
        caseQuery = caseQuery.where('district', isEqualTo: district);
      }
      
      // Get water quality reports count
      Query waterQuery = _db.collection(waterQualityReportsCollection)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      
      if (district != null) {
        waterQuery = waterQuery.where('location', isEqualTo: district);
      }
      
      // Get active alerts count
      Query alertsQuery = _db.collection(alertsCollection)
          .where('isActive', isEqualTo: true);
      
      if (district != null) {
        alertsQuery = alertsQuery.where('affectedAreas', arrayContains: district);
      }
      
      // Execute queries
      var caseSnapshot = await caseQuery.get();
      var waterSnapshot = await waterQuery.get();
      var alertsSnapshot = await alertsQuery.get();
      
      // Calculate statistics
      Map<String, dynamic> stats = {
        'totalCaseReports': caseSnapshot.docs.length,
        'totalWaterReports': waterSnapshot.docs.length,
        'activeAlerts': alertsSnapshot.docs.length,
        'timeRange': timeRange ?? 'month',
        'district': district ?? 'all',
      };
      
      // Calculate symptom distribution
      Map<String, int> symptomDistribution = {};
      for (var doc in caseSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        List<String> symptoms = List<String>.from(data['symptoms'] ?? []);
        for (String symptom in symptoms) {
          symptomDistribution[symptom] = (symptomDistribution[symptom] ?? 0) + 1;
        }
      }
      stats['symptomDistribution'] = symptomDistribution;
      
      // Calculate water quality distribution
      Map<String, int> waterQualityDistribution = {};
      for (var doc in waterSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String status = data['status'] ?? 'unknown';
        waterQualityDistribution[status] = (waterQualityDistribution[status] ?? 0) + 1;
      }
      stats['waterQualityDistribution'] = waterQualityDistribution;
      
      return stats;
    } catch (e) {
      debugPrint('Error getting dashboard stats: $e');
      throw Exception('Failed to get dashboard statistics: $e');
    }
  }
  
  // REAL-TIME STREAMS
  
  // Stream case reports
  Stream<List<CaseReportModel>> streamCaseReports({
    String? reporterId,
    String? district,
    int limit = 20,
  }) {
    Query query = _db.collection(caseReportsCollection)
        .orderBy('createdAt', descending: true);
    
    if (reporterId != null) {
      query = query.where('reporterId', isEqualTo: reporterId);
    }
    if (district != null) {
      query = query.where('district', isEqualTo: district);
    }
    
    query = query.limit(limit);
    
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => 
            CaseReportModel.fromMap(doc.data() as Map<String, dynamic>)
        ).toList()
    );
  }
  
  // Stream alerts
  Stream<List<AlertModel>> streamAlerts({
    required String userRole,
    String? userDistrict,
  }) {
    Query query = _db.collection(alertsCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(50);
    
    return query.snapshots().map((snapshot) {
      List<AlertModel> allAlerts = snapshot.docs
          .map((doc) => AlertModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      
      return allAlerts.where((alert) => alert.isVisibleTo(userRole, userDistrict)).toList();
    });
  }
  
  // Batch operations for offline sync
  Future<void> batchCreateCaseReports(List<CaseReportModel> reports) async {
    try {
      WriteBatch batch = _db.batch();
      
      for (CaseReportModel report in reports) {
        DocumentReference docRef = _db.collection(caseReportsCollection).doc();
        var data = report.copyWith(id: docRef.id).toMap();
        batch.set(docRef, data);
      }
      
      await batch.commit();
      debugPrint('Batch created ${reports.length} case reports');
    } catch (e) {
      debugPrint('Error in batch create: $e');
      throw Exception('Failed to batch create case reports: $e');
    }
  }
}