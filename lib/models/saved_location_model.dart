class SavedLocation {
  final String id;       // Firestore document ID
  final String name;     // اسم المكان اللي كتبه اليوزر (Home, Work, ...)
  final double lat;
  final double lng;
  final String address;  // العنوان النصي اللي رجع من Nominatim

  const SavedLocation({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.address,
  });

  // ── Firestore → Model ───────────────────────────────────────────────────────
  factory SavedLocation.fromMap(String id, Map<String, dynamic> map) {
    return SavedLocation(
      id: id,
      name: map['name'] as String,
      lat: (map['lat'] as num).toDouble(),
      lng: (map['lng'] as num).toDouble(),
      address: map['address'] as String? ?? '',
    );
  }

  // ── Model → Firestore ───────────────────────────────────────────────────────
  Map<String, dynamic> toMap() => {
        'name': name,
        'lat': lat,
        'lng': lng,
        'address': address,
      };
}