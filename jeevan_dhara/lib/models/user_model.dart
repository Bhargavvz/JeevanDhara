import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_constants.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? phone;
  final String? district;
  final String? village;
  final String? profileImageBase64;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final DateTime? updatedAt;
  final bool isActive;
  final bool profileCompleted;
  final Map<String, dynamic>? metadata;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
    this.district,
    this.village,
    this.profileImageBase64,
    required this.createdAt,
    this.lastLogin,
    this.updatedAt,
    this.isActive = true,
    this.profileCompleted = false,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'phone': phone,
      'district': district,
      'village': village,
      'profileImageBase64': profileImageBase64,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isActive': isActive,
      'profileCompleted': profileCompleted,
      'metadata': metadata,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == map['role'],
        orElse: () => UserRole.public,
      ),
      phone: map['phone'],
      district: map['district'],
      village: map['village'],
      profileImageBase64: map['profileImageBase64'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (map['lastLogin'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      isActive: map['isActive'] ?? true,
      profileCompleted: map['profileCompleted'] ?? false,
      metadata: map['metadata'],
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? phone,
    String? district,
    String? village,
    String? profileImageBase64,
    DateTime? createdAt,
    DateTime? lastLogin,
    DateTime? updatedAt,
    bool? isActive,
    bool? profileCompleted,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      district: district ?? this.district,
      village: village ?? this.village,
      profileImageBase64: profileImageBase64 ?? this.profileImageBase64,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      metadata: metadata ?? this.metadata,
    );
  }
}