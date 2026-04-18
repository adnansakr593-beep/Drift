import 'package:drift_app/helper/const.dart';
import 'package:drift_app/widgets/custom_button.dart';
import 'package:drift_app/widgets/glass_cont.dart';
import 'package:flutter/material.dart';

void customDialog(BuildContext context, ColorScheme colors) {
  showDialog(
    context: context,
    builder: (dialogContext) => GlassCont(
      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              'About Drift',
              style: TextStyle(
                fontFamily: fontFamily,
                color: colors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            style: TextStyle(fontFamily: fontFamily, color: colors.onSurface),
            'Drift is a ride hailing app',
          ),
          const SizedBox(height: 2),
          Text(
            style: TextStyle(fontFamily: fontFamily, color: colors.onSurface),
            'that lets you book rides, set your own price, and get matched with a driver',
          ),
          const SizedBox(height: 2),
          Text(
            style: TextStyle(fontFamily: fontFamily, color: colors.onSurface),
            'all from a clean, fast interface.',
          ),
          const SizedBox(height: 29),
          CustomButtom(
            backgroundColor: colors.onSurface.withOpacity(0.3),
            text: 'OK',
            borderColor: colors.background,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}


// AlertDialog(
//         title: const 
//         content: 
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),