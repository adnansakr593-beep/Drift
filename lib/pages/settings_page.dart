// // ignore_for_file: deprecated_member_use
// // import 'dart:async';
// import 'package:drift_app/cubits/google_signin/google_signin_cubit.dart';
// import 'package:drift_app/cubits/theme_cubit/theme_cubit.dart';
// import 'package:drift_app/cubits/theme_cubit/theme_state.dart';
// import 'package:drift_app/cubits/user_profile_cubit/user_profile_cubit.dart';
// import 'package:drift_app/cubits/user_profile_cubit/user_profile_state.dart';
// import 'package:drift_app/widgets/build_error.dart';
// import 'package:drift_app/widgets/build_name_section.dart';
// import 'package:drift_app/widgets/build_profile_pic.dart';
// import 'package:drift_app/widgets/handle_logout.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});
//   static String id = 'setting page';

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   void _showSnackBar(String message, {bool isError = false}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : Colors.green,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     // ✅ جيب الـ user مباشرة من Firebase بدل ما تنتظر الـ Cubit state
//     final user = FirebaseAuth.instance.currentUser;

//     return BlocListener<UserProfileCubit, UserProfileState>(
//       listener: (context, state) {
//         if (state is UserProfilePhotoUpdateSuccess) {
//           _showSnackBar('Profile picture updated successfully!');
//           if (state.updatedUser != null) {
//             context.read<GoogleSigninCubit>().updateUserState(
//               state.updatedUser,
//             );
//           }
//           context.read<UserProfileCubit>().resetState();
//         } else if (state is UserProfileError) {
//           _showSnackBar(state.message, isError: true);
//           context.read<UserProfileCubit>().resetState();
//         }
//       },
//       child: user != null
//           ? buildSettingsContent(user, colors)
//           : BuildError(),
//     );
//   }

//   Widget buildSettingsContent(User user, ColorScheme colors) {
//     return Scaffold(
//       backgroundColor: colors.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),

//               // Settings Title
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Row(
//                   children: [
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: Icon(Icons.arrow_back_ios_new, size: 35),
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       'Settings',
//                       style: TextStyle(
//                         color: colors.onSurface,
//                         fontSize: 35,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 30),
//               BuildProfilePic(user: user),
//               const SizedBox(height: 20),
//               BuildNameSection(user: user),
//               const SizedBox(height: 5),

//               // Email
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40),
//                 child: Text(
//                   user.email ?? 'No email',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: colors.onSurface.withValues(alpha: 0.6),
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//               const SizedBox(height: 40),
//               //buildSettingsList(colors),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget buildSettingsList(ColorScheme colors) {
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(horizontal: 20),
//   //     child: Column(
//   //       children: [
//   //         BlocBuilder<ThemeCubit, ThemeState>(
//   //           builder: (context, themeState) {
//   //             final isDark = themeState.themeMode == ThemeMode.dark;
//   //             return buildSettingsTile(
//   //               context,
//   //               icon: isDark ? Icons.dark_mode : Icons.light_mode,
//   //               title: 'Dark Mode',
//   //               subtitle: isDark ? 'On' : 'Off',
//   //               trailing: Switch(
//   //                 value: isDark,
//   //                 onChanged: (value) async {
//   //                   await context.read<ThemeCubit>().toggleTheme(value);
//   //                 },
//   //                 activeColor: colors.primary,
//   //               ),
//   //             );
//   //           },
//   //         )
//   //     ])
//   //   );
//   // //         buildSettingsTile(
//   // //           context,
//   // //           icon: Icons.person_outline,
//   // //           title: 'Account',
//   // //           subtitle: 'Privacy, security, change email',
//   // //           onTap: () => _showSnackBar('Account settings - Coming soon!'),
//   // //         ),
//   // //         buildSettingsTile(
//   // //           context,
//   // //           icon: Icons.notifications_outlined,
//   // //           title: 'Notifications',
//   // //           subtitle: 'Message, group & call tones',
//   // //           onTap: () => _showSnackBar('Notifications - Coming soon!'),
//   // //         ),
//   // //         buildSettingsTile(
//   // //           context,
//   // //           icon: Icons.lock_outline,
//   // //           title: 'Privacy',
//   // //           subtitle: 'Block contacts, disappearing messages',
//   // //           onTap: () => _showSnackBar('Privacy settings - Coming soon!'),
//   // //         ),
//   // //         buildSettingsTile(
//   // //           context,
//   // //           icon: Icons.storage_outlined,
//   // //           title: 'Storage and Data',
//   // //           subtitle: 'Network usage, auto-download',
//   // //           onTap: () => _showSnackBar('Storage settings - Coming soon!'),
//   // //         ),
//   // //         buildSettingsTile(
//   // //           context,
//   // //           icon: Icons.help_outline,
//   // //           title: 'Help',
//   // //           subtitle: 'Help center, contact us, privacy policy',
//   // //           onTap: () => _showSnackBar('Help - Coming soon!'),
//   // //         ),
//   // //         buildSettingsTile(
//   // //           context,
//   // //           icon: Icons.logout,
//   // //           title: 'Logout',
//   // //           subtitle: 'Logout from your account',
//   // //           onTap: () => handleLogout(context, colors),
//   // //         ),
//   // //         const SizedBox(height: 20),
//   // //         Text(
//   // //           'Chat App v1.0.0',
//   // //           style: TextStyle(
//   // //             color: colors.onSurface.withValues(alpha: 0.4),
//   // //             fontSize: 12,
//   // //           ),
//   // //         ),
//   // //         const SizedBox(height: 30),
//   // //       ],
//   // //     ),
//   // //   );
//   // // }

  // Widget buildSettingsTile(
  //   BuildContext context, {
  //   required IconData icon,
  //   required String title,
  //   required String subtitle,
  //   VoidCallback? onTap,
  //   Widget? trailing,
  // }) {
  //   final colors = Theme.of(context).colorScheme;

  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 15),
  //     decoration: BoxDecoration(
  //       color: colors.surface,
  //       borderRadius: BorderRadius.circular(15),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: ListTile(
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //       leading: Container(
  //         padding: const EdgeInsets.all(10),
  //         decoration: BoxDecoration(
  //           color: colors.primary.withValues(alpha: 0.1),
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Icon(icon, color: colors.primary, size: 24),
  //       ),
  //       title: Text(
  //         title,
  //         style: TextStyle(
  //           color: colors.onSurface,
  //           fontWeight: FontWeight.w600,
  //           fontSize: 16,
  //         ),
  //       ),
  //       subtitle: Text(
  //         subtitle,
  //         style: TextStyle(
  //           color: colors.onSurface.withValues(alpha: 0.6),
  //           fontSize: 12,
  //         ),
  //       ),
  //       trailing:
  //           trailing ??
  //           Icon(
  //             Icons.arrow_forward_ios,
  //             size: 16,
  //             color: colors.onSurface.withValues(alpha: 0.4),
  //           ),
  //       onTap: onTap,
  //     ),
  //   );
  // }
  // }
// }
