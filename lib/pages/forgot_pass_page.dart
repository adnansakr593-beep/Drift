// ignore_for_file: deprecated_member_use

import 'package:drift_app/cubits/forgot_password/forgot_pass_cubit.dart';
import 'package:drift_app/cubits/forgot_password/forgot_pass_state.dart';
import 'package:drift_app/helper/const.dart';
import 'package:drift_app/pages/signin_page.dart';
import 'package:drift_app/widgets/custom_button.dart';
import 'package:drift_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  static String id = 'Forgot pass page';

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  @override
  Widget build(BuildContext context) {
    String? email;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 95),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: 55,
                    color: colors.onBackground.withOpacity(0.7),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                'Forgot Password',
                style: TextStyle(
                  color: colors.onBackground.withOpacity(0.8),
                  fontSize: 30,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Dont worry! It happens. Enter your email address below to receive a password reset link.',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamily,
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                'Enter your email',
                style: TextStyle(
                  color: colors.onBackground.withOpacity(0.8),
                  fontSize: 18,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),

              const SizedBox(height: 10),

              CustomTextFormField(
                width: double.infinity,
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

              const SizedBox(height: 25),
              BlocConsumer<ForgotPassCubit, ForgotPassState>(
                listener: (context, state) {
                  if (state is ForgotPassSent) {
                    Navigator.pushNamed(context, SigninPage.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "SigIn With New Pass",
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontFamily,
                          ),
                        ),
                        backgroundColor: colors.primary,
                      ),
                    );
                  } else if (state is ForgotPassFail) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errmessage,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontFamily,
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is ForgotPassloading;
                  return CustomButtom(
                    borderColor: colors.onSurface.withOpacity(0.7),
                    backgroundColor: colors.surface,
                    text: isLoading ? 'Sending...' : 'Send Reset Link',
                    textColor: colors.onBackground,
                    onTap: isLoading
                        ? null
                        : () {
                            if (email == null || email!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Enter Your Email First!",
                                    style: TextStyle(
                                      color: colors.onSurface,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: fontFamily,
                                    ),
                                  ),
                                  backgroundColor: colors.surface,
                                ),
                              );
                            } else {
                              context.read<ForgotPassCubit>().forgotPass(
                                email: email!,
                              );
                            }
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
