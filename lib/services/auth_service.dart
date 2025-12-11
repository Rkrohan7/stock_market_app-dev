import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  String? get userId => currentUser?.uid;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Create user in Firestore if new
      if (userCredential.user != null) {
        await createUserInFirestore(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Create or update user in Firestore
  Future<void> createUserInFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      final newUser = UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
      await userDoc.set(newUser.toJson());
    } else {
      // Update existing user with latest info
      await userDoc.update({
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'updatedAt': Timestamp.now(),
      });
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData() async {
    if (currentUser == null) return null;

    final doc = await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    if (currentUser == null) return;
    await _firestore.collection('users').doc(currentUser!.uid).update({
      ...data,
      'updatedAt': Timestamp.now(),
    });
  }

  // Enable/Disable Two Factor Authentication
  Future<void> toggleTwoFactor(bool enabled) async {
    await updateUserProfile({'isTwoFactorEnabled': enabled});
  }

  // Enable/Disable Biometric Authentication
  Future<void> toggleBiometric(bool enabled) async {
    await updateUserProfile({'isBiometricEnabled': enabled});
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Delete account
  Future<void> deleteAccount() async {
    if (currentUser == null) return;
    await _firestore.collection('users').doc(currentUser!.uid).delete();
    await _googleSignIn.signOut();
    await currentUser!.delete();
  }
}
