// ignore_for_file: deprecated_member_use
import 'package:drift_app/cubits/google_signin/google_signin_cubit.dart';
import 'package:drift_app/cubits/google_signin/google_signin_state.dart';
import 'package:drift_app/helper/const.dart';
import 'package:drift_app/pages/map_page.dart';
import 'package:drift_app/pages/signup_page.dart';
import 'package:drift_app/widgets/custom_button.dart';
import 'package:drift_app/widgets/custom_siginin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  static String id = 'LoginPage';

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        // الخلفية الأساسية
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                colors.surface.withOpacity(0.7),
                colors.background,
                colors.surface.withOpacity(0.7),
                colors.background,
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      height: 195,
                      width: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        //color: colors.surface,
                        image: const DecorationImage(
                          image: AssetImage(logoPath2),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Welcom Back',
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: fontFamily,
                      color: colors.onBackground,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sign in to continue your journey',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: fontFamily,
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const CustomSigininData(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          indent: 29,
                          thickness: 2,
                          color: colors.onBackground.withOpacity(0.3),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: colors.onBackground,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          endIndent: 32,
                          thickness: 2,
                          color: colors.onBackground.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  BlocConsumer<GoogleSigninCubit, GoogleSigninState>(
                    listener: (context, state) {
                      if (state is GoogleSigninSuccess) {
                        Navigator.pushNamed(context, MapPage.id);
                      } else if (state is GoogleSigninFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is GoogleSigninLoading;
                      return SizedBox(
                        width: 330,
                        child: CustomButtom(
                          backgroundColor: colors.surface,
                          text:
                              isLoading ? 'Loading...' : 'Sign in with google',
                          fontSize: 22,
                          textColor: colors.onBackground,
                          borderColor: colors.onSurface.withOpacity(0.7),
                          icon: isLoading
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.onBackground,
                                  ),
                                )
                              : FaIcon(
                                  FontAwesomeIcons.google,
                                  color: colors.onBackground,
                                  size: 18,
                                ),
                          onTap: isLoading
                              ? null
                              : () {
                                  context
                                      .read<GoogleSigninCubit>()
                                      .signInWithGoogle();
                                },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: colors.onBackground,
                          fontSize: 16,
                          fontFamily: fontFamily,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, SignupPage.id),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
