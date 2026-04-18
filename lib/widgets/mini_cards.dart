// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MiniCard extends StatelessWidget {
  const MiniCard({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;

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
    final resolvedIcon = icon ?? iconForLabel(label);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon bubble ────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(resolvedIcon, color: colors.primary, size: 18),
            ),
            const SizedBox(width: 8),
            // ── Label ──────────────────────────────────────────────────────────
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}