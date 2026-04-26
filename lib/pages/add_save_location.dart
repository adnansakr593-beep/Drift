// ignore_for_file: deprecated_member_use, unnecessary_underscores
import 'dart:async';
import 'dart:convert';
import 'package:drift_app/classes/place_suggestion.dart';
import 'package:drift_app/helper/const.dart';
import 'package:drift_app/widgets/custom_search_bar.dart';
import 'package:drift_app/widgets/custom_text_field.dart';
import 'package:drift_app/widgets/drawer_lists.dart';
import 'package:drift_app/widgets/suggestions.dart';
import 'package:drift_app/widgets/tab_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../models/saved_location_model.dart';
import '../services/saved_locations_service_firebase.dart';

class AddLocationSheet extends StatefulWidget {
  const AddLocationSheet({
    super.key,
    required this.service,
    this.editLocation,
  });

  final SavedLocationService service;
  final SavedLocation? editLocation;

  @override
  State<AddLocationSheet> createState() => _AddLocationSheetState();
}

class _AddLocationSheetState extends State<AddLocationSheet> {
  int _tab = 0;

  final _nameCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  final _mapCtrl = MapController();

  LatLng? _pickedPoint;
  String _pickedAddress = '';

  bool _saving = false;

  List<PlaceSuggestion> _searchSuggestions = [];
  bool _searchLoading = false;
  bool _showSuggestions = false;

  Timer? _debounce;

  static const _defaultCenter = LatLng(31.4165, 31.8133);

  bool get isEditMode => widget.editLocation != null;

  @override
  void initState() {
    super.initState();

    if (isEditMode) {
      final loc = widget.editLocation!;

      _nameCtrl.text = loc.name;

      // show previous place in search field
      _searchCtrl.text = loc.address.split(',').first;

      _pickedPoint = LatLng(
        loc.lat,
        loc.lng,
      );

      _pickedAddress = loc.address;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    if (value.trim().length < 2) {
      setState(() {
        _searchSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    _debounce = Timer(
      const Duration(
        milliseconds: 450,
      ),
      () {
        _fetchSuggestions(
          value.trim(),
        );
      },
    );
  }

  Future<void> _fetchSuggestions(
    String query,
  ) async {
    setState(() {
      _searchLoading = true;
    });

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}'
        '&format=json'
        '&limit=5'
        '&addressdetails=1',
      );

      final res = await http.get(
        url,
        headers: {
          'User-Agent': 'DriftApp/1.0',
        },
      );

      final data = jsonDecode(
        res.body,
      ) as List;

      if (!mounted) return;

      setState(() {
        _searchSuggestions = data.map((e) {
          final addr = e['address'] as Map? ?? {};

          final shortName = addr['city'] ??
              addr['town'] ??
              addr['village'] ??
              addr['county'] ??
              (e['display_name'] as String?)?.split(',').first ??
              '';

          return PlaceSuggestion(
            displayName: e['display_name'] ?? '',
            shortName: shortName,
            lat: double.parse(
              e['lat'],
            ),
            lon: double.parse(
              e['lon'],
            ),
          );
        }).toList();

        _showSuggestions = true;
        _searchLoading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _searchLoading = false;
        });
      }
    }
  }

  void _selectSuggestion(
    PlaceSuggestion place,
  ) {
    setState(() {
      _searchCtrl.text = place.shortName;

      _pickedPoint = LatLng(
        place.lat,
        place.lon,
      );

      _pickedAddress = place.displayName;

      _showSuggestions = false;
      _searchSuggestions = [];
    });

    if (_tab == 1) {
      _mapCtrl.move(
        _pickedPoint!,
        15,
      );
    }
  }

  Future<String> _reverseGeocode(
    LatLng point,
  ) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${point.latitude}'
        '&lon=${point.longitude}'
        '&format=json',
      );

      final res = await http.get(
        url,
        headers: {
          'User-Agent': 'DriftApp/1.0',
        },
      );

      final data = jsonDecode(res.body) as Map<String, dynamic>;

      return data['display_name'] as String? ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();

    if (name.isEmpty) {
      _showError(
        'Enter name of place first',
      );
      return;
    }

    if (_pickedPoint == null) {
      _showError(
        'Pick a place first',
      );
      return;
    }

    try {
      setState(() {
        _saving = true;
      });

      if (isEditMode) {
        await widget.service.update(
          SavedLocation(
            id: widget.editLocation!.id,
            name: name,
            lat: _pickedPoint!.latitude,
            lng: _pickedPoint!.longitude,
            address: _pickedAddress,
          ),
        );
      } else {
        await widget.service.add(
          SavedLocation(
            id: '',
            name: name,
            lat: _pickedPoint!.latitude,
            lng: _pickedPoint!.longitude,
            address: _pickedAddress,
          ),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode
                ? 'Location updated successfully'
                : 'Location saved successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (_) {
      _showError(
        'Failed saving location',
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  void _showError(
    String msg,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final colors = Theme.of(context).colorScheme;

    final mq = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: mq.viewInsets.bottom,
        ),
        child: Container(
          height: mq.size.height * .85,
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            0,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: colors.background, blurStyle: BlurStyle.inner),
            ],
            borderRadius: BorderRadius.circular(25),
            color: Colors.white.withOpacity(0.05),
            border: Border(
              top: BorderSide(
                  color: colors.onSurface.withOpacity(0.4), width: 1),
              right: BorderSide(
                  color: colors.onSurface.withOpacity(0.4), width: 1),
              left: BorderSide(
                  color: colors.onSurface.withOpacity(0.4), width: 1),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.onSurface,
                  borderRadius: BorderRadius.circular(
                    4,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                isEditMode ? 'Edit saved place' : 'Add new saved place',
                style: const TextStyle(
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                filled: false,
                hintSize: 15,
                controller: _nameCtrl,
                hintText: 'Name of place',
                prefixIcon: const Icon(
                  Icons.label,
                  size: 20,
                ),
                width: double.infinity,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: TabBtn(
                      label: 'Search by name',
                      selected: _tab == 0,
                      onTap: () {
                        setState(() {
                          _tab = 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TabBtn(
                      label: 'Pick on map',
                      selected: _tab == 1,
                      onTap: () {
                        setState(() {
                          _tab = 1;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: _tab == 0 ? _buildSearchTab() : _buildMapTab(),
              ),
              if (_pickedPoint != null) ...[
                const Divider(),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    // overflow fixed here
                    Expanded(
                      child: Text(
                        _pickedAddress.isNotEmpty
                            ? _pickedAddress
                            : '${_pickedPoint!.latitude}, ${_pickedPoint!.longitude}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(
                width: double.infinity,
                child: DrawerLists(
                  mainAxisAlignment: MainAxisAlignment.center,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  sizedBoxWidth: 10,
                  onTap: _saving ? null : _save,
                  title: isEditMode ? 'Update place' : 'Save place',
                  icon: _saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.save,
                        ),
                ),
              ),
              SizedBox(
                height: mq.padding.bottom + 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTab() {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        CustomSearchBar(
          hintColor: colors.onSurface,
          iconColor: colors.onSurface,
          borderWidth: 2,
          borderColor: colors.onSurface.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          citySearchController: _searchCtrl,
          loadingSearch: _searchLoading,
          selectedCity: null,
          hintText: 'Search city...',
          onChanged: _onSearchChanged,
          onPressed: () {
            setState(() {
              _searchCtrl.clear();
              _searchSuggestions = [];
              _showSuggestions = false;
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        if (_showSuggestions && _searchSuggestions.isNotEmpty)
          Suggestions(
            suggestions: _searchSuggestions,
            onTap: _selectSuggestion,
          ),
        if (!_showSuggestions && _pickedPoint != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: Text(
              _pickedAddress,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMapTab() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        16,
      ),
      child: FlutterMap(
        mapController: _mapCtrl,
        options: MapOptions(
          initialCenter: _pickedPoint ?? _defaultCenter,
          initialZoom: 13,
          onTap: (_, point) async {
            final address = await _reverseGeocode(
              point,
            );

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
