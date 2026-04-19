import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, FirebaseFirestore;
import 'package:drift_app/cubits/forgot_password/forgot_pass_cubit.dart';
import 'package:drift_app/cubits/google_signin/google_signin_cubit.dart';
import 'package:drift_app/cubits/siginup/signup_cubit.dart';
import 'package:drift_app/cubits/signin/signin_cubit.dart';
import 'package:drift_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:drift_app/cubits/theme_cubit/theme_state.dart';
import 'package:drift_app/cubits/user_profile_cubit/user_profile_cubit.dart';
import 'package:drift_app/pages/forgot_pass_page.dart';
import 'package:drift_app/pages/history_page.dart';
import 'package:drift_app/pages/map_page.dart';
import 'package:drift_app/pages/signin_page.dart';
import 'package:drift_app/pages/signup_page.dart';
import 'package:drift_app/themes/dark_theme.dart';
import 'package:drift_app/themes/light_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Drift());
}

class Drift extends StatelessWidget {
  const Drift({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SigninCubit()),
        BlocProvider(create: (_) => ForgotPassCubit()),
        BlocProvider(create: (_) => GoogleSigninCubit()),
        BlocProvider(create: (_) => UserProfileCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => SignupCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: false,
            routes: {
              SigninPage.id: (context) => const SigninPage(),
              SignupPage.id: (context) => const SignupPage(),
              HistoryPage.id: (context) => const HistoryPage(),
              MapPage.id: (context) => const MapPage(),
              ForgotPassPage.id: (context) => const ForgotPassPage(),
            },
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

// ── Auth Wrapper ───────────────────────────────────────────────────────────────
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) _updatePresence(user.uid, state);
  }

  Future<void> _updatePresence(String userId, AppLifecycleState state) async {
    try {
      if (state == AppLifecycleState.hidden) return;
      final isOnline = state == AppLifecycleState.resumed;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Presence update error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Logged in → MainPage (no back stack, user cannot go back to SigninPage)
        if (snapshot.hasData && snapshot.data != null) {
          final userId = snapshot.data!.uid;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updatePresence(userId, AppLifecycleState.resumed);
          });
          return const MapPage();
        }

        // Not logged in → SigninPage
        return const SigninPage();
      },
    );
  }
}
