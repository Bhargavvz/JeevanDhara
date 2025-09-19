import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_constants.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Observable current user
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  
  @override
  void onInit() {
    super.onInit();
    
    // Listen to auth state changes
    firebaseUser.bindStream(_auth.authStateChanges());
    
    // Listen to current user data changes
    ever(firebaseUser, _setCurrentUser);
  }
  
  // Set current user when Firebase user changes
  void _setCurrentUser(User? user) async {
    if (user != null) {
      try {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          currentUser.value = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    } else {
      currentUser.value = null;
    }
  }
  
  // Check if user is logged in
  bool get isLoggedIn => firebaseUser.value != null;
  
  // Get current user ID
  String? get currentUserId => firebaseUser.value?.uid;
  
  // Get current user role
  UserRole? get currentUserRole => currentUser.value?.role;
  
  // Sign up with email and password
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? phone,
    String? district,
    String? village,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user document in Firestore
      if (result.user != null) {
        UserModel newUser = UserModel(
          id: result.user!.uid,
          email: email,
          name: name,
          role: role,
          phone: phone,
          district: district,
          village: village,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          isActive: true,
          profileCompleted: false,
        );
        
        await _firestore.collection('users').doc(result.user!.uid).set(newUser.toMap());
        currentUser.value = newUser;
        
        // Send email verification
        await result.user!.sendEmailVerification();
      }
      
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }
  
  // Sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update last login time
      if (result.user != null) {
        await _firestore.collection('users').doc(result.user!.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
      
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      currentUser.value = null;
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }
  
  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }
  
  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? phone,
    String? district,
    String? village,
    String? profileImageBase64,
    bool? profileCompleted,
  }) async {
    try {
      if (currentUserId == null) throw Exception('User not logged in');
      
      Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (district != null) updates['district'] = district;
      if (village != null) updates['village'] = village;
      if (profileImageBase64 != null) updates['profileImageBase64'] = profileImageBase64;
      if (profileCompleted != null) updates['profileCompleted'] = profileCompleted;
      
      updates['updatedAt'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('users').doc(currentUserId).update(updates);
      
      // Update local user data
      if (currentUser.value != null) {
        currentUser.value = currentUser.value!.copyWith(
          name: name ?? currentUser.value!.name,
          phone: phone ?? currentUser.value!.phone,
          district: district ?? currentUser.value!.district,
          village: village ?? currentUser.value!.village,
          profileImageBase64: profileImageBase64 ?? currentUser.value!.profileImageBase64,
          profileCompleted: profileCompleted ?? currentUser.value!.profileCompleted,
        );
      }
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }
  
  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');
      
      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(credential);
      
      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Password change failed: $e');
    }
  }
  
  // Verify email
  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('Email verification failed: $e');
    }
  }
  
  // Check if email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;
  
  // Reload current user
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      firebaseUser.value = _auth.currentUser;
    } catch (e) {
      debugPrint('Error reloading user: $e');
    }
  }
  
  // Delete account
  Future<void> deleteAccount(String password) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');
      
      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      
      await user.reauthenticateWithCredential(credential);
      
      // Delete user document
      await _firestore.collection('users').doc(user.uid).delete();
      
      // Delete Firebase Auth account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }
  
  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'requires-recent-login':
        return 'Please log in again to perform this action.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}