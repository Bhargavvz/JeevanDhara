import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/case_report_model.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../utils/app_constants.dart';

class CaseReportController extends GetxController {
  static CaseReportController get to => Get.find();
  
  final DatabaseService _databaseService = DatabaseService.to;
  final AuthService _authService = AuthService.to;
  final NotificationService _notificationService = NotificationService.to;
  
  // Observable lists
  final RxList<CaseReportModel> caseReports = <CaseReportModel>[].obs;
  final RxList<CaseReportModel> myCaseReports = <CaseReportModel>[].obs;
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isLoadingMore = false.obs;
  
  // Error handling
  final RxString error = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadCaseReports();
    if (_authService.currentUserRole == UserRole.asha) {
      loadMyCaseReports();
    }
  }
  
  // Create new case report
  Future<bool> createCaseReport({
    required String district,
    required String village,
    required int numberOfCases,
    required List<String> symptoms,
    required List<String> waterConditions,
    String? notes,
    required DateTime reportDate,
    double? latitude,
    double? longitude,
  }) async {
    try {
      isSubmitting.value = true;
      error.value = '';
      
      final user = _authService.currentUser.value;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      
      final report = CaseReportModel(
        id: '', // Will be set by Firestore
        reporterId: user.id,
        reporterName: user.name,
        district: district,
        village: village,
        numberOfCases: numberOfCases,
        symptoms: symptoms,
        waterConditions: waterConditions,
        notes: notes,
        reportDate: reportDate,
        location: latitude != null && longitude != null 
            ? GeoPoint(latitude, longitude) 
            : null,
        createdAt: DateTime.now(),
      );
      
      String reportId = await _databaseService.createCaseReport(report);
      
      // Add to local list
      final createdReport = report.copyWith(id: reportId);
      caseReports.insert(0, createdReport);
      myCaseReports.insert(0, createdReport);
      
      _notificationService.showSuccess('Case report submitted successfully');
      
      return true;
    } catch (e) {
      error.value = e.toString();
      _notificationService.showError('Failed to submit case report: $e');
      debugPrint('Error creating case report: $e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
  
  // Load all case reports (for health officials)
  Future<void> loadCaseReports({
    String? district,
    String? status,
    bool refresh = false,
  }) async {
    try {
      if (refresh) {
        caseReports.clear();
      }
      
      isLoading.value = true;
      error.value = '';
      
      List<CaseReportModel> reports = await _databaseService.getCaseReports(
        district: district,
        status: status,
        limit: 20,
      );
      
      if (refresh) {
        caseReports.assignAll(reports);
      } else {
        caseReports.addAll(reports);
      }
    } catch (e) {
      error.value = e.toString();
      _notificationService.showError('Failed to load case reports: $e');
      debugPrint('Error loading case reports: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Load user's own case reports (for ASHA workers)
  Future<void> loadMyCaseReports({bool refresh = false}) async {
    try {
      if (refresh) {
        myCaseReports.clear();
      }
      
      isLoading.value = true;
      error.value = '';
      
      final userId = _authService.currentUserId;
      if (userId == null) return;
      
      List<CaseReportModel> reports = await _databaseService.getCaseReports(
        reporterId: userId,
        limit: 20,
      );
      
      if (refresh) {
        myCaseReports.assignAll(reports);
      } else {
        myCaseReports.addAll(reports);
      }
    } catch (e) {
      error.value = e.toString();
      _notificationService.showError('Failed to load your reports: $e');
      debugPrint('Error loading my case reports: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Update case report (for health officials)
  Future<bool> updateCaseReport(String reportId, Map<String, dynamic> updates) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _databaseService.updateCaseReport(reportId, updates);
      
      // Update local lists
      int index = caseReports.indexWhere((report) => report.id == reportId);
      if (index != -1) {
        caseReports[index] = caseReports[index].copyWith(
          status: updates['status'],
          reviewerNotes: updates['reviewerNotes'],
          reviewedAt: updates['reviewedAt'],
          reviewedBy: updates['reviewedBy'],
        );
      }
      
      _notificationService.showSuccess('Case report updated successfully');
      return true;
    } catch (e) {
      error.value = e.toString();
      _notificationService.showError('Failed to update case report: $e');
      debugPrint('Error updating case report: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Review case report (for health officials)
  Future<bool> reviewCaseReport({
    required String reportId,
    required String status, // reviewed, verified
    String? reviewerNotes,
  }) async {
    try {
      final user = _authService.currentUser.value;
      if (user == null || user.role != UserRole.healthOfficial) {
        throw Exception('Only health officials can review reports');
      }
      
      Map<String, dynamic> updates = {
        'status': status,
        'reviewedAt': DateTime.now(),
        'reviewedBy': user.id,
        'reviewerNotes': reviewerNotes,
      };
      
      return await updateCaseReport(reportId, updates);
    } catch (e) {
      error.value = e.toString();
      _notificationService.showError('Failed to review case report: $e');
      debugPrint('Error reviewing case report: $e');
      return false;
    }
  }
  
  // Delete case report (for health officials)
  Future<bool> deleteCaseReport(String reportId) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _databaseService.deleteCaseReport(reportId);
      
      // Remove from local lists
      caseReports.removeWhere((report) => report.id == reportId);
      myCaseReports.removeWhere((report) => report.id == reportId);
      
      _notificationService.showSuccess('Case report deleted successfully');
      return true;
    } catch (e) {
      error.value = e.toString();
      _notificationService.showError('Failed to delete case report: $e');
      debugPrint('Error deleting case report: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Search case reports
  void searchCaseReports(String query) {
    if (query.isEmpty) {
      loadCaseReports(refresh: true);
      return;
    }
    
    List<CaseReportModel> filteredReports = caseReports.where((report) {
      return report.district.toLowerCase().contains(query.toLowerCase()) ||
             report.village.toLowerCase().contains(query.toLowerCase()) ||
             report.reporterName.toLowerCase().contains(query.toLowerCase()) ||
             report.symptoms.any((symptom) => 
                 symptom.toLowerCase().contains(query.toLowerCase()));
    }).toList();
    
    caseReports.assignAll(filteredReports);
  }
  
  // Filter case reports by status
  void filterByStatus(String? status) {
    loadCaseReports(status: status, refresh: true);
  }
  
  // Filter case reports by district
  void filterByDistrict(String? district) {
    loadCaseReports(district: district, refresh: true);
  }
  
  // Get case report statistics
  Map<String, dynamic> getStatistics() {
    Map<String, int> statusCount = {};
    Map<String, int> districtCount = {};
    Map<String, int> symptomCount = {};
    
    for (var report in caseReports) {
      // Count by status
      statusCount[report.status] = (statusCount[report.status] ?? 0) + 1;
      
      // Count by district
      districtCount[report.district] = (districtCount[report.district] ?? 0) + 1;
      
      // Count symptoms
      for (var symptom in report.symptoms) {
        symptomCount[symptom] = (symptomCount[symptom] ?? 0) + 1;
      }
    }
    
    return {
      'totalReports': caseReports.length,
      'statusDistribution': statusCount,
      'districtDistribution': districtCount,
      'symptomDistribution': symptomCount,
    };
  }
  
  // Refresh data
  Future<void> refresh() async {
    await Future.wait([
      loadCaseReports(refresh: true),
      if (_authService.currentUserRole == UserRole.asha) loadMyCaseReports(refresh: true),
    ]);
  }
  
  // Clear data
  void clearData() {
    caseReports.clear();
    myCaseReports.clear();
    error.value = '';
  }
}