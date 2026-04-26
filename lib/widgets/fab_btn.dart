// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class FabBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const FabBtn({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFF4285F4),
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: colors.background.withOpacity(0.5),
                blurStyle: BlurStyle.inner),
          ],
          borderRadius: BorderRadius.circular(19),
          //shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),
          border:
              Border.all(color: colors.onSurface.withOpacity(0.4), width: 1),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
