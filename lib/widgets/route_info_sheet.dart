// ignore_for_file: deprecated_member_use

import 'package:drift_app/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import '../models/route_info.dart';

// ══ PRICING CONSTANTS ════════════════════════════════════════════════════════
const double _pricePerKm = 5.0; // EGP per km
const double _fuelPrice = 22.0; // EGP per liter
const double _fuelEfficiency = 12.0; // km per liter

// ══ PRICE CALCULATOR ═════════════════════════════════════════════════════════
// Total = (distance × pricePerKm) + (distance / efficiency × fuelPrice)
String _calculatePrice(double distanceMeters) {
  final km = distanceMeters / 1000;
  final tripCost = km * _pricePerKm;
  final fuelCost = (km / _fuelEfficiency) * _fuelPrice;
  final total = tripCost + fuelCost;
  return '${total.toStringAsFixed(0)} EGP';
}

class RouteInfoSheet extends StatelessWidget {
  final RouteInfo route;
  final VoidCallback onClear;

  const RouteInfoSheet({super.key, required this.route, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final priceText = _calculatePrice(route.distanceMeters);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 14),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.primary,
            blurRadius: 20,
            offset: const Offset(4, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Distance ──────────────────────────────────
          CustomTile(
            icon: Icons.straighten_rounded,
            color: const Color(0xFF4285F4),
            label: 'المسافة',
            value: route.distanceText,
          ),
          const SizedBox(width: 2),
          Container(width: 1, height: 36, color: colors.onBackground),
          const SizedBox(width: 2),

          // ── Duration ──────────────────────────────────
          CustomTile(
            icon: Icons.access_time_rounded,
            color: const Color(0xFF34A853),
            label: 'الوقت',
            value: route.durationText,
          ),
          const SizedBox(width: 2),
          Container(width: 1, height: 36, color: colors.onBackground),
          const SizedBox(width: 2),

          // ── Price ─────────────────────────────────────
          CustomTile(
            icon: Icons.payments_rounded,
            color: const Color(0xFFFBBC04),
            label: 'التكلفة',
            value: priceText,
          ),
        ],
      ),
    );
  }
}
