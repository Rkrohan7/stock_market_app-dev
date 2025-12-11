import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/enums/enums.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoUrl;
  final String? panNumber;
  final String? aadhaarNumber;
  final KycStatus kycStatus;
  final bool isTwoFactorEnabled;
  final bool isBiometricEnabled;
  final double walletBalance;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
    this.panNumber,
    this.aadhaarNumber,
    this.kycStatus = KycStatus.pending,
    this.isTwoFactorEnabled = false,
    this.isBiometricEnabled = false,
    this.walletBalance = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      panNumber: json['panNumber'] as String?,
      aadhaarNumber: json['aadhaarNumber'] as String?,
      kycStatus: KycStatus.values.firstWhere(
        (e) => e.name == json['kycStatus'],
        orElse: () => KycStatus.pending,
      ),
      isTwoFactorEnabled: json['isTwoFactorEnabled'] as bool? ?? false,
      isBiometricEnabled: json['isBiometricEnabled'] as bool? ?? false,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'panNumber': panNumber,
      'aadhaarNumber': aadhaarNumber,
      'kycStatus': kycStatus.name,
      'isTwoFactorEnabled': isTwoFactorEnabled,
      'isBiometricEnabled': isBiometricEnabled,
      'walletBalance': walletBalance,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoUrl,
    String? panNumber,
    String? aadhaarNumber,
    KycStatus? kycStatus,
    bool? isTwoFactorEnabled,
    bool? isBiometricEnabled,
    double? walletBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      panNumber: panNumber ?? this.panNumber,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      kycStatus: kycStatus ?? this.kycStatus,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      walletBalance: walletBalance ?? this.walletBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isKycVerified => kycStatus == KycStatus.verified;
}
