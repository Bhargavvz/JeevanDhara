import 'package:cloud_firestore/cloud_firestore.dart';

class AlertModel {
  final String id;
  final String title;
  final String message;
  final String severity; // high, medium, low
  final String type; // disease_outbreak, water_contamination, emergency, general
  final List<String> affectedAreas; // districts/villages
  final String? actionRequired;
  final String createdBy;
  final List<String> targetRoles; // asha, health_official, public, all
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  AlertModel({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.type,
    required this.affectedAreas,
    this.actionRequired,
    required this.createdBy,
    required this.targetRoles,
    required this.createdAt,
    this.expiresAt,
    this.isActive = true,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'severity': severity,
      'type': type,
      'affectedAreas': affectedAreas,
      'actionRequired': actionRequired,
      'createdBy': createdBy,
      'targetRoles': targetRoles,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      severity: map['severity'] ?? 'low',
      type: map['type'] ?? 'general',
      affectedAreas: List<String>.from(map['affectedAreas'] ?? []),
      actionRequired: map['actionRequired'],
      createdBy: map['createdBy'] ?? '',
      targetRoles: List<String>.from(map['targetRoles'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (map['expiresAt'] as Timestamp?)?.toDate(),
      isActive: map['isActive'] ?? true,
      metadata: map['metadata'],
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool isVisibleTo(String userRole, String? userDistrict) {
    // Check if alert is still active and not expired
    if (!isActive || isExpired) return false;
    
    // Check if user role is in target roles
    if (!targetRoles.contains('all') && !targetRoles.contains(userRole)) {
      return false;
    }
    
    // Check if user's area is affected (if user district is provided)
    if (userDistrict != null && affectedAreas.isNotEmpty) {
      return affectedAreas.contains(userDistrict) || affectedAreas.contains('all');
    }
    
    return true;
  }

  AlertModel copyWith({
    String? id,
    String? title,
    String? message,
    String? severity,
    String? type,
    List<String>? affectedAreas,
    String? actionRequired,
    String? createdBy,
    List<String>? targetRoles,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return AlertModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      type: type ?? this.type,
      affectedAreas: affectedAreas ?? this.affectedAreas,
      actionRequired: actionRequired ?? this.actionRequired,
      createdBy: createdBy ?? this.createdBy,
      targetRoles: targetRoles ?? this.targetRoles,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }
}