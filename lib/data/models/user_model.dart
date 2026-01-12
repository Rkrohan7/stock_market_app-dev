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
  final String? selfieUrl;
  final KycStatus kycStatus;
  final String? rejectionReason;
  final DateTime? kycSubmittedAt;
  final bool isTwoFactorEnabled;
  final bool isBiometricEnabled;
  final double walletBalance;
  final bool isAdmin;
  final bool isAdminVerified;
  final String? adminVerifiedBy;
  final DateTime? adminVerifiedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isFirstLogin;

  UserModel({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
    this.panNumber,
    this.aadhaarNumber,
    this.selfieUrl,
    this.kycStatus = KycStatus.pending,
    this.rejectionReason,
    this.kycSubmittedAt,
    this.isTwoFactorEnabled = false,
    this.isBiometricEnabled = false,
    this.walletBalance = 0,
    this.isAdmin = false,
    this.isAdminVerified = false,
    this.adminVerifiedBy,
    this.adminVerifiedAt,
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
      panNumber: json['panNumber'] as String?,
      aadhaarNumber: json['aadhaarNumber'] as String?,
      selfieUrl: json['selfieUrl'] as String?,
      kycStatus: KycStatus.values.firstWhere(
        (e) => e.name == json['kycStatus'],
        orElse: () => KycStatus.pending,
      ),
      rejectionReason: json['rejectionReason'] as String?,
      kycSubmittedAt: json['kycSubmittedAt'] != null
          ? (json['kycSubmittedAt'] as Timestamp).toDate()
          : null,
      isTwoFactorEnabled: json['isTwoFactorEnabled'] as bool? ?? false,
      isBiometricEnabled: json['isBiometricEnabled'] as bool? ?? false,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0,
      isAdmin: json['isAdmin'] as bool? ?? false,
      isAdminVerified: json['isAdminVerified'] as bool? ?? false,
      adminVerifiedBy: json['adminVerifiedBy'] as String?,
      adminVerifiedAt: json['adminVerifiedAt'] != null
          ? (json['adminVerifiedAt'] as Timestamp).toDate()
          : null,
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
      'panNumber': panNumber,
      'aadhaarNumber': aadhaarNumber,
      'selfieUrl': selfieUrl,
      'kycStatus': kycStatus.name,
      'rejectionReason': rejectionReason,
      'kycSubmittedAt': kycSubmittedAt != null ? Timestamp.fromDate(kycSubmittedAt!) : null,
      'isTwoFactorEnabled': isTwoFactorEnabled,
      'isBiometricEnabled': isBiometricEnabled,
      'walletBalance': walletBalance,
      'isAdmin': isAdmin,
      'isAdminVerified': isAdminVerified,
      'adminVerifiedBy': adminVerifiedBy,
      'adminVerifiedAt': adminVerifiedAt != null ? Timestamp.fromDate(adminVerifiedAt!) : null,
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
    String? panNumber,
    String? aadhaarNumber,
    String? selfieUrl,
    KycStatus? kycStatus,
    String? rejectionReason,
    DateTime? kycSubmittedAt,
    bool? isTwoFactorEnabled,
    bool? isBiometricEnabled,
    double? walletBalance,
    bool? isAdmin,
    bool? isAdminVerified,
    String? adminVerifiedBy,
    DateTime? adminVerifiedAt,
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
      panNumber: panNumber ?? this.panNumber,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      selfieUrl: selfieUrl ?? this.selfieUrl,
      kycStatus: kycStatus ?? this.kycStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      kycSubmittedAt: kycSubmittedAt ?? this.kycSubmittedAt,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      walletBalance: walletBalance ?? this.walletBalance,
      isAdmin: isAdmin ?? this.isAdmin,
      isAdminVerified: isAdminVerified ?? this.isAdminVerified,
      adminVerifiedBy: adminVerifiedBy ?? this.adminVerifiedBy,
      adminVerifiedAt: adminVerifiedAt ?? this.adminVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
    );
  }

  bool get isKycVerified => kycStatus == KycStatus.verified;

  /// User can trade only if KYC is verified by admin
  bool get canTrade => kycStatus == KycStatus.verified && isAdminVerified;

  /// Check if KYC is pending review (submitted but not yet verified/rejected)
  bool get isKycPending => kycStatus == KycStatus.submitted && !isAdminVerified;

  /// Check if KYC was rejected
  bool get isKycRejected => kycStatus == KycStatus.rejected;

  /// Check if user needs to complete KYC
  bool get needsKyc => kycStatus == KycStatus.pending || kycStatus == KycStatus.rejected;
}
