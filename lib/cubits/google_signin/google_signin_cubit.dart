// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'google_signin_state.dart';

class GoogleSigninCubit extends Cubit<GoogleSigninState> {
  GoogleSigninCubit() : super(GoogleSigninInitial());

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(
    serverClientId:
        '780867026107-7lmj62f198qpljrur40po0olgnh80atr.apps.googleusercontent.com',
  );
  final _firestore = FirebaseFirestore.instance;

  Future<void> signInWithGoogle() async {
    try {
      emit(GoogleSigninLoading());

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(GoogleSigninFailure(error: "User cancelled login"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, // ✅ Only idToken is needed now
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      await _ensureUserDocument(userCredential.user!);
      emit(GoogleSigninSuccess(user: userCredential.user));
    } catch (e) {
      emit(GoogleSigninFailure(error: e.toString()));
    }
  }

  Future<void> _ensureUserDocument(User user) async {
    try {
      final doc = await _firestore.collection("users").doc(user.uid).get();

      if (!doc.exists) {
        await _firestore.collection("users").doc(user.uid).set({
          "name": user.displayName ?? "User",
          "email": user.email ?? "",
          "photo": user.photoURL,
          "friends": [],
          "isOnline": true,
          "lastSeen": FieldValue.serverTimestamp(),
          "createdAt": FieldValue.serverTimestamp(),
        });
      } else {
        // ✅ Update user data including photo when logging in again
        await _firestore.collection("users").doc(user.uid).update({
          "name": user.displayName ?? "User",
          "photo": user.photoURL, // ✅ Update photo in case it changed
          "isOnline": true,
          "lastSeen": FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Refresh user data after profile updates
  Future<void> refreshUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        final refreshedUser = _auth.currentUser;
        emit(GoogleSigninSuccess(user: refreshedUser));
      }
    } catch (e) {
      emit(GoogleSigninFailure(
          error: 'Failed to refresh user data: ${e.toString()}'));
    }
  }

  // Update user state directly
  void updateUserState(User? user) {
    if (user != null) {
      emit(GoogleSigninSuccess(user: user));
    }
  }

  /// ✅ FIXED: Sign out and clear Google account cache completely
  /// This ensures the user can choose a different account on next sign-in
  Future<void> signOut() async {
    try {
      emit(GoogleSignOutLoading());
      final userId = _auth.currentUser?.uid;

      // Update Firestore status
      if (userId != null) {
        await _firestore.collection("users").doc(userId).update({
          "isOnline": false,
          "lastSeen": FieldValue.serverTimestamp(),
        });
      }

      // ✅ Clear Google account cache
      try {
        await _googleSignIn.disconnect();
      } catch (e) {
        // disconnect() might fail if no account is connected
        print('Google disconnect note: $e');
      }

      // Sign out from Firebase
      await _auth.signOut();

      emit(GoogleSignOutSuccs());
    } catch (e) {
      print('Logout error: $e');
      emit(GoogleSignOutFaill(errorMess: e.toString()));
    }
  }
}
