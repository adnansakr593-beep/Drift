 import 'package:drift_app/pages/add_save_location.dart';
import 'package:drift_app/services/saved_locations_service_firebase.dart';
import 'package:flutter/material.dart';

void openAddSheet(BuildContext context,SavedLocationService savedService) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddLocationSheet(service: savedService),
    );
  }