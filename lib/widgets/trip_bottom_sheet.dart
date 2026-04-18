// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:convert';
import 'package:drift_app/helper/const.dart';
import 'package:drift_app/widgets/glass_cont.dart';
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
  TripMode _selectedMode = TripMode.ride;
  TripState _tripState = TripState.idle;

  final TextEditingController _citySearchController = TextEditingController();
  List<_PlaceSuggestion> _suggestions = [];
  bool _loadingSearch = false;
  bool _showSuggestions = false;
  Timer? _debounce;

  // Route info
  String? _selectedCity;
  double _price = 0;
  double _basePriceKm = 3.5; // EGP per km
  double? _routeDistanceKm;
  double? _routeDurationMin;
  bool _hasRoute = false;

  // Driver search
  // ignore: unused_field
  int _driversFound = 0;
  Timer? _driverSearchTimer;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  static const Map<TripMode, _ModeInfo> _modeInfo = {
    TripMode.ride: _ModeInfo(
      icon: Icons.directions_car_rounded,
      label: 'Ride',
      color: Color(0xFF6C63FF),
    ),
    TripMode.cityToCity: _ModeInfo(
      icon: Icons.route_rounded,
      label: 'City to City',
      color: Color(0xFF00C9A7),
    ),
    TripMode.delivery: _ModeInfo(
      icon: Icons.delivery_dining_rounded,
      label: 'Delivery',
      color: Color(0xFFFF6B6B),
    ),
    TripMode.takeMeOut: _ModeInfo(
      icon: Icons.explore_rounded,
      label: 'Take Me Out',
      color: Color(0xFFFFBE0B),
    ),
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
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
    _pulseController.dispose();
    _slideController.dispose();
    _citySearchController.dispose();
    super.dispose();
  }

  // ══ SEARCH ════════════════════════════════════════════════════════════════
  void _onSearchChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _fetchSuggestions(value.trim());
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() => _loadingSearch = true);
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}&format=json&limit=5&addressdetails=1',
      );
      final res = await http.get(url, headers: {'User-Agent': 'DriftApp/1.0'});
      final data = jsonDecode(res.body) as List;
      setState(() {
        _suggestions = data
            .map(
              (e) => _PlaceSuggestion(
                displayName: e['display_name'] ?? '',
                shortName: _shortName(e),
                lat: double.parse(e['lat']),
                lon: double.parse(e['lon']),
              ),
            )
            .toList();
        _showSuggestions = true;
        _loadingSearch = false;
      });
    } catch (_) {
      setState(() => _loadingSearch = false);
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

  void _selectPlace(_PlaceSuggestion place) {
    setState(() {
      _selectedCity = place.shortName;
      _citySearchController.text = place.shortName;
      _showSuggestions = false;
      _suggestions = [];
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
  void updateRouteInfo({
    required double distanceKm,
    required double durationMin,
  }) {
    final base = switch (_selectedMode) {
      TripMode.ride => 3.5,
      TripMode.cityToCity => 5.0,
      TripMode.delivery => 4.0,
      TripMode.takeMeOut => 6.0,
    };
    setState(() {
      _routeDistanceKm = distanceKm;
      _routeDurationMin = durationMin;
      _basePriceKm = base;
      _price = (distanceKm * base).clamp(25, 9999);
      _hasRoute = true;
    });
    _slideController.forward(from: 0);
  }

  void clearRoute() {
    setState(() {
      _hasRoute = false;
      _selectedCity = null;
      _citySearchController.clear();
      _tripState = TripState.idle;
      _driversFound = 0;
      _price = 0;
    });
    _slideController.reverse();
    _driverSearchTimer?.cancel();
    widget.onClear();
  }

  // ══ PRICE EDIT ═══════════════════════════════════════════════════════════
  void _adjustPrice(double delta) {
    setState(() {
      _price = (_price + delta).clamp(10, 9999);
    });
  }

  // ══ START TRIP ═══════════════════════════════════════════════════════════
  void _startTrip() {
    setState(() {
      _tripState = TripState.searchingDriver;
      _driversFound = 0;
    });
    _expandSheet();

    // Simulate finding drivers progressively
    int elapsed = 0;
    _driverSearchTimer = Timer.periodic(const Duration(seconds: 2), (t) {
      elapsed += 2;
      if (!mounted) {
        t.cancel();
        return;
      }

      // Randomly find a driver between 4–14 seconds
      if (elapsed >= 4 && (elapsed >= 14 || _randomBool(elapsed))) {
        t.cancel();
        setState(() {
          _tripState = TripState.driverFound;
          _driversFound = 1;
        });
      }
    });
  }

  bool _randomBool(int elapsed) {
    // Probability increases with time
    final chance = (elapsed - 2) / 14.0;
    return (DateTime.now().millisecondsSinceEpoch % 100) / 100.0 < chance;
  }

  void _cancelSearch() {
    _driverSearchTimer?.cancel();
    setState(() {
      _tripState = TripState.idle;
      _driversFound = 0;
    });
  }

  // ══ BUILD ════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
              _buildHandle(colors),
              _buildModeTabs(colors),
              const SizedBox(height: 12),
              _buildSearchBar(colors),
              if (_showSuggestions) _buildSuggestions(colors),
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
                        _buildRouteInfo(colors),
                        _buildPriceEditor(colors),
                        _buildStartButton(colors),
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

  Widget _buildHandle(ColorScheme colors) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: colors.onSurface.withOpacity(0.2),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildModeTabs(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: TripMode.values.map((mode) {
          final info = _modeInfo[mode]!;
          final selected = _selectedMode == mode;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedMode = mode);
                if (_hasRoute) {
                  updateRouteInfo(
                    distanceKm: _routeDistanceKm ?? 0,
                    durationMin: _routeDurationMin ?? 0,
                  );
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? info.color.withOpacity(0.15)
                      : colors.surfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? info.color : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      info.icon,
                      color: selected
                          ? info.color
                          : colors.onSurface.withOpacity(0.45),
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: selected
                            ? info.color
                            : colors.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.onSurface.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(
              Icons.search_rounded,
              color: colors.onSurface.withOpacity(0.4),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _citySearchController,
                onChanged: _onSearchChanged,
                style: TextStyle(color: colors.onSurface, fontSize: 15),
                decoration: InputDecoration(
                  hintText: _hintText,
                  hintStyle: TextStyle(
                    color: colors.onSurface.withOpacity(0.35),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            if (_loadingSearch)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.primary,
                  ),
                ),
              )
            else if (_selectedCity != null)
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: colors.onSurface.withOpacity(0.4),
                  size: 18,
                ),
                onPressed: clearRoute,
              ),
          ],
        ),
      ),
    );
  }

  String get _hintText {
    return switch (_selectedMode) {
      TripMode.ride => 'Where to?',
      TripMode.cityToCity => 'Destination city...',
      TripMode.delivery => 'Delivery address...',
      TripMode.takeMeOut => 'Surprise me... or pick a city',
    };
  }

  Widget _buildSuggestions(ColorScheme colors) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.onSurface.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: _suggestions.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            return InkWell(
              onTap: () => _selectPlace(s),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  border: i < _suggestions.length - 1
                      ? Border(
                          bottom: BorderSide(
                            color: colors.onSurface.withOpacity(0.07),
                          ),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.place_rounded,
                        color: colors.primary,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.shortName,
                            style: TextStyle(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            s.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.onSurface.withOpacity(0.45),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRouteInfo(ColorScheme colors) {
    final mode = _modeInfo[_selectedMode]!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mode.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: mode.color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(mode.icon, color: mode.color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCity ?? '',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_routeDistanceKm?.toStringAsFixed(1) ?? '--'} km  •  ${_routeDurationMin?.toStringAsFixed(0) ?? '--'} min',
                  style: TextStyle(
                    color: colors.onSurface.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: mode.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              mode.label,
              style: TextStyle(
                color: mode.color,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceEditor(ColorScheme colors) {
    final mode = _modeInfo[_selectedMode]!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.onSurface.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offer Price',
                  style: TextStyle(
                    color: colors.onSurface.withOpacity(0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'EGP ${_price.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  '${_basePriceKm.toStringAsFixed(1)} EGP/km  •  tap ↑↓ to adjust',
                  style: TextStyle(
                    color: colors.onSurface.withOpacity(0.35),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _PriceArrowBtn(
                icon: Icons.keyboard_arrow_up_rounded,
                color: mode.color,
                onTap: () => _adjustPrice(5),
              ),
              const SizedBox(height: 6),
              _PriceArrowBtn(
                icon: Icons.keyboard_arrow_down_rounded,
                color: Colors.redAccent,
                onTap: () => _adjustPrice(-5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(ColorScheme colors) {
    if (_tripState == TripState.searchingDriver) {
      return _buildSearchingDriverUI(colors);
    }
    if (_tripState == TripState.driverFound) {
      return _buildDriverFoundUI(colors);
    }

    final mode = _modeInfo[_selectedMode]!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: GestureDetector(
        onTap: _startTrip,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [mode.color, mode.color.withOpacity(0.75)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: mode.color.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_taxi_rounded, color: Colors.white, size: 22),
              SizedBox(width: 10),
              Text(
                'Start Trip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchingDriverUI(ColorScheme colors) {
    final mode = _modeInfo[_selectedMode]!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            // ignore: unnecessary_underscores
            builder: (_, __) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: mode.color.withOpacity(
                    0.08 + _pulseController.value * 0.07,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: mode.color.withOpacity(
                      0.3 + _pulseController.value * 0.3,
                    ),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: mode.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Searching for drivers nearby...',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Offer: EGP ${_price.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: mode.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _cancelSearch,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: const Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverFoundUI(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF00C9A7).withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF00C9A7).withOpacity(0.4)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF00C9A7),
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              'Driver Found!',
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your driver is on the way',
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF00C9A7),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adnan Sakr',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontFamily,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '⭐ 5.0 • Toyota Supra • SAk 272',
                      style: TextStyle(
                        color: colors.onSurface.withOpacity(0.5),
                        fontSize: 12,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // call driver action
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C9A7).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call_rounded,
                            color: Color(0xFF00C9A7),
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Call',
                            style: TextStyle(
                              color: Color(0xFF00C9A7),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: clearRoute,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close_rounded,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ────────────────────────────────────────────────────────────────────

class _PlaceSuggestion {
  final String displayName;
  final String shortName;
  final double lat;
  final double lon;
  const _PlaceSuggestion({
    required this.displayName,
    required this.shortName,
    required this.lat,
    required this.lon,
  });
}

class _ModeInfo {
  final IconData icon;
  final String label;
  final Color color;
  const _ModeInfo({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _PriceArrowBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _PriceArrowBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
