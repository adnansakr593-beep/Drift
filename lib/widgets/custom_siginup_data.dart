import 'package:drift_app/cubits/siginup/signup_cubit.dart';
import 'package:drift_app/cubits/siginup/signup_state.dart';
import 'package:drift_app/helper/const.dart';
import 'package:drift_app/pages/signin_page.dart';
import 'package:drift_app/widgets/custom_button.dart';
import 'package:drift_app/widgets/custom_text_form_field.dart';
import 'package:drift_app/widgets/glass_cont.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSiginupData extends StatefulWidget {
  const CustomSiginupData({super.key});

  @override
  State<CustomSiginupData> createState() => _CustomSiginupDataState();
}

class _CustomSiginupDataState extends State<CustomSiginupData> {
  String? email;
  String? password;
  String? name;
  String? confirmPassword;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GlassCont(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
              bottom: 25,
              left: 5,
            ),
            child: Text(
              'Create Account',
              style: TextStyle(
                color: colors.onBackground,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              'Full Name',
              style: TextStyle(
                color: colors.onBackground,
                fontSize: 13,
                fontFamily: fontFamily,
              ),
            ),
          ),
          const SizedBox(height: 6),

          CustomTextFormField(
            fillColor: colors.background.withOpacity(0.3),
            hintText: 'Adanan Sakr',
            prefixIcon: Icon(
              Icons.person_outline,
              color: colors.onBackground,
            ),
            onChanged: (v) => name = v,
            validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
          ),

          const SizedBox(height: 16),

          // Email Field
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              'Email Address',
              style: TextStyle(
                color: colors.onBackground,
                fontSize: 13,
                fontFamily: fontFamily,
              ),
            ),
          ),
          const SizedBox(height: 6),

          CustomTextFormField(
            fillColor: colors.background.withOpacity(0.3),
            hintText: 'name@example.com',
            prefixIcon: Icon(
              Icons.email,
              color: colors.onBackground,
            ),
            onChanged: (v) => email = v,
            validator: (v) => v!.isEmpty ? 'Please enter your email' : null,
          ),

          const SizedBox(height: 16),

          // Password Field
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              'Password',
              style: TextStyle(
                color: colors.onBackground,
                fontSize: 13,
                fontFamily: fontFamily,
              ),
            ),
          ),
          const SizedBox(height: 6),

          CustomTextFormField(
            fillColor: colors.background.withOpacity(0.3),
            hintText: 'Password',
            prefixIcon: Icon(
              Icons.lock,
              color: colors.onBackground,
            ),
            isPassword: true,
            onChanged: (v) => password = v,
            validator: (v) {
              if (v!.isEmpty) {
                return 'Please enter your password';
              }
              if (v.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Confirm Password Field
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              'Confirm Password',
              style: TextStyle(
                color: colors.onBackground,
                fontSize: 13,
                fontFamily: fontFamily,
              ),
            ),
          ),
          const SizedBox(height: 6),

          CustomTextFormField(
            fillColor: colors.background.withOpacity(0.3),
            hintText: 'Repeat Password',
            prefixIcon: Icon(
              Icons.lock_reset,
              color: colors.onBackground,
            ),
            isPassword: true,
            onChanged: (v) => confirmPassword = v,
            validator: (v) {
              if (v!.isEmpty) {
                return 'Please enter your password';
              }
              if (v != password) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),

          const SizedBox(height: 15),

          BlocConsumer<SignupCubit, SignupState>(
            listener: (context, state) {
              if (state is SignupSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Account created successfully!\n login in login Page',
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.pushNamed(context, SigninPage.id);
              } else if (state is SignupFaill) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errmassege),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is SignupLoading;
              return CustomButtom(
                borderColor: colors.onSurface.withOpacity(
                  0.7,
                ),
                backgroundColor: colors.background.withOpacity(0.3),
                text: isLoading ? 'Creating Account...' : 'Sign up',
                fontSize: 20,
                textColor: colors.onBackground,
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
                onTap: isLoading
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          context.read<SignupCubit>().signUp(
                                email: email!,
                                password: password!,
                                displayName: name,
                              );
                        }
                      },
              );
            },
          ),
          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?  ",
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 16,
                  fontFamily: fontFamily,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  SigninPage.id,
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: colors.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
