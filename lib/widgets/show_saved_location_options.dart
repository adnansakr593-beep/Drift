// // ══ MINI CARD LONG PRESS → edit / delete dialog ══════════════════════════
import 'package:drift_app/helper/const.dart';
import 'package:drift_app/models/saved_location_model.dart';
import 'package:drift_app/services/saved_locations_service_firebase.dart';
import 'package:drift_app/widgets/confirme_delete.dart';
import 'package:drift_app/widgets/custom_button.dart';
import 'package:drift_app/widgets/glass_cont.dart';
import 'package:drift_app/widgets/mini_cards.dart';
import 'package:drift_app/widgets/open_edit_location_sheet.dart';
import 'package:flutter/material.dart';

void showSavedLocationOptions(BuildContext context, SavedLocation loc,
    SavedLocationService savedService, bool mounted, ColorScheme colors) {
  showDialog(
    context: context,
    builder: (dialogContext) => GlassCont(
      border: Border.all(color: colors.onSurface.withOpacity(0.3), width: 1),
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 55.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MiniCard.iconForLabel(loc.name),
                  color: colors.onSurface,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    loc.name,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text(
            style: TextStyle(fontFamily: fontFamily, color: colors.onSurface),
            loc.address.isNotEmpty ? loc.address : 'No address info',
            //maxLines: 3,
            //overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: CustomButtom(
                  backgroundColor: colors.onSurface.withOpacity(0.3),
                  text: 'Edit',
                  fontSize: 14,
                  borderColor: colors.background,
                  onTap: () {
                    Navigator.pop(context);
                    openEditLocationSheet(context, savedService, loc);
                  },
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: CustomButtom(
                  backgroundColor: colors.onSurface.withOpacity(0.3),
                  icon:
                      const Icon(Icons.delete_rounded, color: Colors.redAccent),
                  text: 'Delete',
                  fontSize: 15,
                  borderColor: colors.background,
                  onTap: () async {
                    Navigator.pop(context);
                    await confirmDelete(loc, savedService, context, mounted);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
