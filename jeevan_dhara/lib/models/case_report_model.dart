import 'package:cloud_firestore/cloud_firestore.dart';

class CaseReportModel {
  final String id;
  final String reporterId;
  final String reporterName;
  final String district;
  final String village;
  final int numberOfCases;
  final List<String> symptoms;
  final List<String> waterConditions;
  final String? notes;
  final DateTime reportDate;
  final GeoPoint? location;
  final List<String>? imageBase64; // Store images as base64 strings
  final String status; // pending, reviewed, verified
  final String? reviewerNotes;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CaseReportModel({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.district,
    required this.village,
    required this.numberOfCases,
    required this.symptoms,
    required this.waterConditions,
    this.notes,
    required this.reportDate,
    this.location,
    this.imageBase64,
    this.status = 'pending',
    this.reviewerNotes,
    this.reviewedAt,
    this.reviewedBy,
    this.isSynced = false,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'district': district,
      'village': village,
      'numberOfCases': numberOfCases,
      'symptoms': symptoms,
      'waterConditions': waterConditions,
      'notes': notes,
      'reportDate': Timestamp.fromDate(reportDate),
      'location': location,
      'imageBase64': imageBase64,
      'status': status,
      'reviewerNotes': reviewerNotes,
      'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
      'reviewedBy': reviewedBy,
      'isSynced': isSynced,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory CaseReportModel.fromMap(Map<String, dynamic> map) {
    return CaseReportModel(
      id: map['id'] ?? '',
      reporterId: map['reporterId'] ?? '',
      reporterName: map['reporterName'] ?? '',
      district: map['district'] ?? '',
      village: map['village'] ?? '',
      numberOfCases: map['numberOfCases'] ?? 0,
      symptoms: List<String>.from(map['symptoms'] ?? []),
      waterConditions: List<String>.from(map['waterConditions'] ?? []),
      notes: map['notes'],
      reportDate: (map['reportDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: map['location'],
      imageBase64: map['imageBase64'] != null ? List<String>.from(map['imageBase64']) : null,
      status: map['status'] ?? 'pending',
      reviewerNotes: map['reviewerNotes'],
      reviewedAt: (map['reviewedAt'] as Timestamp?)?.toDate(),
      reviewedBy: map['reviewedBy'],
      isSynced: map['isSynced'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  CaseReportModel copyWith({
    String? id,
    String? reporterId,
    String? reporterName,
    String? district,
    String? village,
    int? numberOfCases,
    List<String>? symptoms,
    List<String>? waterConditions,
    String? notes,
    DateTime? reportDate,
    GeoPoint? location,
    List<String>? imageBase64,
    String? status,
    String? reviewerNotes,
    DateTime? reviewedAt,
    String? reviewedBy,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CaseReportModel(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      district: district ?? this.district,
      village: village ?? this.village,
      numberOfCases: numberOfCases ?? this.numberOfCases,
      symptoms: symptoms ?? this.symptoms,
      waterConditions: waterConditions ?? this.waterConditions,
      notes: notes ?? this.notes,
      reportDate: reportDate ?? this.reportDate,
      location: location ?? this.location,
      imageBase64: imageBase64 ?? this.imageBase64,
      status: status ?? this.status,
      reviewerNotes: reviewerNotes ?? this.reviewerNotes,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}