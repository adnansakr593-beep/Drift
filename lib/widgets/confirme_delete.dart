import 'package:drift_app/helper/const.dart';
import 'package:drift_app/models/saved_location_model.dart';
import 'package:drift_app/services/saved_locations_service_firebase.dart';
import 'package:drift_app/widgets/custom_button.dart';
import 'package:drift_app/widgets/glass_cont.dart';
import 'package:flutter/material.dart';

Future<void> confirmDelete(SavedLocation loc, SavedLocationService savedService,
    BuildContext context, bool mounted) async {
  final colors = Theme.of(context).colorScheme;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => GlassCont(
      border: Border.all(color: colors.onSurface.withOpacity(0.3), width: 1),
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 280),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 35),
            child: Text(
              'Delete "${loc.name}"?',
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Text(
            style: TextStyle(fontFamily: fontFamily, color: colors.onSurface),
            'This saved place will be permanently removed.',
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: CustomButtom(
                  backgroundColor: colors.onSurface.withOpacity(0.3),
                  text: 'Cancel',
                  fontSize: 14,
                  borderColor: colors.background,
                  onTap: () =>
                      Navigator.pop(ctx, false), // ← use ctx not context
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: CustomButtom(
                  backgroundColor: colors.onSurface.withOpacity(0.3),
                  icon:
                      const Icon(Icons.delete_rounded, color: Colors.redAccent),
                  text: 'Delete',
                  fontSize: 15,
                  borderColor: colors.background,
                  onTap: () =>
                      Navigator.pop(ctx, true), // ← fixed: was recursing
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  if (confirmed == true) {
    await savedService.delete(loc.id);
    if (mounted) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Place deleted'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}
