import 'package:flutter/material.dart';

class BuildHandle extends StatelessWidget {
  const BuildHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: colors.onSurface.withOpacity(0.2),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
