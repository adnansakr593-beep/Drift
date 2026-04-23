import 'package:drift_app/classes/mode_info.dart';
import 'package:drift_app/widgets/trip_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ModeTabs extends StatefulWidget {
  final Map<TripMode, ModeInfo> modeInfo;
  final TripMode selectedMode;
  final void Function(TripMode mode)? onTap;
  const ModeTabs(
      {super.key,
      required this.modeInfo,
      required this.selectedMode,
      this.onTap});

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
                widget.onTap?.call(mode);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? info.color.withOpacity(0.15)
                      : colors.surfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? info.color : Colors.transparent,
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
