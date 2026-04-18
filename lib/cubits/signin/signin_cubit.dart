import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift_app/cubits/signin/signin_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit() : super(SigninInitial());

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signin({required String email, required String password}) async {
    emit(SigninLoading());
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _ensureUserDocument(credential.user!);

      emit(SigninSucss());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(SigninFaill(errmassege: 'No user found for this email'));
      } else if (e.code == 'wrong-password') {
        emit(SigninFaill(errmassege: 'Wrong password provided'));
      } else {
        emit(SigninFaill(errmassege: 'Error: ${e.code}'));
      }
    }
  }

  Future<void> _ensureUserDocument(User user) async {
    try {
      final doc = await _firestore.collection("users").doc(user.uid).get();

      if (!doc.exists) {
        await _firestore.collection("users").doc(user.uid).set({
          "name": user.displayName ?? user.email?.split('@')[0] ?? "User",
          "email": user.email ?? "",
          "photo": user.photoURL,
          "friends": [],
          "isOnline": true,
          "lastSeen": FieldValue.serverTimestamp(),
          "createdAt": FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore.collection("users").doc(user.uid).update({
          "isOnline": true,
          "lastSeen": FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  Future<void> signOut() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection("users").doc(userId).update({
          "isOnline": false,
          "lastSeen": FieldValue.serverTimestamp(),
        });
      }

      await _googleSignIn.signOut();
      await _auth.signOut();

      emit(SigninInitial());
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }
}
