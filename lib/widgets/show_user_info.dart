import 'package:drift_app/helper/const.dart';
import 'package:drift_app/widgets/build_name_section.dart';
import 'package:drift_app/widgets/build_profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowUserInfo extends StatefulWidget {
  const ShowUserInfo({super.key});

  @override
  State<ShowUserInfo> createState() => _ShowUserInfoState();
}

class _ShowUserInfoState extends State<ShowUserInfo> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        BuildProfilePic(user: user!),
        const SizedBox(height: 5),
        BuildNameSection(user: user),
        const SizedBox(height: 5),

        // Email
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            user.email ?? 'No email',
            style: TextStyle(
              fontSize: 16,
              color: colors.onSurface.withValues(alpha: 0.6),
              fontFamily: fontFamily,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 5),
      ],
    );
  }
}
