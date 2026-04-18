// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class DestinationMarker extends StatelessWidget {
  const DestinationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.location_on_rounded,
      color: Color(0xFFEA4335),
      size: 40,
      shadows: [
        Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
      ],
    );
  }
}

class UserLocationMarker extends StatefulWidget {
  const UserLocationMarker({super.key});
  @override
  State<UserLocationMarker> createState() => _State();
}

class _State extends State<UserLocationMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _anim = Tween(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, __) => Stack(
        alignment: Alignment.center,
        children: [
          // حلقة النبض
          Container(
            width: 40 * _anim.value,
            height: 40 * _anim.value,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: colors.surface
                    // .withOpacity(0.2 * (1 - _anim.value)),
                    ),
          ),
          // النقطة المركزية
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4285F4),
              border: Border.all(color: colors.onSurface, width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4285F4).withOpacity(0.4),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
