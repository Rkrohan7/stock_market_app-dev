import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoUrl;
  final bool isTwoFactorEnabled;
  final bool isBiometricEnabled;
  final double walletBalance;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isFirstLogin;

  UserModel({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
    this.isTwoFactorEnabled = false,
    this.isBiometricEnabled = false,
    this.walletBalance = 50000,
    required this.createdAt,
    this.updatedAt,
    this.isFirstLogin = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isTwoFactorEnabled: json['isTwoFactorEnabled'] as bool? ?? false,
      isBiometricEnabled: json['isBiometricEnabled'] as bool? ?? false,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 50000,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      isFirstLogin: json['isFirstLogin'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isTwoFactorEnabled': isTwoFactorEnabled,
      'isBiometricEnabled': isBiometricEnabled,
      'walletBalance': walletBalance,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isFirstLogin': isFirstLogin,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoUrl,
    bool? isTwoFactorEnabled,
    bool? isBiometricEnabled,
    double? walletBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFirstLogin,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      walletBalance: walletBalance ?? this.walletBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
    );
  }

  /// User can trade - all users can trade in this learning app
  bool get canTrade => true;
}
