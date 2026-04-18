import 'package:drift_app/cubits/forgot_password/forgot_pass_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassCubit extends Cubit<ForgotPassState> {
  ForgotPassCubit() : super(ForgotPassInitial());

  Future<void> forgotPass({required String email}) async {
    emit(ForgotPassloading());

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(ForgotPassSent(message: 'Check your email for the reset link'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(ForgotPassFail(errmessage: 'No user found with this email'));
      } else if (e.code == 'invalid-email') {
        emit(ForgotPassFail(errmessage: 'Invalid email address'));
      } else if (e.code == 'too-many-requests') {
        emit(ForgotPassFail(errmessage: 'Too many requests. Try again later'));
      } else {
        emit(ForgotPassFail(errmessage: 'Failed to send reset email'));
      }
    } catch (e) {
      emit(ForgotPassFail(errmessage: 'An error occurred: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(ForgotPassInitial());
  }
}
