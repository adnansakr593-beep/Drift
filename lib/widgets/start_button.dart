import 'package:drift_app/classes/mode_info.dart';
import 'package:drift_app/widgets/driver_found.dart';
import 'package:drift_app/widgets/serching_driver.dart';
import 'package:drift_app/widgets/trip_bottom_sheet.dart';
import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  final TripState tripState;
  final void Function()? onTapSearchinDriver;
  final Map<TripMode, ModeInfo> modeInfo;
  final TripMode selectedMode;
  final AnimationController pulseController;
  final double price;
  final void Function()? onTapDriverFound;
  final void Function()? onTapStrartTrip;
  final ModeInfo mode;

  const StartButton(
      {super.key,
      required this.tripState,
      this.onTapSearchinDriver,
      required this.modeInfo,
      required this.selectedMode,
      required this.pulseController,
      required this.price,
      required this.onTapDriverFound,
      this.onTapStrartTrip, required this.mode});

  @override
  Widget build(BuildContext context) {
    if (tripState == TripState.searchingDriver) {
      return SerchingDriver(
        onTap: onTapSearchinDriver,
        modeInfo: modeInfo,
        selectedMode: selectedMode,
        pulseController: pulseController,
        price: price,
      );
    }
    if (tripState == TripState.driverFound) {
      return DriverFound(
        onTap: onTapDriverFound,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: GestureDetector(
        onTap: onTapStrartTrip,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [mode.color, mode.color.withOpacity(0.75)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: mode.color.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_taxi_rounded, color: Colors.white, size: 22),
              SizedBox(width: 10),
              Text(
                'Start Trip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
