import 'package:drift_app/classes/mode_info.dart';
import 'package:drift_app/widgets/price_arrow.dart';
import 'package:flutter/material.dart';

class PriceEditor extends StatelessWidget {
  final double price;
  final double basePriceKm;
  final void Function() onTapPluse;
  final void Function() onTapminse;
  final ModeInfo mode;
  final bool enabled;

  const PriceEditor({
    super.key,
    required this.price,
    required this.basePriceKm,
    required this.onTapPluse,
    required this.onTapminse,
    required this.mode,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    enabled ? 'Offer Price' : 'Offer Price (locked)',
                    style: TextStyle(
                      color: colors.onSurface.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'EGP ${price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    '${basePriceKm.toStringAsFixed(1)} EGP/km  •  '
                    '${enabled ? 'tap ↑↓ to adjust' : 'cancel trip to edit'}',
                    style: TextStyle(
                      color: colors.onSurface.withOpacity(0.35),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            // ── Arrow buttons hidden while locked ──────────────────────────
            if (enabled)
              Column(
                children: [
                  PriceArrowBtn(
                    icon: Icons.keyboard_arrow_up_rounded,
                    color: mode.color,
                    onTap: onTapPluse,
                  ),
                  const SizedBox(height: 6),
                  PriceArrowBtn(
                    icon: Icons.keyboard_arrow_down_rounded,
                    color: Colors.redAccent,
                    onTap: onTapminse,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
