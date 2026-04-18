// // import 'package:drift_app/pages/settings_page.dart';
// // import 'package:drift_app/widgets/build_name_section.dart';
// // import 'package:drift_app/widgets/build_profile_pic.dart';
// import 'package:drift_app/cubits/theme_cubit/theme_cubit.dart';
// import 'package:drift_app/cubits/theme_cubit/theme_state.dart';
// import 'package:drift_app/widgets/custom_switch.dart';
// import 'package:drift_app/widgets/drawer_lists.dart';
// import 'package:drift_app/widgets/glass_cont.dart';
// import 'package:drift_app/widgets/handle_logout.dart';
// import 'package:drift_app/widgets/show_user_info.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CustomDrawer extends StatelessWidget {
//   CustomDrawer({super.key});

//   final user = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return GlassCont(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ShowUserInfo(),
//           BlocBuilder<ThemeCubit, ThemeState>(
//             builder: (context, themeState) {
//               final isDark = themeState.themeMode == ThemeMode.dark;
//               // return DrawerLists(
//               //   //icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode) ,
//               //   title: isDark ? 'Dark Mode' : 'Light Mode',
//               //   //subtitle: isDark ? 'On' : 'Off',

//               //   child:  Switch(
//               //     value: isDark,
//               //     onChanged: (value) async {
//               //       await context.read<ThemeCubit>().toggleTheme(value);
//               //     },
//               //     activeColor: colors.background,
//               //   ),

//               // );

//               return CustomSwitch(
//                 title: isDark ? 'Dark Mode' : 'Light Mode',
//                 child: Switch(
//                   value: isDark,
//                   onChanged: (value) async {
//                     await context.read<ThemeCubit>().toggleTheme(value);
//                   },
//                   activeColor: colors.background,
//                 ),
//               );
//             },
//           ),
//           DrawerLists(
//             title: 'Log Out',
//             onTap: () {
//               handleLogout(context, colors);
//             },
//             icon: Icon(
//               Icons.logout_rounded,
//               color: colors.background,
//               size: 30,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:drift_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:drift_app/cubits/theme_cubit/theme_state.dart';
import 'package:drift_app/pages/history_page.dart';
import 'package:drift_app/widgets/custom_switch.dart';
import 'package:drift_app/widgets/drawer_lists.dart';
import 'package:drift_app/widgets/glass_cont.dart';
import 'package:drift_app/widgets/handle_logout.dart';
import 'package:drift_app/widgets/show_dialog.dart';
import 'package:drift_app/widgets/show_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GlassCont(
      top: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
      bottom: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
      left: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
      padding: const EdgeInsets.only(left: 55, top: 31, bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ── User Info ──────────────────────────────────────────
          const ShowUserInfo(),

          // ── Theme Toggle ───────────────────────────────────────
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final isDark = themeState.themeMode == ThemeMode.dark;
              return CustomSwitch(
                title: isDark ? 'Dark Mode' : 'Light Mode',
                child: Switch(
                  value: isDark,
                  onChanged: (value) async {
                    await context.read<ThemeCubit>().toggleTheme(value);
                  },
                  activeColor: colors.background,
                ),
              );
            },
          ),

          // ── Notifications ──────────────────────────────────────
          DrawerLists(
            title: 'History',
            icon: Icon(Icons.history, color: colors.background, size: 30),
            onTap: () {
              Navigator.pushNamed(context, HistoryPage.id);
            },
          ),

          // ── About ──────────────────────────────────────────────
          DrawerLists(
            title: 'About',
            icon: Icon(
              Icons.info_outline_rounded,
              color: colors.background,
              size: 30,
            ),
            onTap: () {
              customDialog(context, colors);
            },
          ),

          // ── Log Out ────────────────────────────────────────────
          DrawerLists(
            title: 'Log Out',
            onTap: () => handleLogout(context, colors),
            icon: Icon(
              Icons.logout_rounded,
              color: colors.background,
              size: 30,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
