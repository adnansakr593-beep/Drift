// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:drift_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:drift_app/cubits/theme_cubit/theme_state.dart';
import 'package:drift_app/services/saved_locations_service_firebase.dart';
import 'package:drift_app/widgets/custom_drawer.dart';
import 'package:drift_app/widgets/fab_btn.dart';
import 'package:drift_app/widgets/loading_pill.dart';
import 'package:drift_app/widgets/mini_cards.dart';
import 'package:drift_app/widgets/open_add_sheet.dart';
import 'package:drift_app/widgets/show_saved_location_options.dart';
import 'package:drift_app/widgets/trip_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/route_info.dart';
import '../models/saved_location_model.dart';
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

  // ── Top-bar live search state ────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  List<Marker> _markers = [];
  String _tileUrl =
      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';

  late final SavedLocationService savedService =
      SavedLocationService(userId: MapPage.userId);

  @override
  void initState() {
    super.initState();
    _initGPS();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
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

  // ══ ROUTE CREATION (shared logic) ══════════════════════════════════════════
  Future<void> _createRouteToDestination(LatLng point, String cityName) async {
    if (_myLocation == null) {
      _mapCtrl.move(point, 13);
      return;
    }

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

      // Update trip bottom sheet with route info
      _tripSheetKey.currentState?.updateRouteInfo(
        distanceKm: route.distanceMeters / 1000,
        durationMin: route.durationSeconds / 60,
      );

      // Pre-fill the trip sheet search
      _tripSheetKey.currentState?.prefillSearch(cityName);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingRoute = false);
      _showError('Failed to create route: ${e.toString()}');
    }
  }

  // ══ MAP TAP → ROUTE ═══════════════════════════════════════════════════════
  Future<void> _onMapTap(TapPosition _, LatLng point) async {
    if (_loadingRoute || _myLocation == null) return;

    await _createRouteToDestination(point, 'Selected Location');
  }

  // ══ TRIP SHEET: destination selected ═════════════════════════════════════
  Future<void> _onTripDestinationSelected(LatLng point, String cityName) async {
    await _createRouteToDestination(point, cityName);
  }

  // ══ MINI CARD TAP → ROUTE + update trip sheet ════════════════════════════
  Future<void> _goToSaved(SavedLocation loc) async {
    final point = LatLng(loc.lat, loc.lng);
    await _createRouteToDestination(point, loc.name);
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
                  setState(() {
                    _tileUrl = state.themeMode == ThemeMode.light
                        ? 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'
                        : 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
                  });
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
                      'Getting your location...',
                      style: TextStyle(fontSize: 15, color: colors.onSurface),
                    ),
                  ],
                ),
              ),
            ),

          // ══ TOP SEARCH BAR + SUGGESTIONS + MINI CARDS ═════════════════════
          Positioned(
            top: topPad + 10,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Search row ────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: StreamBuilder<List<SavedLocation>>(
                        stream: savedService.stream(),
                        builder: (context, snapshot) {
                          final locations = snapshot.data ?? [];
                          if (locations.isEmpty) return const SizedBox.shrink();
                          return SizedBox(
                            height: 65,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: locations.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (_, i) => MiniCard(
                                label: locations[i].name,
                                onTap: () => _goToSaved(locations[i]),
                                onLongPress: () => showSavedLocationOptions(
                                    context,
                                    locations[i],
                                    savedService,
                                    mounted,
                                    colors),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: colors.background.withOpacity(0.5),
                              blurStyle: BlurStyle.inner),
                        ],
                        borderRadius: BorderRadius.circular(19),
                        //shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                        border: Border.all(
                            color: colors.onSurface.withOpacity(0.4), width: 1),
                      ),
                      child: IconButton(
                        onPressed: () =>
                            _scaffoldKey.currentState?.openEndDrawer(),
                        icon: Icon(Icons.menu_rounded, color: colors.onSurface),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ══ MAP STYLE + ACTION BUTTONS ════════════════════════════════════
          Positioned(
            bottom: 200,
            right: 16,
            child: Column(
              children: [
                FabBtn(
                  icon: Icons.light_mode,
                  color: colors.onSurface,
                  onTap: () => setState(() => _tileUrl =
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'),
                ),
                const SizedBox(height: 8),
                FabBtn(
                  icon: Icons.dark_mode,
                  color: colors.onSurface,
                  onTap: () => setState(() => _tileUrl =
                      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'),
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
                  onTap: () {
                    openAddSheet(context, savedService);
                  },
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
