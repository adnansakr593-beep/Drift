import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift_app/models/saved_location_model.dart';

// ══ HOW FIRESTORE IS STRUCTURED ═══════════════════════════════════════════════
//
//  users/
//   └── {userId}/
//        └── saved_locations/
//             ├── {docId}  →  { name, lat, lng, address }
//             └── {docId}  →  { name, lat, lng, address }
//
// ══════════════════════════════════════════════════════════════════════════════

class SavedLocationService {
  SavedLocationService({required this.userId});

  final String userId;

  // shortcut to the sub-collection
  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('saved_locations');

  // ── READ: real-time stream ──────────────────────────────────────────────────
  Stream<List<SavedLocation>> stream() {
    return _col.snapshots().map(
      (snap) =>
          snap.docs.map((d) => SavedLocation.fromMap(d.id, d.data())).toList(),
    );
  }

  // ── CREATE ──────────────────────────────────────────────────────────────────
  Future<void> add(SavedLocation location) async {
    await _col.add(location.toMap());
  }

  // ── UPDATE ──────────────────────────────────────────────────────────────────
  Future<void> update(SavedLocation location) async {
    await _col.doc(location.id).update(location.toMap());
  }

  // ── DELETE ──────────────────────────────────────────────────────────────────
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
