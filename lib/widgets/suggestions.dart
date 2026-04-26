import 'package:drift_app/classes/place_suggestion.dart';
import 'package:flutter/material.dart';

class Suggestions extends StatelessWidget {
  final List<PlaceSuggestion> suggestions;

  // ✅ Each tap passes the selected PlaceSuggestion back to the caller
  final void Function(PlaceSuggestion place)? onTap;

  const Suggestions({super.key, required this.suggestions, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: colors.background.withOpacity(0.5),
              blurStyle: BlurStyle.inner),
        ],
        borderRadius: BorderRadius.circular(19),
        //shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: colors.onSurface.withOpacity(0.4), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: suggestions.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            return InkWell(
              onTap: () => onTap?.call(s), // ✅ passes the actual item
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  border: i < suggestions.length - 1
                      ? Border(
                          bottom: BorderSide(
                            color: colors.onSurface.withOpacity(0.07),
                          ),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.place_rounded,
                        color: colors.onSurface,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.shortName,
                            style: TextStyle(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            s.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.onSurface.withOpacity(0.45),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
