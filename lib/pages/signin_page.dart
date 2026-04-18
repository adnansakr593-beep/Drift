// ignore_for_file: deprecated_member_use
import 'package:drift_app/cubits/google_signin/google_signin_cubit.dart';
import 'package:drift_app/cubits/google_signin/google_signin_state.dart';
import 'package:drift_app/cubits/signin/signin_cubit.dart';
import 'package:drift_app/cubits/signin/signin_state.dart';
import 'package:drift_app/helper/const.dart';
import 'package:drift_app/pages/forgot_pass_page.dart';

import 'package:drift_app/pages/map_page.dart';
import 'package:drift_app/pages/signup_page.dart';
import 'package:drift_app/widgets/custom_button.dart';
import 'package:drift_app/widgets/custom_text_form_field.dart';
import 'package:drift_app/widgets/glass_cont.dart';
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
  String? email;
  String? password;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
              child: Form(
                key: formKey,
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
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 25),
                    GlassCont(
                      top: BorderSide(
                        color: colors.onBackground.withOpacity(0.4),
                        width: 1.5,
                      ),
                      bottom: BorderSide(
                        color: colors.onBackground.withOpacity(0.4),
                        width: 1.5,
                      ),
                      right: BorderSide(
                        color: colors.onBackground.withOpacity(0.4),
                        width: 1.5,
                      ),
                      left: BorderSide(
                        color: colors.onBackground.withOpacity(0.4),
                        width: 1.5,
                      ),
                      //padding: EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                color: colors.onBackground.withOpacity(0.8),
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: CustomTextFormField(
                              hintText: 'name@example.com',
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: colors.onBackground,
                              ),
                              onChanged: (value) => email = value,
                              validator: (value) =>
                                  value!.isEmpty ? 'Email is required' : null,
                              fillColor: colors.surface,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 8),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                color: colors.onBackground.withOpacity(0.8),
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: CustomTextFormField(
                              hintText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                color: colors.onBackground,
                              ),
                              isPassword: true,
                              onChanged: (value) => password = value,
                              validator: (value) => value!.isEmpty
                                  ? 'Password is required'
                                  : null,
                              fillColor: colors.surface,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, ForgotPassPage.id);
                              },
                              child: Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  color: colors.onBackground,
                                  fontSize: 14,
                                  fontFamily: fontFamily,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          BlocConsumer<SigninCubit, SigninState>(
                            listener: (context, state) {
                              if (state is SigninSucss) {
                                Navigator.pushNamed(context, MapPage.id);
                              } else if (state is SigninFaill) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.errmassege)),
                                );
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is SigninLoading;
                              return CustomButtom(
                                borderColor: colors.onSurface.withOpacity(0.7),
                                backgroundColor: colors.surface,
                                text: isLoading ? 'Loading...' : 'Sign in',
                                textColor: colors.onBackground,
                                onTap: isLoading
                                    ? null
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          context.read<SigninCubit>().signin(
                                                email: email!,
                                                password: password!,
                                              );
                                        }
                                      },
                                icon: isLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: colors.onBackground,
                                        ),
                                      )
                                    : Icon(
                                        Icons.login_rounded,
                                        color: colors.onBackground,
                                      ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
                            text: isLoading
                                ? 'Loading...'
                                : 'Sign in with google',
                            fontSize: 22,
                            textColor: colors.onBackground,
                            borderColor: colors.onSurface.withOpacity(0.7),
                            icon: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
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
                    const SizedBox(height: 15),
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
        ),
      ],
    );
  }
}
