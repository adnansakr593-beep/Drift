import 'package:drift_app/classes/mode_info.dart';
import 'package:drift_app/widgets/trip_bottom_sheet.dart';
import 'package:flutter/material.dart';

class SerchingDriver extends StatelessWidget {
  final Map<TripMode, ModeInfo> modeInfo;
  final TripMode selectedMode;
  final AnimationController pulseController;
  final void Function()? onTap;
  final double price;
  const SerchingDriver(
      {super.key,
      required this.modeInfo,
      required this.selectedMode,
      required this.pulseController,
      this.onTap,
      required this.price});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final mode = modeInfo[selectedMode]!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: pulseController,
            // ignore: unnecessary_underscores
            builder: (_, __) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: mode.color.withOpacity(
                    0.08 + pulseController.value * 0.07,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: mode.color.withOpacity(
                      0.3 + pulseController.value * 0.3,
                    ),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: mode.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Searching for drivers nearby...',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Offer: EGP ${price.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: mode.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: const Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
