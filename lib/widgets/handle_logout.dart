import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift_app/cubits/google_signin/google_signin_cubit.dart';
import 'package:drift_app/helper/const.dart';
import 'package:drift_app/pages/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

bool _isLoggingOut = false;

Future<void> handleLogout(BuildContext context, ColorScheme colors) async {
  if (_isLoggingOut) return;
  _isLoggingOut = true;

  final userId = FirebaseAuth.instance.currentUser?.uid;

  // تحديث حالة المستخدم
  if (userId != null) {
    try {
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "isOnline": false,
        "lastSeen": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Failed to update user status: $e');
    }
  }

  if (!context.mounted) {
    _isLoggingOut = false;
    return;
  }

  // Loading Dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          'Logging out...',
          style: TextStyle(color: colors.onSurface),
        ),
        content: SizedBox(
          height: 65,
          child: Center(
            child: CircularProgressIndicator(color: colors.primary),
          ),
        ),
      ),
    ),
  );

  try {
    await context.read<GoogleSigninCubit>().signOut();

    if (!context.mounted) {
      _isLoggingOut = false;
      return;
    }

    // قفل الـ dialog
    Navigator.pop(context);

    // رسالة نجاح
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Logged out successfully',
          style: TextStyle(color: colors.onSurface, fontFamily: fontFamily),
        ),
        backgroundColor: colors.background,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    // 🔥 أهم سطر: يقفل drawer + home ويروح login
    Navigator.pushNamedAndRemoveUntil(
      context,
      SigninPage.id, // أو غيرها لـ SignInPage.id
      (route) => false,
    );
  } catch (e) {
    if (context.mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  } finally {
    _isLoggingOut = false;
  }
}
