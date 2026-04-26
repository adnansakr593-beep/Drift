import 'package:drift_app/classes/mode_info.dart';
import 'package:flutter/material.dart';

class RouteInfo extends StatelessWidget {
  final ModeInfo mode;
  final String? selectedCity;
  final double? routeDistanceKm;
  final double? routeDurationMin;

  const RouteInfo(
      {super.key,
      required this.mode,
      required this.selectedCity,
      required this.routeDistanceKm,
      required this.routeDurationMin});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mode.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: mode.color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(mode.icon, color: mode.color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCity ?? '',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${routeDistanceKm?.toStringAsFixed(1) ?? '--'} km  •  ${routeDurationMin?.toStringAsFixed(0) ?? '--'} min',
                  style: TextStyle(
                    color: colors.onSurface.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: mode.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              mode.label,
              style: TextStyle(
                color: mode.color,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
