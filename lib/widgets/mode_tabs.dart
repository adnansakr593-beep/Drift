import 'package:drift_app/classes/mode_info.dart';
import 'package:drift_app/widgets/trip_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ModeTabs extends StatefulWidget {
  final Map<TripMode, ModeInfo> modeInfo;
  final TripMode selectedMode;
  final void Function(TripMode mode)? onTap;
  final bool enabled;
  const ModeTabs(
      {super.key,
      required this.modeInfo,
      required this.selectedMode,
      this.onTap,
      required this.enabled});

  @override
  State<ModeTabs> createState() => _ModeTabsState();
}

class _ModeTabsState extends State<ModeTabs> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: TripMode.values.map((mode) {
          final info = widget.modeInfo[mode]!;
          final selected = widget.selectedMode == mode;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                widget.enabled ? widget.onTap?.call(mode) : null;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: colors.background.withOpacity(0.5),
                        blurStyle: BlurStyle.inner),
                  ],
                  color: selected
                      ? info.color.withOpacity(0.15)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected
                        ? info.color
                        : colors.onSurface.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      info.icon,
                      color: selected
                          ? info.color
                          : colors.onSurface.withOpacity(0.45),
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w400,
                        color: selected
                            ? info.color
                            : colors.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
