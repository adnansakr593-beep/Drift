// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:convert';
import 'package:drift_app/classes/mode_info.dart';
import 'package:drift_app/classes/place_suggestion.dart';
import 'package:drift_app/widgets/build_handle.dart';
import 'package:drift_app/widgets/custom_search_bar.dart';
import 'package:drift_app/widgets/glass_cont.dart';
import 'package:drift_app/widgets/mode_tabs.dart';
import 'package:drift_app/widgets/price_editor.dart';
import 'package:drift_app/widgets/route_info.dart';
import 'package:drift_app/widgets/start_button.dart';
import 'package:drift_app/widgets/suggestions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

enum TripMode { ride, cityToCity, delivery, takeMeOut }

enum TripState { idle, searchingDriver, driverFound }

class TripBottomSheet extends StatefulWidget {
  final LatLng? myLocation;
  final Function(LatLng destination, String cityName) onDestinationSelected;
  final VoidCallback onClear;

  const TripBottomSheet({
    super.key,
    required this.myLocation,
    required this.onDestinationSelected,
    required this.onClear,
  });

  @override
  State<TripBottomSheet> createState() => TripBottomSheetState();
}

class TripBottomSheetState extends State<TripBottomSheet>
    with TickerProviderStateMixin {
  TripMode selectedMode = TripMode.ride;
  TripState tripState = TripState.idle;

  final TextEditingController citySearchController = TextEditingController();
  List<PlaceSuggestion> suggestions = [];
  bool loadingSearch = false;
  bool _showSuggestions = false;
  Timer? _debounce;

  String? selectedCity;
  double price = 0;
  double basePriceKm = 3.5;
  double? routeDistanceKm;
  double? routeDurationMin;
  bool _hasRoute = false;

  // ignore: unused_field
  int _driversFound = 0;
  Timer? _driverSearchTimer;
  late AnimationController pulseController;
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  static const Map<TripMode, ModeInfo> modeInfo = {
    TripMode.ride: ModeInfo(
      icon: Icons.directions_car_rounded,
      label: 'Ride',
      color: Color(0xFF6C63FF),
    ),
    TripMode.cityToCity: ModeInfo(
      icon: Icons.route_rounded,
      label: 'City to City',
      color: Color(0xFF00C9A7),
    ),
    TripMode.delivery: ModeInfo(
      icon: Icons.delivery_dining_rounded,
      label: 'Delivery',
      color: Color(0xFFFF6B6B),
    ),
    TripMode.takeMeOut: ModeInfo(
      icon: Icons.explore_rounded,
      label: 'Take Me Out',
      color: Color(0xFFFFBE0B),
    ),
  };

  @override
  void initState() {
    super.initState();
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _driverSearchTimer?.cancel();
    pulseController.dispose();
    _slideController.dispose();
    citySearchController.dispose();
    super.dispose();
  }

  // ══ SEARCH ════════════════════════════════════════════════════════════════
  void onSearchChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() {
        suggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _fetchSuggestions(value.trim());
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() => loadingSearch = true);
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}&format=json&limit=5&addressdetails=1',
      );
      final res = await http.get(url, headers: {'User-Agent': 'DriftApp/1.0'});
      final data = jsonDecode(res.body) as List;
      setState(() {
        suggestions = data
            .map(
              (e) => PlaceSuggestion(
                displayName: e['display_name'] ?? '',
                shortName: _shortName(e),
                lat: double.parse(e['lat']),
                lon: double.parse(e['lon']),
              ),
            )
            .toList();
        _showSuggestions = true;
        loadingSearch = false;
      });
    } catch (_) {
      setState(() => loadingSearch = false);
    }
  }

  String _shortName(Map e) {
    final addr = e['address'] as Map? ?? {};
    return addr['city'] ??
        addr['town'] ??
        addr['village'] ??
        addr['county'] ??
        e['display_name']?.toString().split(',').first ??
        '';
  }

  void selectPlace(PlaceSuggestion place) {
    setState(() {
      selectedCity = place.shortName;
      citySearchController.text = place.shortName;
      _showSuggestions = false;
      suggestions = [];
    });
    widget.onDestinationSelected(LatLng(place.lat, place.lon), place.shortName);
    _expandSheet();
  }

  void _expandSheet() {
    _sheetController.animateTo(
      0.55,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  // ══ ROUTE & PRICE ════════════════════════════════════════════════════════
  void updateRouteInfo({required double distanceKm, required double durationMin}) {
    final base = _basePriceForMode(selectedMode);
    setState(() {
      routeDistanceKm = distanceKm;
      routeDurationMin = durationMin;
      basePriceKm = base;
      price = (distanceKm * base).clamp(25, 9999);
      _hasRoute = true;
    });
    _slideController.forward(from: 0);
  }

  double _basePriceForMode(TripMode mode) => switch (mode) {
        TripMode.ride => 3.5,
        TripMode.cityToCity => 5.0,
        TripMode.delivery => 4.0,
        TripMode.takeMeOut => 6.0,
      };

  void clearRoute() {
    setState(() {
      _hasRoute = false;
      selectedCity = null;
      citySearchController.clear();
      tripState = TripState.idle;
      _driversFound = 0;
      price = 0;
    });
    _slideController.reverse();
    _driverSearchTimer?.cancel();
    widget.onClear();
  }

  // ══ PRICE — blocked while searching for driver ════════════════════════════
  void adjustPrice(double delta) {
    if (tripState != TripState.idle) return; // 🔒 locked
    setState(() => price = (price + delta).clamp(30, 9999));
  }

  // ══ TRIP ══════════════════════════════════════════════════════════════════
  void startTrip() {
    setState(() {
      tripState = TripState.searchingDriver;
      _driversFound = 0;
    });
    _expandSheet();

    int elapsed = 0;
    _driverSearchTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      elapsed += 2;
      if (!mounted) { t.cancel(); return; }
      if (elapsed >= 4 && (elapsed >= 14 || _randomBool(elapsed))) {
        t.cancel();
        setState(() {
          tripState = TripState.driverFound;
          _driversFound = 5;
        });
      }
    });
  }

  bool _randomBool(int elapsed) {
    final chance = (elapsed - 2) / 14.0;
    return (DateTime.now().millisecondsSinceEpoch % 100) / 100.0 < chance;
  }

  void cancelSearch() {
    _driverSearchTimer?.cancel();
    setState(() {
      tripState = TripState.idle; // 🔓 unlocks price editor
      _driversFound = 0;
    });
  }

  // ══ BUILD ════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final priceEditable = tripState == TripState.idle;

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.22,
      minChildSize: 0.14,
      maxChildSize: 0.82,
      snap: true,
      snapSizes: const [0.22, 0.45, 0.82],
      builder: (context, scrollController) {
        return GlassCont(
          top: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
          right: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
          left: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              const BuildHandle(),

              ModeTabs(
                modeInfo: modeInfo,
                selectedMode: selectedMode,
                onTap: (mode) {
                  setState(() => selectedMode = mode);
                  if (_hasRoute && routeDistanceKm != null) {
                    updateRouteInfo(
                      distanceKm: routeDistanceKm!,
                      durationMin: routeDurationMin ?? 0,
                    );
                  }
                },
              ),

              const SizedBox(height: 12),

              CustomSearchBar(
                citySearchController: citySearchController,
                loadingSearch: loadingSearch,
                hintText: hintText,
                selectedCity: selectedCity,
                onChanged: onSearchChanged,
                onPressed: clearRoute,
              ),

              // ✅ Suggestions with per-item callback
              if (_showSuggestions)
                Suggestions(
                  suggestions: suggestions,
                  onTap: (place) => selectPlace(place),
                ),

              if (_hasRoute && !_showSuggestions) ...[
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_slideAnimation),
                  child: FadeTransition(
                    opacity: _slideAnimation,
                    child: Column(
                      children: [
                        RouteInfo(
                          mode: modeInfo[selectedMode]!,
                          selectedCity: selectedCity,
                          routeDistanceKm: routeDistanceKm,
                          routeDurationMin: routeDurationMin,
                        ),

                        // ✅ Locked (faded, no arrows) while searchingDriver
                        PriceEditor(
                          price: price,
                          basePriceKm: basePriceKm,
                          onTapPluse: () => adjustPrice(5),
                          onTapminse: () => adjustPrice(-5),
                          mode: modeInfo[selectedMode]!,
                          enabled: priceEditable,
                        ),

                        StartButton(
                          tripState: tripState,
                          modeInfo: modeInfo,
                          selectedMode: selectedMode,
                          pulseController: pulseController,
                          price: price,
                          onTapSearchinDriver: cancelSearch,
                          onTapDriverFound: clearRoute,
                          onTapStrartTrip: startTrip,
                          mode: modeInfo[selectedMode]!,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String get hintText => switch (selectedMode) {
        TripMode.ride => 'Where to?',
        TripMode.cityToCity => 'Destination city...',
        TripMode.delivery => 'Delivery address...',
        TripMode.takeMeOut => 'Surprise me... or pick a city',
      };
}