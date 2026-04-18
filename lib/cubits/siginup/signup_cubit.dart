import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift_app/cubits/siginup/signup_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    emit(SignupLoading());

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (displayName != null && displayName.isNotEmpty) {
        await credential.user!.updateDisplayName(displayName);
      }

      await _createUserDocument(credential.user!, displayName: displayName);
      emit(SignupSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignupFaill(errmassege: 'Weak password'));
      } else if (e.code == 'email-already-in-use') {
        emit(SignupFaill(errmassege: 'Email already in use'));
      } else if (e.code == 'invalid-email') {
        emit(SignupFaill(errmassege: 'Invalid email format'));
      } else {
        emit(SignupFaill(errmassege: 'Error: ${e.code}'));
      }
    }
  }

  Future<void> _createUserDocument(User user, {String? displayName}) async {
    try {
      await _firestore.collection("users").doc(user.uid).set({
        "name": displayName ?? user.email?.split('@')[0] ?? "User",
        "email": user.email ?? "",
        "photo": user.photoURL,
        "friends": [],
        "isOnline": true,
        "lastSeen": FieldValue.serverTimestamp(),
        "createdAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }
}
