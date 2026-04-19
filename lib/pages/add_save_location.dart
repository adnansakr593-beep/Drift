// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'dart:convert';
import 'package:drift_app/helper/const.dart';
import 'package:drift_app/models/search_res_model.dart';
import 'package:drift_app/widgets/custom_text_field.dart';
import 'package:drift_app/widgets/tab_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/saved_location_model.dart';
import '../services/saved_locations_service_firebase.dart';

class AddLocationSheet extends StatefulWidget {
  const AddLocationSheet({super.key, required this.service});

  final SavedLocationService service;

  @override
  State<AddLocationSheet> createState() => _AddLocationSheetState();
}

class _AddLocationSheetState extends State<AddLocationSheet> {
  // ── Tab: 0 = Search by name, 1 = Pick from map ─────────────────────────────
  int _tab = 0;

  final _nameCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  final _mapCtrl = MapController();

  LatLng? _pickedPoint;
  String _pickedAddress = '';
  bool _searching = false;
  bool _saving = false;

  List<SearchResultModel> _searchResults = [];

  static const _defaultCenter = LatLng(31.4165, 31.8133);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ══ NOMINATIM SEARCH ══════════════════════════════════════════════════════
  Future<void> _doSearch() async {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) return;
    setState(() {
      _searching = true;
      _searchResults = [];
    });
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(q)}&format=json&limit=5',
      );
      final res = await http.get(
        url,
        headers: {'User-Agent': 'MyFlutterApp/1.0'},
      );
      final data = jsonDecode(res.body) as List;
      setState(() {
        _searchResults = data
            .map(
              (e) => SearchResultModel(
                lat: double.parse(e['lat']),
                lng: double.parse(e['lon']),
                address: e['display_name'] as String,
              ),
            )
            .toList();
      });
    } catch (_) {
    } finally {
      setState(() => _searching = false);
    }
  }

  // ══ REVERSE GEOCODE ═══════════════════════════════════════════════════════
  Future<String> _reverseGeocode(LatLng point) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${point.latitude}&lon=${point.longitude}&format=json',
      );
      final res = await http.get(
        url,
        headers: {'User-Agent': 'MyFlutterApp/1.0'},
      );
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['display_name'] as String? ?? '';
    } catch (_) {
      return '';
    }
  }

  // ══ SAVE TO FIREBASE ══════════════════════════════════════════════════════
  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _showError('Enter name of place first');
      return;
    }
    if (_pickedPoint == null) {
      _showError('pick a place first');
      return;
    }
    setState(() => _saving = true);
    await widget.service.add(
      SavedLocation(
        id: '',
        name: name,
        lat: _pickedPoint!.latitude,
        lng: _pickedPoint!.longitude,
        address: _pickedAddress,
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ══ BUILD ════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(24),
        ),
        height: mq.size.height * 0.85,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ── Handle bar ───────────────────────────────────────────────────
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.onSurface,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Title ────────────────────────────────────────────────────────
            Center(
              child: Text(
                'Add new saved place',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: fontFamily,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Location name input ──────────────────────────────────────────
            CustomTextField(
              controller: _nameCtrl,
              hintText: 'Name of place (like: Home)',
              prefixIcon: const Icon(Icons.label_rounded),
              width: double.infinity,
            ),
            const SizedBox(height: 16),

            // ── Tab switcher ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TabBtn(
                  label: 'Search by name',
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                const SizedBox(width: 28),
                TabBtn(
                  label: 'pick on map',
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Tab content ──────────────────────────────────────────────────
            Expanded(child: _tab == 0 ? _buildSearchTab() : _buildMapTab()),

            // ── Picked location preview ──────────────────────────────────────
            if (_pickedPoint != null) ...[
              const Divider(),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: colors.onSurface,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _pickedAddress.isNotEmpty
                          ? _pickedAddress
                          : '${_pickedPoint!.latitude.toStringAsFixed(4)}, '
                              '${_pickedPoint!.longitude.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurface,
                        fontFamily: fontFamily,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // ── Save button ──────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                label: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        Icons.save_rounded,
                        color: colors.onSurface,
                        size: 20,
                      ),
                icon: Text(
                  'Save place',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 20,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            SizedBox(height: mq.padding.bottom + 12),
          ],
        ),
      ),
    );
  }

  // ══ SEARCH TAB ════════════════════════════════════════════════════════════
  Widget _buildSearchTab() {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _searchCtrl,
                onSubmitted: (_) => _doSearch(),
                hintText: 'Search place',
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: colors.onSurface),
                shape: BoxShape.circle,
                color: colors.background,
              ),
              child: IconButton(
                onPressed: _doSearch,
                icon: Icon(Icons.search, color: colors.onSurface),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_searching)
          const Center(child: CircularProgressIndicator())
        else
          Expanded(
            child: ListView.separated(
              itemCount: _searchResults.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final r = _searchResults[i];
                return ListTile(
                  dense: true,
                  trailing: const Icon(
                    Icons.check_box_outline_blank_rounded,
                    size: 24,
                  ),
                  title: Text(
                    r.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: colors.onSurface),
                  ),
                  // highlight selected result
                  tileColor: _pickedPoint?.latitude == r.lat &&
                          _pickedPoint?.longitude == r.lng
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : null,
                  onTap: () => setState(() {
                    _pickedPoint = LatLng(r.lat, r.lng);
                    _pickedAddress = r.address;
                  }),
                );
              },
            ),
          ),
      ],
    );
  }

  // ══ MAP PICKER TAB ════════════════════════════════════════════════════════
  Widget _buildMapTab() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FlutterMap(
        mapController: _mapCtrl,
        options: MapOptions(
          initialCenter: _pickedPoint ?? _defaultCenter,
          initialZoom: 13,
          onTap: (_, point) async {
            final address = await _reverseGeocode(point);
            setState(() {
              _pickedPoint = point;
              _pickedAddress = address;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'com.example.drift',
          ),
          if (_pickedPoint != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _pickedPoint!,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
