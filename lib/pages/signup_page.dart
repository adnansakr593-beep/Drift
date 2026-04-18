import 'package:drift_app/helper/const.dart';
import 'package:drift_app/widgets/custom_siginup_data.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  static String id = 'SignUpPage';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        // الخلفية الأساسية
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.surface.withOpacity(0.7),
                colors.background,
                colors.surface.withOpacity(0.7),
                colors.background,
              ], //Color(0xff0F225E), Color(0xff0F225E), colors.background
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
                        image: const DecorationImage(
                          image: AssetImage(logoPath2),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Join Drift',
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: fontFamily,
                      color: colors.onBackground,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 338,
                    child: Text(
                      'Join for a premium ride experience',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: fontFamily,
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Center(child: CustomSiginupData()),
                ],
              ),
            ),
            //const SizedBox(height: 25),
          ),
        ),
      ],
    );
  }
}
