// ignore_for_file: deprecated_member_use
import 'dart:ui';

import 'package:drift_app/widgets/drawer_lists.dart';
import 'package:flutter/material.dart';

class MiniCard extends StatelessWidget {
  const MiniCard({
    super.key,
    required this.label,
    this.onTap,
    this.onLongPress,
  });

  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Auto-pick icon based on common Arabic / English keywords
  static IconData iconForLabel(String name) {
    final n = name.toLowerCase();
    if (n.contains('home') || n.contains('بيت') || n.contains('منزل')) {
      return Icons.home_rounded;
    } else if (n.contains('work') || n.contains('عمل') || n.contains('شغل')) {
      return Icons.work_rounded;
    } else if (n.contains('uni') ||
        n.contains('جامعة') ||
        n.contains('كلية') ||
        n.contains('school') ||
        n.contains('مدرسة')) {
      return Icons.school_rounded;
    } else if (n.contains('gym') || n.contains('جيم')) {
      return Icons.fitness_center_rounded;
    } else if (n.contains('hospital') || n.contains('مستشفى')) {
      return Icons.local_hospital_rounded;
    } else if (n.contains('shop') ||
        n.contains('mall') ||
        n.contains('سوق') ||
        n.contains('مول')) {
      return Icons.shopping_bag_rounded;
    } else if (n.contains('coffee') ||
        n.contains('cafe') ||
        n.contains('قهوة') ||
        n.contains('كافيه')) {
      return Icons.local_cafe_rounded;
    }
    return Icons.location_on_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: DrawerLists(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: colors.background.withOpacity(0.5),
                    blurStyle: BlurStyle.inner),
              ],
              borderRadius: BorderRadius.circular(19),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                  color: colors.onSurface.withOpacity(0.4), width: 1),
            ),
            sizedBoxWidth: 10,
            height: 40,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            margin: const EdgeInsets.only(left: 5),
            onTap: onTap,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            onLongPress: onLongPress,
            title: label,
            paddingSecondCont: const EdgeInsets.all(12),
            icon: Icon(
              iconForLabel(label),
              color: colors.onSurface,
              size: 20,
            ),
          ),
        ));
  }
}
