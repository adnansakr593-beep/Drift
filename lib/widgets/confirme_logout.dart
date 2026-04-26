import 'package:drift_app/helper/const.dart';
import 'package:drift_app/widgets/custom_button.dart';
import 'package:drift_app/widgets/glass_cont.dart';
import 'package:drift_app/widgets/handle_logout.dart';
import 'package:flutter/material.dart';

void confirmeLogOut(BuildContext context, ColorScheme colors) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => GlassCont(
      border: Border.all(color: colors.onSurface.withOpacity(0.3), width: 1),
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Do you sure you want to logout?',
                    style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: fontFamily),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: CustomButtom(
                  backgroundColor: colors.onSurface.withOpacity(0.3),
                  text: 'cancle',
                  fontSize: 14,
                  borderColor: colors.background,
                  onTap: () {
                    Navigator.pop(context);
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
                      const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  text: 'Logout',
                  fontSize: 15,
                  borderColor: colors.background,
                  onTap: () async {
                    await handleLogout(context, colors);
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
