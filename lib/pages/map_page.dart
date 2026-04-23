// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:convert';
import 'package:drift_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:drift_app/cubits/theme_cubit/theme_state.dart';
import 'package:drift_app/services/saved_locations_service_firebase.dart';
import 'package:drift_app/widgets/custom_drawer.dart';
import 'package:drift_app/widgets/custom_text_field.dart';
import 'package:drift_app/widgets/fab_btn.dart';
import 'package:drift_app/widgets/loading_pill.dart';
import 'package:drift_app/widgets/mini_cards.dart';
import 'package:drift_app/widgets/trip_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/route_info.dart';
import '../models/saved_location_model.dart';
import '../pages/add_save_location.dart';
import '../services/location_service.dart';
import '../services/routing_service.dart';
import '../widgets/map_markers.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  static String id = 'map page';

  static String get userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapCtrl = MapController();

  LatLng? _myLocation;
  LatLng? _destination;
  RouteInfo? _route;
  bool _loadingGPS = true;
  bool _loadingRoute = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<TripBottomSheetState> _tripSheetKey =
      GlobalKey<TripBottomSheetState>();

  StreamSubscription? _gpsSub;
  final TextEditingController _searchController = TextEditingController();
  List<Marker> _markers = [];
  late String mapMode;
  String _tileUrl =
      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';

  late final SavedLocationService _savedService = SavedLocationService(
    userId: MapPage.userId,
  );

  @override
  void initState() {
    super.initState();
    _initGPS();
  }

  @override
  void dispose() {
    _gpsSub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // ══ GPS ════════════════════════════════════════════════════════════════════
  Future<void> _initGPS() async {
    try {
      final loc = await LocationService.getCurrentLocation();
      if (!mounted) return;
      setState(() {
        _myLocation = loc;
        _loadingGPS = false;
      });
      _mapCtrl.move(loc, 17);
      _gpsSub = LocationService.getStream().listen((loc) {
        if (mounted) setState(() => _myLocation = loc);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingGPS = false;
        _myLocation = const LatLng(30.0444, 31.2357);
      });
      _mapCtrl.move(_myLocation!, 12);
      _showError(e.toString());
    }
  }

  // ══ SEARCH (top bar) ══════════════════════════════════════════════════════
  Future<LatLng?> searchPlace(String query) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=${Uri.encodeComponent(query)}&format=json&limit=1',
    );
    final response = await http.get(
      url,
      headers: {'User-Agent': 'MyFlutterApp/1.0'},
    );
    final data = jsonDecode(response.body) as List;
    if (data.isEmpty) return null;
    return LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
  }

  Future<void> _search() async {
    final result = await searchPlace(_searchController.text);
    if (result == null) return;
    setState(() {
      _markers = [
        Marker(
          point: result,
          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
      ];
    });
    _mapCtrl.move(result, 15);
  }

  // ══ MAP TAP → ROUTE ═══════════════════════════════════════════════════════
  Future<void> _onMapTap(TapPosition _, LatLng point) async {
    if (_loadingRoute || _myLocation == null) return;
    setState(() {
      _destination = point;
      _route = null;
      _loadingRoute = true;
    });
    try {
      final route = await RoutingService.getRoute(
        origin: _myLocation!,
        destination: point,
      );
      if (!mounted) return;
      setState(() {
        _route = route;
        _loadingRoute = false;
      });
      _mapCtrl.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(route.points),
          padding: const EdgeInsets.all(60),
        ),
      );

      // 👇 Notify the trip sheet about the new route
      final distKm = route.distanceMeters / 1000;
      final durMin = route.durationSeconds / 60;
      _tripSheetKey.currentState?.updateRouteInfo(
        distanceKm: distKm,
        durationMin: durMin,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingRoute = false);
      _showError('فشل في جلب المسار');
    }
  }

  // ══ TRIP SHEET: destination selected ═════════════════════════════════════
  Future<void> _onTripDestinationSelected(LatLng point, String cityName) async {
    if (_myLocation == null) {
      _mapCtrl.move(point, 13);
      return;
    }
    setState(() {
      _destination = point;
      _route = null;
      _loadingRoute = true;
      _markers = [];
    });
    try {
      final route = await RoutingService.getRoute(
        origin: _myLocation!,
        destination: point,
      );
      if (!mounted) return;
      setState(() {
        _route = route;
        _loadingRoute = false;
      });
      _mapCtrl.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(route.points),
          padding: const EdgeInsets.all(60),
        ),
      );

      // Update trip sheet with route info
      final distKm = route.distanceMeters / 1000;
      final durMin = route.durationSeconds / 60;
      _tripSheetKey.currentState?.updateRouteInfo(
        distanceKm: distKm,
        durationMin: durMin,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingRoute = false);
      _showError('فشل في جلب المسار');
    }
  }

  // ══ MINI CARD TAP → ROUTE ═════════════════════════════════════════════════
  Future<void> _goToSaved(SavedLocation loc) async {
    final point = LatLng(loc.lat, loc.lng);
    if (_myLocation == null) {
      _mapCtrl.move(point, 15);
      return;
    }
    setState(() {
      _destination = point;
      _route = null;
      _loadingRoute = true;
      _markers = [];
    });
    try {
      final route = await RoutingService.getRoute(
        origin: _myLocation!,
        destination: point,
      );
      if (!mounted) return;
      setState(() {
        _route = route;
        _loadingRoute = false;
      });
      _mapCtrl.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(route.points),
          padding: const EdgeInsets.all(60),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingRoute = false);
      _showError('Route failed: ${e.toString()}');
    }
  }

  // ══ OPEN ADD LOCATION SHEET ═══════════════════════════════════════════════
  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddLocationSheet(service: _savedService),
    );
  }

  void _clearRoute() {
    setState(() {
      _destination = null;
      _route = null;
      _markers = [];
    });
    _tripSheetKey.currentState?.clearRoute();
    if (_myLocation != null) _mapCtrl.move(_myLocation!, 15);
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
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final topPad = MediaQuery.of(context).padding.top;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          // ══ MAP ══════════════════════════════════════
          FlutterMap(
            mapController: _mapCtrl,
            options: MapOptions(
              initialCenter: const LatLng(30.0444, 31.2357),
              initialZoom: 12,
              minZoom: 5,
              maxZoom: 19,
              onTap: _onMapTap,
            ),
            children: [
              BlocListener<ThemeCubit, ThemeState>(
                listener: (context, state) {
                  if (state.themeMode == ThemeMode.light) {
                    setState(() {
                      _tileUrl =
                          'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';
                    });
                  } else {
                    _tileUrl =
                        'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
                  }
                },
                child: TileLayer(
                  urlTemplate: _tileUrl,
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.example.drift',
                  maxZoom: 19,
                ),
              ),
              if (_route != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _route!.points,
                      strokeWidth: 8,
                      color: colors.primary,
                      borderStrokeWidth: 2,
                      borderColor: Colors.white.withOpacity(0.6),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (_myLocation != null)
                    Marker(
                      point: _myLocation!,
                      width: 44,
                      height: 44,
                      child: const UserLocationMarker(),
                    ),
                  if (_destination != null)
                    Marker(
                      point: _destination!,
                      width: 44,
                      height: 44,
                      child: const DestinationMarker(),
                    ),
                  ..._markers,
                ],
              ),
            ],
          ),

          // ══ GPS LOADING ══════════════════════════════
          if (_loadingGPS)
            ColoredBox(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: colors.primary),
                    const SizedBox(height: 14),
                    Text(
                      'جاري تحديد موقعك...',
                      style: TextStyle(fontSize: 15, color: colors.onSurface),
                    ),
                  ],
                ),
              ),
            ),

          // ══ SEARCH BAR + MINI CARDS ═══════════════════
          Positioned(
            top: topPad + 10,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _searchController,
                        hintText: 'Search City...',
                        hintSize: 18,
                        fillColor: colors.background,
                        suffixIcon: IconButton(
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.search, color: colors.onSurface),
                          ),
                          onPressed: () => _search(),
                        ),
                        onSubmitted: (context) => _search(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          // ← fixed (was BoxBorder.all)
                          color: colors.onSurface.withOpacity(0.6),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                        color: colors.background,
                      ),
                      child: IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                        icon: Icon(Icons.menu_rounded, color: colors.onSurface),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ── Mini Cards (Firebase real-time) ──────────────────────────
                StreamBuilder<List<SavedLocation>>(
                  stream: _savedService.stream(),
                  builder: (context, snapshot) {
                    final locations = snapshot.data ?? [];
                    if (locations.isEmpty) return const SizedBox.shrink();
                    return SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: locations.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => MiniCard(
                          label: locations[i].name,
                          onTap: () => _goToSaved(locations[i]),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // ══ MAP STYLE BUTTONS ════════════════════════
          Positioned(
            bottom: 200, // raised to sit above the bottom sheet
            right: 16,
            child: Column(
              children: [
                FabBtn(
                  icon: Icons.light_mode,
                  color: colors.onSurface,
                  onTap: () => setState(
                    () => _tileUrl =
                        'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  ),
                ),
                const SizedBox(height: 8),
                FabBtn(
                  icon: Icons.dark_mode,
                  color: colors.onSurface,
                  onTap: () => setState(
                    () => _tileUrl =
                        'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                  ),
                ),
                const SizedBox(height: 8),
                FabBtn(
                  icon: Icons.my_location_rounded,
                  color: colors.onSurface,
                  onTap: () {
                    if (_myLocation != null) _mapCtrl.move(_myLocation!, 16);
                  },
                ),
                const SizedBox(height: 8),
                FabBtn(
                  icon: Icons.add_location_alt_rounded,
                  color: colors.onSurface,
                  onTap: _openAddSheet,
                ),
                if (_destination != null) ...[
                  const SizedBox(height: 8),
                  FabBtn(
                    icon: Icons.clear_rounded,
                    color: Colors.red,
                    onTap: _clearRoute,
                  ),
                ],
              ],
            ),
          ),

          // ══ ROUTE LOADING ════════════════════════════
          if (_loadingRoute)
            Positioned(
              bottom: bottomPad + 180,
              left: 0,
              right: 0,
              child: const Center(child: LoadingPill()),
            ),

          // ══ TRIP BOTTOM SHEET ════════════════════════
          // Replaces the old GlassCont and RouteInfoSheet
          Positioned.fill(
            child: TripBottomSheet(
              key: _tripSheetKey,
              myLocation: _myLocation,
              onDestinationSelected: _onTripDestinationSelected,
              onClear: () {
                setState(() {
                  _destination = null;
                  _route = null;
                  _markers = [];
                });
                if (_myLocation != null) _mapCtrl.move(_myLocation!, 15);
              },
            ),
          ),
        ],
      ),
      endDrawer: CustomDrawer(),
    );
  }
}
