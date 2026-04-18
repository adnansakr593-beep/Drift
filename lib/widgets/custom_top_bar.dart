// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final bool hasRoute;
  const TopBar({super.key, required this.hasRoute});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.map_rounded, color: Color(0xFF4285F4), size: 22),
          const SizedBox(width: 12),
          Text(
            hasRoute ? '✅ المسار جاهز' : '📍 اضغط على الخريطة لتحديد وجهة',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}