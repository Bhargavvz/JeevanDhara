import 'package:cloud_firestore/cloud_firestore.dart';

class WaterQualityReportModel {
  final String id;
  final String reporterId;
  final String reporterName;
  final String? reporterContact;
  final String waterSourceName;
  final String waterSourceType;
  final String location;
  final GeoPoint? coordinates;
  final String color;
  final String odor;
  final String taste;
  final String debris;
  final String? description;
  final List<String>? imageBase64; // Store images as base64 strings
  final String status; // good, poor, critical
  final DateTime reportDate;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime? updatedAt;

  WaterQualityReportModel({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    this.reporterContact,
    required this.waterSourceName,
    required this.waterSourceType,
    required this.location,
    this.coordinates,
    required this.color,
    required this.odor,
    required this.taste,
    required this.debris,
    this.description,
    this.imageBase64,
    required this.status,
    required this.reportDate,
    this.isSynced = false,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'reporterContact': reporterContact,
      'waterSourceName': waterSourceName,
      'waterSourceType': waterSourceType,
      'location': location,
      'coordinates': coordinates,
      'color': color,
      'odor': odor,
      'taste': taste,
      'debris': debris,
      'description': description,
      'imageBase64': imageBase64,
      'status': status,
      'reportDate': Timestamp.fromDate(reportDate),
      'isSynced': isSynced,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory WaterQualityReportModel.fromMap(Map<String, dynamic> map) {
    return WaterQualityReportModel(
      id: map['id'] ?? '',
      reporterId: map['reporterId'] ?? '',
      reporterName: map['reporterName'] ?? '',
      reporterContact: map['reporterContact'],
      waterSourceName: map['waterSourceName'] ?? '',
      waterSourceType: map['waterSourceType'] ?? '',
      location: map['location'] ?? '',
      coordinates: map['coordinates'],
      color: map['color'] ?? '',
      odor: map['odor'] ?? '',
      taste: map['taste'] ?? '',
      debris: map['debris'] ?? '',
      description: map['description'],
      imageBase64: map['imageBase64'] != null ? List<String>.from(map['imageBase64']) : null,
      status: map['status'] ?? 'good',
      reportDate: (map['reportDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isSynced: map['isSynced'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  String get qualityAssessment {
    int score = 0;
    
    // Score based on color
    if (color == 'Clear') score += 25;
    else if (color == 'Slightly Cloudy') score += 15;
    else if (color == 'Cloudy') score += 5;
    
    // Score based on odor
    if (odor == 'No Smell') score += 25;
    else if (odor == 'Slight Smell') score += 15;
    else if (odor == 'Strong Smell') score += 5;
    
    // Score based on taste
    if (taste == 'Normal') score += 25;
    else if (taste == 'Slightly Salty') score += 15;
    else if (taste == 'Metallic') score += 10;
    else if (taste == 'Bitter') score += 5;
    
    // Score based on debris
    if (debris == 'None') score += 25;
    else if (debris == 'Few Particles') score += 15;
    else if (debris == 'Many Particles') score += 5;
    
    if (score >= 80) return 'good';
    else if (score >= 50) return 'poor';
    else return 'critical';
  }

  WaterQualityReportModel copyWith({
    String? id,
    String? reporterId,
    String? reporterName,
    String? reporterContact,
    String? waterSourceName,
    String? waterSourceType,
    String? location,
    GeoPoint? coordinates,
    String? color,
    String? odor,
    String? taste,
    String? debris,
    String? description,
    List<String>? imageBase64,
    String? status,
    DateTime? reportDate,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WaterQualityReportModel(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      reporterContact: reporterContact ?? this.reporterContact,
      waterSourceName: waterSourceName ?? this.waterSourceName,
      waterSourceType: waterSourceType ?? this.waterSourceType,
      location: location ?? this.location,
      coordinates: coordinates ?? this.coordinates,
      color: color ?? this.color,
      odor: odor ?? this.odor,
      taste: taste ?? this.taste,
      debris: debris ?? this.debris,
      description: description ?? this.description,
      imageBase64: imageBase64 ?? this.imageBase64,
      status: status ?? this.status,
      reportDate: reportDate ?? this.reportDate,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}