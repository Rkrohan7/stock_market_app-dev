import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';
import '../core/enums/enums.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user by ID
  Future<UserModel?> getUserById(String odersId) async {
    final doc = await _firestore.collection('users').doc(odersId).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Update user profile
  Future<void> updateProfile({
    required String odersId,
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    final data = <String, dynamic>{
      'updatedAt': Timestamp.now(),
    };

    if (displayName != null) data['displayName'] = displayName;
    if (email != null) data['email'] = email;
    if (photoUrl != null) data['photoUrl'] = photoUrl;

    await _firestore.collection('users').doc(odersId).update(data);
  }

  // Submit KYC
  Future<void> submitKyc({
    required String odersId,
    required String panNumber,
    required String aadhaarNumber,
    String? panImageUrl,
    String? aadhaarImageUrl,
    String? selfieUrl,
  }) async {
    await _firestore.collection('users').doc(odersId).update({
      'panNumber': panNumber,
      'aadhaarNumber': aadhaarNumber,
      'panImageUrl': panImageUrl,
      'aadhaarImageUrl': aadhaarImageUrl,
      'selfieUrl': selfieUrl,
      'kycStatus': KycStatus.submitted.name,
      'kycSubmittedAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  // Get KYC status
  Future<KycStatus> getKycStatus(String odersId) async {
    final doc = await _firestore.collection('users').doc(odersId).get();
    if (doc.exists) {
      final status = doc.data()?['kycStatus'] as String?;
      if (status != null) {
        return KycStatus.values.firstWhere(
          (e) => e.name == status,
          orElse: () => KycStatus.pending,
        );
      }
    }
    return KycStatus.pending;
  }

  // Update wallet balance
  Future<void> updateWalletBalance(String odersId, double amount) async {
    await _firestore.collection('users').doc(odersId).update({
      'walletBalance': FieldValue.increment(amount),
      'updatedAt': Timestamp.now(),
    });
  }

  // Get wallet balance
  Future<double> getWalletBalance(String odersId) async {
    final doc = await _firestore.collection('users').doc(odersId).get();
    if (doc.exists) {
      return (doc.data()?['walletBalance'] as num?)?.toDouble() ?? 0;
    }
    return 0;
  }

  // Stream user data
  Stream<UserModel?> streamUser(String odersId) {
    return _firestore.collection('users').doc(odersId).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    });
  }
}
