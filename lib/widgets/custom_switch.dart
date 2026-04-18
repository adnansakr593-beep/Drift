import 'package:drift_app/helper/const.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final Widget? icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? child;
  const CustomSwitch({
    super.key,
    this.icon,
    required this.title,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 75,
      width: 220,
      //padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(bottom: 15, left: 25),
      decoration: BoxDecoration(
        color: colors.onSurface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              title,
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: fontFamily,
              ),
            ),
          ),

          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: icon!,
            ),
          ],

          if (child != null) ...[child!],
        ],
      ),
    );
  }
}
