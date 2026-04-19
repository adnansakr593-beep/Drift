//========================= map Page ==============================
// // ignore_for_file: deprecated_member_use
// import 'dart:async';
// import 'dart:convert';
// //import 'package:drift_app/widgets/custom_top_bar.dart';
// import 'package:drift_app/widgets/fab_btn.dart';
// import 'package:drift_app/widgets/loading_pill.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
// import '../models/route_info.dart';
// import '../services/location_service.dart';
// import '../services/routing_service.dart';
// import '../widgets/map_markers.dart';
// import '../widgets/route_info_sheet.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});
//   static String id = 'map screen';
//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   final _mapCtrl = MapController();

//   LatLng? _myLocation;
//   LatLng? _destination;
//   RouteInfo? _route;
//   bool _loadingGPS = true;
//   bool _loadingRoute = false;

//   StreamSubscription? _gpsSub;
//   final TextEditingController _searchController = TextEditingController();
//   List<Marker> _markers = [];

//   @override
//   void initState() {
//     super.initState();
//     _initGPS();
//   }

//   @override
//   void dispose() {
//     _gpsSub?.cancel();
//     super.dispose();
//   }

//   Future<void> _initGPS() async {
//     try {
//       final loc = await LocationService.getCurrentLocation();
//       if (!mounted) return;
//       setState(() {
//         _myLocation = loc;
//         _loadingGPS = false;
//       });
//       _mapCtrl.move(loc, 17);

//       _gpsSub = LocationService.getStream().listen((loc) {
//         if (mounted) setState(() => _myLocation = loc);
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _loadingGPS = false;
//         _myLocation = const LatLng(30.0444, 31.2357);
//       });
//       _mapCtrl.move(_myLocation!, 12);
//       _showError(e.toString());
//     }
//   }

//   // ══ SEARCH FUNCTION ══════════════════════════════════════════════════════════
// Future<LatLng?> searchPlace(String query) async {
//   final url = Uri.parse(
//     'https://nominatim.openstreetmap.org/search'
//     '?q=${Uri.encodeComponent(query)}'
//     '&format=json&limit=1',
//   );

//   final response = await http.get(url, headers: {
//     'User-Agent': 'MyFlutterApp/1.0', // مطلوب من Nominatim
//   });

//   final data = jsonDecode(response.body) as List;
//   if (data.isEmpty) return null;

//   return LatLng(
//     double.parse(data[0]['lat']),
//     double.parse(data[0]['lon']),
//   );
// }


//   Future<void> _search() async {
//     final result = await searchPlace(_searchController.text);
//     if (result == null) return;

//     setState(() {
//       _markers = [
//         Marker(
//           point: result,
//           child: const Icon(Icons.location_on, color: Colors.red, size: 40),
//         ),
//       ];
//     });

//     _mapCtrl.move(result, 15);
//   }

//   Future<void> _onMapTap(TapPosition _, LatLng point) async {
//     if (_loadingRoute || _myLocation == null) return;
//     setState(() {
//       _destination = point;
//       _route = null;
//       _loadingRoute = true;
//     });

//     try {
//       final route = await RoutingService.getRoute(
//         origin: _myLocation!,
//         destination: point,
//       );
//       if (!mounted) return;
//       setState(() {
//         _route = route;
//         _loadingRoute = false;
//       });
//       _mapCtrl.fitCamera(
//         CameraFit.bounds(
//           bounds: LatLngBounds.fromPoints(route.points),
//           padding: const EdgeInsets.all(60),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _loadingRoute = false);
//       _showError('فشل في جلب المسار');
//     }
//   }

//   void _clearRoute() {
//     setState(() {
//       _destination = null;
//       _route = null;
//     });
//     if (_myLocation != null) _mapCtrl.move(_myLocation!, 15);
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: Colors.red[400],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomPad = MediaQuery.of(context).padding.bottom;
//     final colors = Theme.of(context).colorScheme;
//     String tileUrl =
//       'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';

//     return Scaffold(
//       body: Stack(
//         children: [
//           // ══ MAP ══════════════════════════════════════
//           FlutterMap(
//             mapController: _mapCtrl,
//             options: MapOptions(
//               initialCenter: const LatLng(30.0444, 31.2357),
//               initialZoom: 12,
//               minZoom: 5,
//               maxZoom: 18,
//               onTap: _onMapTap,
//             ),
//             children: [
//               // Layer 1 — OSM Tiles
//               TileLayer(
//                 urlTemplate:
//                 tileUrl,
//                     //'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
//                 subdomains: const ['a', 'b', 'c', 'd'],
//                 userAgentPackageName: 'com.example.drift',
//                 maxZoom: 19,
//               ),
//               // Layer 2 — Route Line
//               if (_route != null)
//                 PolylineLayer(
//                   polylines: [
//                     Polyline(
//                       points: _route!.points,
//                       strokeWidth: 8,
//                       color: colors.primary,
//                       borderStrokeWidth: 2,
//                       borderColor: Colors.white.withOpacity(0.6),
//                     ),
//                   ],
//                 ),
//               // Layer 3 — Markers
//               MarkerLayer(
//                 markers: [
//                   if (_myLocation != null)
//                     Marker(
//                       point: _myLocation!,
//                       width: 44,
//                       height: 44,
//                       child: const UserLocationMarker(),
//                     ),
//                   if (_destination != null)
//                     Marker(
//                       point: _destination!,
//                       width: 44,
//                       height: 44,
//                       child: const DestinationMarker(),
//                     ),
//                 ],
//               ),
//             ],
//           ),

          

//           // ══ GPS LOADING ══════════════════════════════
//           if (_loadingGPS)
//             ColoredBox(
//               color: Colors.black,
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircularProgressIndicator(color: colors.primary),
//                     SizedBox(height: 14),
//                     Text(
//                       'جاري تحديد موقعك...',
//                       style: TextStyle(fontSize: 15, color: colors.onSurface),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // ══ SEARCH BAR ═══════════════════════════════
//           Positioned(
//             top: 50,
//             left: 16,
//             right: 16,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'ابحث عن مكان...',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _search,
//                   child: const Icon(Icons.search),
//                 ),
//               ],
//             ),
//           ),


//           // ══ MAP STYLE BUTTONS ════════════════════════
//           Positioned(
//             bottom: 30,
//             right: 16,
//             child: Column(
//               children: [
//                 // ✅ FIX: Light mode → CartoDB light
//                 FloatingActionButton.small(
//                   heroTag: 'light',
//                   onPressed: () => setState(
//                     () => tileUrl =
//                         'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
//                   ),
//                   child: const Icon(Icons.light_mode),
//                 ),
//                 const SizedBox(height: 8),
//                 // ✅ FIX: Dark mode → CartoDB dark
//                 FloatingActionButton.small(
//                   heroTag: 'dark',
//                   onPressed: () => setState(
//                     () => tileUrl =
//                         'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
//                   ),
//                   child: const Icon(Icons.dark_mode),
//                 ),
//               ],
//             ),
//           ),

            

//           // ══ TOP BAR ══════════════════════════════════
//           // if (!_loadingGPS)
//           //   Positioned(
//           //     top: topPad + 10,
//           //     left: 16,
//           //     right: 16,
//           //     //child:  //TopBar(hasRoute: _route != null),
//           //   ),

//           // ══ FAB BUTTONS ══════════════════════════════
//           Positioned(
//             right: 16,
//             bottom: _route != null ? bottomPad + 155 : bottomPad + 155,
//             child: Column(
//               children: [
//                 FabBtn(
//                   icon: Icons.my_location_rounded,
//                   color: colors.primary,
//                   onTap: () {
//                     if (_myLocation != null) _mapCtrl.move(_myLocation!, 16);
//                   },
//                 ),
//                 if (_destination != null) ...[
//                   const SizedBox(height: 8),
//                   FabBtn(
//                     icon: Icons.clear_rounded,
//                     color: Colors.red,
//                     onTap: _clearRoute,
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           // ══ ROUTE LOADING ════════════════════════════
//           if (_loadingRoute)
//             Positioned(
//               bottom: bottomPad + 20,
//               left: 0,
//               right: 0,
//               child: const Center(child: LoadingPill()),
//             ),

//           // ══ ROUTE INFO ═══════════════════════════════
//           if (_route != null)
//             Positioned(
//               bottom: bottomPad,
//               left: 0,
//               right: 0,
//               child: RouteInfoSheet(route: _route!, onClear: _clearRoute),
//             ),

//           if (_route == null)
//             Positioned(
//               bottom: bottomPad,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 10,horizontal: 25),
//                 decoration: BoxDecoration(
//                   color: colors.background,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: colors.primary, //Colors.black.withOpacity(0.12),
//                       blurRadius: 20,
//                       offset: const Offset(4, -4),
//                     ),
//                   ],
//                 ),
//                 child: Text('Welcome Were we going today'),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
  
// }








// ignore_for_file: deprecated_member_use
// import 'dart:async';
// import 'dart:convert';
// import 'package:drift_app/services/saved_locations_service_firebase.dart';
// import 'package:drift_app/widgets/fab_btn.dart';
// import 'package:drift_app/widgets/loading_pill.dart';
// import 'package:drift_app/widgets/mini_cards.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
// import '../models/route_info.dart';
// import '../services/location_service.dart';
// import '../services/routing_service.dart';
// import '../widgets/map_markers.dart';
// import '../widgets/route_info_sheet.dart';
// import '../models/saved_location_model.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});
//   static String id = 'map screen';

//   // ⚠️ Replace with FirebaseAuth.instance.currentUser!.uid
//   static const String userId = 'YOUR_USER_ID';

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   final _mapCtrl = MapController();

//   LatLng? _myLocation;
//   LatLng? _destination;
//   RouteInfo? _route;
//   bool _loadingGPS = true;
//   bool _loadingRoute = false;

//   StreamSubscription? _gpsSub;
//   final TextEditingController _searchController = TextEditingController();
//   List<Marker> _markers = [];
//   String _tileUrl =
//       'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';

//   // ── Firebase saved locations ──────────────────────────────────────────────
//   late final SavedLocationService _savedService =
//       SavedLocationService(userId: MapPage.userId);

//   @override
//   void initState() {
//     super.initState();
//     _initGPS();
//   }

//   @override
//   void dispose() {
//     _gpsSub?.cancel();
//     _searchController.dispose();
//     super.dispose();
//   }

//   // ══ GPS ════════════════════════════════════════════════════════════════════
//   Future<void> _initGPS() async {
//     try {
//       final loc = await LocationService.getCurrentLocation();
//       if (!mounted) return;
//       setState(() {
//         _myLocation = loc;
//         _loadingGPS = false;
//       });
//       _mapCtrl.move(loc, 17);
//       _gpsSub = LocationService.getStream().listen((loc) {
//         if (mounted) setState(() => _myLocation = loc);
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _loadingGPS = false;
//         _myLocation = const LatLng(30.0444, 31.2357);
//       });
//       _mapCtrl.move(_myLocation!, 12);
//       _showError(e.toString());
//     }
//   }

//   // ══ SEARCH ════════════════════════════════════════════════════════════════
//   Future<LatLng?> searchPlace(String query) async {
//     final url = Uri.parse(
//       'https://nominatim.openstreetmap.org/search'
//       '?q=${Uri.encodeComponent(query)}&format=json&limit=1',
//     );
//     final response =
//         await http.get(url, headers: {'User-Agent': 'MyFlutterApp/1.0'});
//     final data = jsonDecode(response.body) as List;
//     if (data.isEmpty) return null;
//     return LatLng(
//       double.parse(data[0]['lat']),
//       double.parse(data[0]['lon']),
//     );
//   }

//   Future<void> _search() async {
//     final result = await searchPlace(_searchController.text);
//     if (result == null) return;
//     setState(() {
//       _markers = [
//         Marker(
//           point: result,
//           child: const Icon(Icons.location_on, color: Colors.red, size: 40),
//         ),
//       ];
//     });
//     _mapCtrl.move(result, 15);
//   }

//   // ══ MAP TAP → ROUTE ═══════════════════════════════════════════════════════
//   Future<void> _onMapTap(TapPosition _, LatLng point) async {
//     if (_loadingRoute || _myLocation == null) return;
//     setState(() {
//       _destination = point;
//       _route = null;
//       _loadingRoute = true;
//     });
//     try {
//       final route = await RoutingService.getRoute(
//         origin: _myLocation!,
//         destination: point,
//       );
//       if (!mounted) return;
//       setState(() {
//         _route = route;
//         _loadingRoute = false;
//       });
//       _mapCtrl.fitCamera(
//         CameraFit.bounds(
//           bounds: LatLngBounds.fromPoints(route.points),
//           padding: const EdgeInsets.all(60),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _loadingRoute = false);
//       _showError('فشل في جلب المسار');
//     }
//   }

//   // ══ MINI CARD TAP → ROUTE ═════════════════════════════════════════════════
//   Future<void> _goToSaved(SavedLocation loc) async {
//     final point = LatLng(loc.lat, loc.lng);
//     if (_myLocation == null) {
//       _mapCtrl.move(point, 15);
//       return;
//     }
//     setState(() {
//       _destination = point;
//       _route = null;
//       _loadingRoute = true;
//       _markers = [];
//     });
//     try {
//       final route = await RoutingService.getRoute(
//         origin: _myLocation!,
//         destination: point,
//       );
//       if (!mounted) return;
//       setState(() {
//         _route = route;
//         _loadingRoute = false;
//       });
//       _mapCtrl.fitCamera(
//         CameraFit.bounds(
//           bounds: LatLngBounds.fromPoints(route.points),
//           padding: const EdgeInsets.all(60),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _loadingRoute = false);
//       _showError('فشل في جلب المسار');
//     }
//   }

//   void _clearRoute() {
//     setState(() {
//       _destination = null;
//       _route = null;
//       _markers = [];
//     });
//     if (_myLocation != null) _mapCtrl.move(_myLocation!, 15);
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: Colors.red[400],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   // ══ BUILD ════════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     final bottomPad = MediaQuery.of(context).padding.bottom;
//     final topPad = MediaQuery.of(context).padding.top;
//     final colors = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // ══ MAP ══════════════════════════════════════
//           FlutterMap(
//             mapController: _mapCtrl,
//             options: MapOptions(
//               initialCenter: const LatLng(30.0444, 31.2357),
//               initialZoom: 12,
//               minZoom: 5,
//               maxZoom: 18,
//               onTap: _onMapTap,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: _tileUrl,
//                 subdomains: const ['a', 'b', 'c', 'd'],
//                 userAgentPackageName: 'com.example.drift',
//                 maxZoom: 19,
//               ),
//               if (_route != null)
//                 PolylineLayer(
//                   polylines: [
//                     Polyline(
//                       points: _route!.points,
//                       strokeWidth: 8,
//                       color: colors.primary,
//                       borderStrokeWidth: 2,
//                       borderColor: Colors.white.withOpacity(0.6),
//                     ),
//                   ],
//                 ),
//               MarkerLayer(
//                 markers: [
//                   if (_myLocation != null)
//                     Marker(
//                       point: _myLocation!,
//                       width: 44,
//                       height: 44,
//                       child: const UserLocationMarker(),
//                     ),
//                   if (_destination != null)
//                     Marker(
//                       point: _destination!,
//                       width: 44,
//                       height: 44,
//                       child: const DestinationMarker(),
//                     ),
//                   ..._markers,
//                 ],
//               ),
//             ],
//           ),

//           // ══ GPS LOADING ══════════════════════════════
//           if (_loadingGPS)
//             ColoredBox(
//               color: Colors.black,
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircularProgressIndicator(color: colors.primary),
//                     const SizedBox(height: 14),
//                     Text(
//                       'جاري تحديد موقعك...',
//                       style: TextStyle(fontSize: 15, color: colors.onSurface),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//           // ══ SEARCH BAR + MINI CARDS ═══════════════════
//           Positioned(
//             top: topPad + 10,
//             left: 16,
//             right: 16,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ── Search row ─────────────────────────────────────────────────
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _searchController,
//                         decoration: InputDecoration(
//                           hintText: 'Search City...',
//                           hintStyle: TextStyle(color: colors.onSurface),
//                           filled: true,
//                           fillColor: colors.background,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     ElevatedButton(
//                       onPressed: _search,
//                       child: const Icon(Icons.search),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 10),

//                 // ── Mini Cards row (Firebase real-time) ────────────────────────
//                 StreamBuilder<List<SavedLocation>>(
//                   stream: _savedService.stream(),
//                   builder: (context, snapshot) {
//                     final locations = snapshot.data ?? [];
//                     if (locations.isEmpty) return const SizedBox.shrink();

//                     return SizedBox(
//                       height: 50,
//                       child: ListView.separated(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: locations.length,
//                         separatorBuilder: (_, _) => const SizedBox(width: 8),
//                         itemBuilder: (_, i) => MiniCard(
//                           label: locations[i].name,
//                           onTap: () => _goToSaved(locations[i]),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // ══ MAP STYLE BUTTONS ════════════════════════
//           Positioned(
//             bottom: 255,
//             right: 16,
//             child: Column(
//               children: [
//                 FloatingActionButton.small(
//                   heroTag: 'light',
//                   onPressed: () => setState(
//                     () => _tileUrl =
//                         'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
//                   ),
//                   child: const Icon(Icons.light_mode),
//                 ),
//                 const SizedBox(height: 8),
//                 FloatingActionButton.small(
//                   heroTag: 'dark',
//                   onPressed: () => setState(
//                     () => _tileUrl =
//                         'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
//                   ),
//                   child: const Icon(Icons.dark_mode),
//                 ),
//               ],
//             ),
//           ),

//           // ══ FAB BUTTONS ══════════════════════════════
//           Positioned(
//             right: 16,
//             bottom: bottomPad + 130,
//             child: Column(
//               children: [
//                 FabBtn(
//                   icon: Icons.my_location_rounded,
//                   color: colors.primary,
//                   onTap: () {
//                     if (_myLocation != null) _mapCtrl.move(_myLocation!, 16);
//                   },
//                 ),
//                 if (_destination != null) ...[
//                   const SizedBox(height: 8),
//                   FabBtn(
//                     icon: Icons.clear_rounded,
//                     color: Colors.red,
//                     onTap: _clearRoute,
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           // ══ ROUTE LOADING ════════════════════════════
//           if (_loadingRoute)
//             Positioned(
//               bottom: bottomPad + 20,
//               left: 0,
//               right: 0,
//               child: const Center(child: LoadingPill()),
//             ),

//           // ══ ROUTE INFO ═══════════════════════════════
//           if (_route != null)
//             Positioned(
//               bottom: bottomPad,
//               left: 0,
//               right: 0,
//               child: RouteInfoSheet(route: _route!, onClear: _clearRoute),
//             ),

//           if (_route == null)
//             Positioned(
//               bottom: bottomPad,
//               left: 0,
//               right: 0,
//               child: MiniCard(label: 'home', onTap: _goToSaved)
//             ),
//         ],
//       ),
//     );
//   }
// }






// // ignore_for_file: deprecated_member_use
// import 'dart:async';
// import 'dart:convert';
// import 'package:drift_app/widgets/fab_btn.dart';
// import 'package:drift_app/widgets/loading_pill.dart';
// import 'package:drift_app/widgets/mini_cards.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
// import '../models/route_info.dart';
// import '../services/location_service.dart';
// import '../services/routing_service.dart';
// import '../widgets/map_markers.dart';
// import '../widgets/route_info_sheet.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});
//   static String id = 'map screen';
//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   final _mapCtrl = MapController();

//   LatLng? _myLocation;
//   LatLng? _destination;
//   RouteInfo? _route;
//   bool _loadingGPS = true;
//   bool _loadingRoute = false;

//   StreamSubscription? _gpsSub;
//   final TextEditingController _searchController = TextEditingController();
//   List<Marker> _markers = [];
//   String _tileUrl =
//       'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';

//   @override
//   void initState() {
//     super.initState();
//     _initGPS();
//   }

//   @override
//   void dispose() {
//     _gpsSub?.cancel();
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _initGPS() async {
//     try {
//       final loc = await LocationService.getCurrentLocation();
//       if (!mounted) return;
//       setState(() {
//         _myLocation = loc;
//         _loadingGPS = false;
//       });
//       _mapCtrl.move(loc, 17);

//       _gpsSub = LocationService.getStream().listen((loc) {
//         if (mounted) setState(() => _myLocation = loc);
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _loadingGPS = false;
//         _myLocation = const LatLng(30.0444, 31.2357);
//       });
//       _mapCtrl.move(_myLocation!, 12);
//       _showError(e.toString());
//     }
//   }

//   // ══ SEARCH FUNCTION ══════════════════════════════════════════════════════════
//   Future<LatLng?> searchPlace(String query) async {
//     final url = Uri.parse(
//       'https://nominatim.openstreetmap.org/search'
//       '?q=${Uri.encodeComponent(query)}'
//       '&format=json&limit=1',
//     );

//     final response = await http.get(url, headers: {
//       'User-Agent': 'MyFlutterApp/1.0',
//     });

//     final data = jsonDecode(response.body) as List;
//     if (data.isEmpty) return null;

//     return LatLng(
//       double.parse(data[0]['lat']),
//       double.parse(data[0]['lon']),
//     );
//   }

//   Future<void> _search() async {
//     final result = await searchPlace(_searchController.text);
//     if (result == null) return;

//     setState(() {
//       _markers = [
//         Marker(
//           point: result,
//           child: const Icon(Icons.location_on, color: Colors.red, size: 40),
//         ),
//       ];
//     });

//     _mapCtrl.move(result, 15);
//   }

//   Future<void> _onMapTap(TapPosition _, LatLng point) async {
//     if (_loadingRoute || _myLocation == null) return;
//     setState(() {
//       _destination = point;
//       _route = null;
//       _loadingRoute = true;
//     });

//     try {
//       final route = await RoutingService.getRoute(
//         origin: _myLocation!,
//         destination: point,
//       );
//       if (!mounted) return;
//       setState(() {
//         _route = route;
//         _loadingRoute = false;
//       });
//       _mapCtrl.fitCamera(
//         CameraFit.bounds(
//           bounds: LatLngBounds.fromPoints(route.points),
//           padding: const EdgeInsets.all(60),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _loadingRoute = false);
//       _showError('فشل في جلب المسار');
//     }
//   }

//   void _clearRoute() {
//     setState(() {
//       _destination = null;
//       _route = null;
//       _markers = [];
//     });
//     if (_myLocation != null) _mapCtrl.move(_myLocation!, 15);
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: Colors.red[400],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomPad = MediaQuery.of(context).padding.bottom;
//     final colors = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // ══ MAP ══════════════════════════════════════
//           FlutterMap(
//             mapController: _mapCtrl,
//             options: MapOptions(
//               initialCenter: const LatLng(30.0444, 31.2357),
//               initialZoom: 12,
//               minZoom: 5,
//               maxZoom: 18,
//               onTap: _onMapTap,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: _tileUrl,
//                 subdomains: const ['a', 'b', 'c', 'd'],
//                 userAgentPackageName: 'com.example.drift',
//                 maxZoom: 19,
//               ),
//               // Layer 2 — Route Line
//               if (_route != null)
//                 PolylineLayer(
//                   polylines: [
//                     Polyline(
//                       points: _route!.points,
//                       strokeWidth: 8,
//                       color: colors.primary,
//                       borderStrokeWidth: 2,
//                       borderColor: Colors.white.withOpacity(0.6),
//                     ),
//                   ],
//                 ),
//               // Layer 3 — Markers
//               MarkerLayer(
//                 markers: [
//                   if (_myLocation != null)
//                     Marker(
//                       point: _myLocation!,
//                       width: 44,
//                       height: 44,
//                       child: const UserLocationMarker(),
//                     ),
//                   if (_destination != null)
//                     Marker(
//                       point: _destination!,
//                       width: 44,
//                       height: 44,
//                       child: const DestinationMarker(),
//                     ),
//                   ..._markers,
//                 ],
//               ),
//             ],
//           ),

//           // ══ GPS LOADING ══════════════════════════════
//           if (_loadingGPS)
//             ColoredBox(
//               color: Colors.black,
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircularProgressIndicator(color: colors.primary),
//                     const SizedBox(height: 14),
//                     Text(
//                       'جاري تحديد موقعك...',
//                       style: TextStyle(fontSize: 15, color: colors.onSurface),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//           // ══ SEARCH BAR ═══════════════════════════════
//           Positioned(
//             top: 50,
//             left: 16,
//             right: 16,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText:'Search City...',
//                       hintStyle: TextStyle
//                       (
//                         color: colors.onSurface
//                       ),
//                       filled: true,
//                       fillColor: colors.background,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
                    
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _search,
//                   child: const Icon(Icons.search),
//                 ),
//               ],
//             ),
//           ),

//           // ══ MAP STYLE BUTTONS ════════════════════════
//           Positioned(
//             bottom: 255,
//             right: 16,
//             child: Column(
//               children: [
//                 FloatingActionButton.small(
//                   heroTag: 'light',
//                   onPressed: () => setState(
//                     () => _tileUrl =
//                         'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
//                   ),
//                   child: const Icon(Icons.light_mode),
//                 ),
//                 const SizedBox(height: 8),
//                 FloatingActionButton.small(
//                   heroTag: 'dark',
//                   onPressed: () => setState(
//                     () => _tileUrl =
//                         'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
//                   ),
//                   child: const Icon(Icons.dark_mode),
//                 ),
//               ],
//             ),
//           ),

//           // ══ FAB BUTTONS ══════════════════════════════
//           Positioned(
//             right: 16,
//             bottom: bottomPad + 130,
//             child: Column(
//               children: [
//                 FabBtn(
//                   icon: Icons.my_location_rounded,
//                   color: colors.primary,
//                   onTap: () {
//                     if (_myLocation != null) _mapCtrl.move(_myLocation!, 16);
//                   },
//                 ),
//                 if (_destination != null) ...[
//                   const SizedBox(height: 8),
//                   FabBtn(
//                     icon: Icons.clear_rounded,
//                     color: Colors.red,
//                     onTap: _clearRoute,
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           // ══ ROUTE LOADING ════════════════════════════
//           if (_loadingRoute)
//             Positioned(
//               bottom: bottomPad + 20,
//               left: 0,
//               right: 0,
//               child: const Center(child: LoadingPill()),
//             ),

//           // ══ ROUTE INFO ═══════════════════════════════
//           if (_route != null)
//             Positioned(
//               bottom: bottomPad,
//               left: 0,
//               right: 0,
//               child: RouteInfoSheet(route: _route!, onClear: _clearRoute),
//             ),

//           // if (_route == null)
//           //   Positioned(
//           //     bottom: bottomPad-2,
//           //     left: 0,
//           //     right: 0,
//           //     child: Container(
//           //       padding:
//           //           const EdgeInsets.only(top: 10, right: 25,left: 25,bottom: 25),
//           //       decoration: BoxDecoration(
//           //         color: colors.background,
//           //         borderRadius: BorderRadius.circular(20),
//           //         boxShadow: [
//           //           BoxShadow(
//           //             color: colors.primary,
//           //             blurRadius: 20,
//           //             offset: const Offset(4, -4),
//           //           ),
//           //         ],
//           //       ),
//           //       child: Row
//           //       (
//           //         children: 
//           //         [
//           //           MiniCards(text: 'travel',),
//           //           const SizedBox( width: 5,),
//           //           MiniCards(text: 'travel',),
//           //           const SizedBox( width: 5,),
//           //           MiniCards(text: 'travel',),
//           //           const SizedBox( width: 5,),
//           //           MiniCards(text: 'travel',),

//           //         ],
//           //       ) 
//           //     ),
//           //   ),
//         ],
//       ),
//     );
//   }
// }

// // ignore_for_file: deprecated_member_use
// import 'dart:async';
// import 'dart:convert';
// import 'package:drift_app/services/saved_locations_service_firebase.dart';
// import 'package:drift_app/widgets/fab_btn.dart';
// import 'package:drift_app/widgets/loading_pill.dart';
// import 'package:drift_app/widgets/mini_cards.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
// import '../models/route_info.dart';
// import '../services/location_service.dart';
// import '../services/routing_service.dart';
// import '../widgets/map_markers.dart';
// import '../widgets/route_info_sheet.dart';
// import '../models/saved_location_model.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});
//   static String id = 'map screen';

//   // ⚠️ Replace with FirebaseAuth.instance.currentUser!.uid
//   static const String userId = 'YOUR_USER_ID';

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   final _mapCtrl = MapController();

//   LatLng? _myLocation;
//   LatLng? _destination;
//   RouteInfo? _route;
//   bool _loadingGPS = true;
//   bool _loadingRoute = false;

//   StreamSubscription? _gpsSub;
//   final TextEditingController _searchController = TextEditingController();
//   List<Marker> _markers = [];
//   String _tileUrl =
//       'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';

//   late final SavedLocationService _savedService =
//       SavedLocationService(userId: MapPage.userId);

//   @override
//   void initState() {
//     super.initState();
//     _initGPS();
//   }

//   @override
//   void dispose() {
//     _gpsSub?.cancel();
//     _searchController.dispose();
//     super.dispose();
//   }

//   // ══ GPS ════════════════════════════════════════════════════════════════════
//   Future<void> _initGPS() async {
//     try {
//       final loc = await LocationService.getCurrentLocation();
//       if (!mounted) return;
//       setState(() {
//         _myLocation = loc;
//         _loadingGPS = false;
//       });
//       _mapCtrl.move(loc, 17);
//       _gpsSub = LocationService.getStream().listen((loc) {
//         if (mounted) setState(() => _myLocation = loc);
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _loadingGPS = false;
//         _myLocation = const LatLng(30.0444, 31.2357);
//       });
//       _mapCtrl.move(_myLocation!, 12);
//       _showError(e.toString());
//     }
//   }

//   // ══ SEARCH ════════════════════════════════════════════════════════════════
//   Future<LatLng?> searchPlace(String query) async {
//     final url = Uri.parse(
//       'https://nominatim.openstreetmap.org/search'
//       '?q=${Uri.encodeComponent(query)}&format=json&limit=1',
//     );
//     final response =
//         await http.get(url, headers: {'User-Agent': 'MyFlutterApp/1.0'});
//     final data = jsonDecode(response.body) as List;
//     if (data.isEmpty) return null;
//     return LatLng(
//       double.parse(data[0]['lat']),
//       double.parse(data[0]['lon']),
//     );
//   }

//   Future<void> _search() async {
//     final result = await searchPlace(_searchController.text);
//     if (result == null) return;
//     setState(() {
//       _markers = [
//         Marker(
//           point: result,
//           child: const Icon(Icons.location_on, color: Colors.red, size: 40),
//         ),
//       ];
//     });
//     _mapCtrl.move(result, 15);
//   }

//   // ══ MAP TAP → ROUTE ═══════════════════════════════════════════════════════
//   Future<void> _onMapTap(TapPosition _, LatLng point) async {
//     if (_loadingRoute || _myLocation == null) return;
//     setState(() {
//       _destination = point;
//       _route = null;
//       _loadingRoute = true;
//     });
//     try {
//       final route = await RoutingService.getRoute(
//         origin: _myLocation!,
//         destination: point,
//       );
//       if (!mounted) return;
//       setState(() {
//         _route = route;
//         _loadingRoute = false;
//       });
//       _mapCtrl.fitCamera(
//         CameraFit.bounds(
//           bounds: LatLngBounds.fromPoints(route.points),
//           padding: const EdgeInsets.all(60),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _loadingRoute = false);
//       _showError('فشل في جلب المسار');
//     }
//   }

//   // ══ MINI CARD TAP → ROUTE ═════════════════════════════════════════════════
//   Future<void> _goToSaved(SavedLocation loc) async {
//     final point = LatLng(loc.lat, loc.lng);
//     if (_myLocation == null) {
//       _mapCtrl.move(point, 15);
//       return;
//     }
//     setState(() {
//       _destination = point;
//       _route = null;
//       _loadingRoute = true;
//       _markers = [];
//     });
//     try {
//       final route = await RoutingService.getRoute(
//         origin: _myLocation!,
//         destination: point,
//       );
//       if (!mounted) return;
//       setState(() {
//         _route = route;
//         _loadingRoute = false;
//       });
//       _mapCtrl.fitCamera(
//         CameraFit.bounds(
//           bounds: LatLngBounds.fromPoints(route.points),
//           padding: const EdgeInsets.all(60),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _loadingRoute = false);
//       _showError('فشل في جلب المسار');
//     }
//   }

//   void _clearRoute() {
//     setState(() {
//       _destination = null;
//       _route = null;
//       _markers = [];
//     });
//     if (_myLocation != null) _mapCtrl.move(_myLocation!, 15);
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: Colors.red[400],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   // ══ BUILD ════════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     final bottomPad = MediaQuery.of(context).padding.bottom;
//     final topPad = MediaQuery.of(context).padding.top;
//     final colors = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // ══ MAP ══════════════════════════════════════
//           FlutterMap(
//             mapController: _mapCtrl,
//             options: MapOptions(
//               initialCenter: const LatLng(30.0444, 31.2357),
//               initialZoom: 12,
//               minZoom: 5,
//               maxZoom: 18,
//               onTap: _onMapTap,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: _tileUrl,
//                 subdomains: const ['a', 'b', 'c', 'd'],
//                 userAgentPackageName: 'com.example.drift',
//                 maxZoom: 19,
//               ),
//               if (_route != null)
//                 PolylineLayer(
//                   polylines: [
//                     Polyline(
//                       points: _route!.points,
//                       strokeWidth: 8,
//                       color: colors.primary,
//                       borderStrokeWidth: 2,
//                       borderColor: Colors.white.withOpacity(0.6),
//                     ),
//                   ],
//                 ),
//               MarkerLayer(
//                 markers: [
//                   if (_myLocation != null)
//                     Marker(
//                       point: _myLocation!,
//                       width: 44,
//                       height: 44,
//                       child: const UserLocationMarker(),
//                     ),
//                   if (_destination != null)
//                     Marker(
//                       point: _destination!,
//                       width: 44,
//                       height: 44,
//                       child: const DestinationMarker(),
//                     ),
//                   ..._markers,
//                 ],
//               ),
//             ],
//           ),

//           // ══ GPS LOADING ══════════════════════════════
//           if (_loadingGPS)
//             ColoredBox(
//               color: Colors.black,
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircularProgressIndicator(color: colors.primary),
//                     const SizedBox(height: 14),
//                     Text(
//                       'جاري تحديد موقعك...',
//                       style: TextStyle(fontSize: 15, color: colors.onSurface),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//           // ══ SEARCH BAR + MINI CARDS ═══════════════════
//           Positioned(
//             top: topPad + 10,
//             left: 16,
//             right: 16,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ── Search row ───────────────────────────────────────────────
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _searchController,
//                         decoration: InputDecoration(
//                           hintText: 'Search City...',
//                           hintStyle: TextStyle(color: colors.onSurface),
//                           filled: true,
//                           fillColor: colors.background,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     ElevatedButton(
//                       onPressed: _search,
//                       child: const Icon(Icons.search),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 10),

//                 // ── Mini Cards (Firebase real-time) ──────────────────────────
//                 StreamBuilder<List<SavedLocation>>(
//                   stream: _savedService.stream(),
//                   builder: (context, snapshot) {
//                     final locations = snapshot.data ?? [];
//                     if (locations.isEmpty) return const SizedBox.shrink();

//                     return SizedBox(
//                       height: 50,
//                       child: ListView.separated(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: locations.length,
//                         // ✅ FIX 1: اتنين parameters مختلفين (_, __) مش (_, _)
//                         separatorBuilder: (_, __) =>
//                             const SizedBox(width: 8),
//                         itemBuilder: (_, i) => MiniCard(
//                           label: locations[i].name,
//                           // ✅ FIX 2: onTap محتاج VoidCallback فبنعمل closure
//                           onTap: () => _goToSaved(locations[i]),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // ══ MAP STYLE BUTTONS ════════════════════════
//           Positioned(
//             bottom: 255,
//             right: 16,
//             child: Column(
//               children: [
//                 FloatingActionButton.small(
//                   heroTag: 'light',
//                   onPressed: () => setState(
//                     () => _tileUrl =
//                         'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
//                   ),
//                   child: const Icon(Icons.light_mode),
//                 ),
//                 const SizedBox(height: 8),
//                 FloatingActionButton.small(
//                   heroTag: 'dark',
//                   onPressed: () => setState(
//                     () => _tileUrl =
//                         'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
//                   ),
//                   child: const Icon(Icons.dark_mode),
//                 ),
//               ],
//             ),
//           ),

//           // ══ FAB BUTTONS ══════════════════════════════
//           Positioned(
//             right: 16,
//             bottom: bottomPad + 130,
//             child: Column(
//               children: [
//                 FabBtn(
//                   icon: Icons.my_location_rounded,
//                   color: colors.primary,
//                   onTap: () {
//                     if (_myLocation != null) _mapCtrl.move(_myLocation!, 16);
//                   },
//                 ),
//                 if (_destination != null) ...[
//                   const SizedBox(height: 8),
//                   FabBtn(
//                     icon: Icons.clear_rounded,
//                     color: Colors.red,
//                     onTap: _clearRoute,
//                   ),
//                 ],
//               ],
//             ),
//           ),


//           // ══ ADD NEW SAVED LOCTION ══════════════════════════════
//           Positioned(
//             right: 16,
//             bottom: bottomPad + 230,
//             child: Column(
//               children: [
//                 FabBtn(
//                   icon: Icons.add,
//                   color: colors.primary,
//                   onTap: () {
//                     _goToSaved(loc);
//                   },
//                 ),
//                 if (_destination != null) ...[
//                   const SizedBox(height: 8),
//                   FabBtn(
//                     icon: Icons.clear_rounded,
//                     color: Colors.red,
//                     onTap: _clearRoute,
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           // ══ ROUTE LOADING ════════════════════════════
//           if (_loadingRoute)
//             Positioned(
//               bottom: bottomPad + 20,
//               left: 0,
//               right: 0,
//               child: const Center(child: LoadingPill()),
//             ),

//           // ══ ROUTE INFO ═══════════════════════════════
//           if (_route != null)
//             Positioned(
//               bottom: bottomPad,
//               left: 0,
//               right: 0,
//               child: RouteInfoSheet(route: _route!, onClear: _clearRoute),
//             ),
//         ],
//       ),
//     );
//   }
// }


// ══ FAB BUTTONS ══════════════════════════════
          // Positioned(
          //   right: 16,
          //   bottom: bottomPad + 130,
          //   child: Column(
          //     children: [
          //       // ── My Location ───────────────────────────────────────────────
          //       FabBtn(
          //         icon: Icons.my_location_rounded,
          //         color: colors.primary,
          //         onTap: () {
          //           if (_myLocation != null) _mapCtrl.move(_myLocation!, 16);
          //         },
          //       ),
          //       const SizedBox(height: 8),

          //       // ── Add saved location ────────────────────────────────────────
          //       FabBtn(
          //         icon: Icons.add_location_alt_rounded,
          //         color: colors.primary,
          //         onTap: _openAddSheet,
          //       ),

          //       // ── Clear route (only when route is active) ───────────────────
          //       if (_destination != null) ...[
          //         const SizedBox(height: 8),
          //         FabBtn(
          //           icon: Icons.clear_rounded,
          //           color: Colors.red,
          //           onTap: _clearRoute,
          //         ),
          //       ],
          //     ],
          //   ),
          // ),




// class CustomDrawer extends StatelessWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;
//   final VoidCallback onSettingsTap;

//   const CustomDrawer({
//     super.key,
//     required this.scaffoldKey,
//     required this.onSettingsTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Padding(
//       padding: const EdgeInsets.only(left: 55, top: 31, bottom: 28),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//           child: Container(
//             width: 320,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blue.withValues(alpha: 0.2),
//                   blurRadius: 40,
//                   spreadRadius: 5,
//                 ),
//               ],
//               borderRadius: BorderRadius.circular(25),
//               color: Colors.white.withValues(alpha: 0.05),
//               border: Border.all(
//                 color: colors.onSurface.withValues(alpha: 0.3),
//                 width: 1,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 DrawerLists(
//                   title: 'Settings',
//                   trailing: Icons.settings,
//                   onTap: () {
//                     Navigator.of(context).pop(); // يقفل الـ drawer
//                     onSettingsTap(); // ينفذ الـ navigation من برا
//                   },
//                 ),
//                 DrawerLists(
//                   title: 'Log Out',
//                   trailing: Icons.logout_rounded,
//                   onTap: () {
//                     scaffoldKey.currentState?.closeEndDrawer();
//                     handleLogout(context, colors);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


      // endDrawer: CustomDrawer(
      //   scaffoldKey: _scaffoldKey,
      //   onSettingsTap: () {
      //     Future.delayed(const Duration(milliseconds: 300), () {
      //       Navigator.pushNamed(context, SettingsPage.id);
      //     });
      //   },
      // ),



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:drift_app/cubits/forgot_password/forgot_pass_cubit.dart';
// import 'package:drift_app/cubits/google_signin/google_signin_cubit.dart';
// import 'package:drift_app/cubits/siginup/signup_cubit.dart';
// import 'package:drift_app/cubits/signin/signin_cubit.dart';
// import 'package:drift_app/cubits/theme_cubit/theme_cubit.dart';
// import 'package:drift_app/cubits/theme_cubit/theme_state.dart';
// import 'package:drift_app/cubits/user_profile_cubit/user_profile_cubit.dart';
// import 'package:drift_app/pages/forgot_pass_page.dart';
// import 'package:drift_app/pages/map_page.dart';
// import 'package:drift_app/pages/signin_page.dart';
// import 'package:drift_app/pages/signup_page.dart';
// import 'package:drift_app/themes/dark_theme.dart';
// import 'package:drift_app/themes/light_theme.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(Drift());
// }

// class Drift extends StatelessWidget {
//   const Drift({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => SigninCubit()),
//         BlocProvider(create: (_) => ForgotPassCubit()),
//         BlocProvider(create: (_) => GoogleSigninCubit()),
//         BlocProvider(create: (_) => UserProfileCubit()),
//         BlocProvider(create: (_) => ThemeCubit()),
//         BlocProvider(create: (_) => SignupCubit()),
//       ],
//       child: BlocBuilder<ThemeCubit, ThemeState>(
//         builder: (context, state) {
//           return MaterialApp(
//             theme: lightTheme,
//             darkTheme: darkTheme,
//             themeMode: state.themeMode,
//             debugShowCheckedModeBanner: false,

//             routes: {
//               SigninPage.id: (context) => const SigninPage(),
//               SignupPage.id: (context) => const SignupPage(),
//               MapPage.id: (context) => const MapPage(),
//               ForgotPassPage.id: (context) => const ForgotPassPage(),
//             },
//             home: AuthWrapper(),
//           );
//         },
//       ),
//     );
//   }
// }

// class AuthWrapper extends StatefulWidget {
//   const AuthWrapper({super.key});

//   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
//   }

//   class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver 
// {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       _updatePresence(user.uid, state);
//     }
//   }

//   Future<void> _updatePresence(String userId, AppLifecycleState state) async {
//     final firestore = FirebaseFirestore.instance;

//     try {
//       switch (state) {
//         case AppLifecycleState.resumed:
//           await firestore.collection("users").doc(userId).update({
//             "isOnline": true,
//             "lastSeen": FieldValue.serverTimestamp(),
//           });
//           break;
//         case AppLifecycleState.paused:
//         case AppLifecycleState.inactive:
//         case AppLifecycleState.detached:
//           await firestore.collection("users").doc(userId).update({
//             "isOnline": false,
//             "lastSeen": FieldValue.serverTimestamp(),
//           });
//           break;
//         case AppLifecycleState.hidden:
//           break;
//       }
//     } catch (e) {
//       debugPrint('Error updating presence: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // Loading state
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         // User is logged in
//         if (snapshot.hasData && snapshot.data != null) {
//           final userId = snapshot.data!.uid;

//           // Update presence when user logs in
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _updatePresence(userId, AppLifecycleState.resumed);
//           });

//           // Provide Friends System Cubits
//           // return MultiBlocProvider(
//           //   providers: [
//           //     BlocProvider(create: (_) => RequestsCubit(userId)),
//           //     BlocProvider(create: (_) => FriendsCubit(userId)),
//           //     BlocProvider(create: (_) => UsersSearchCubit(userId)),
//           //     // Notification Cubits
//           //     BlocProvider(
//           //       create: (_) => FriendRequestsNotificationCubit()
//           //         ..listenToPendingRequests(userId),
//           //     ),
//           //     BlocProvider(
//           //       create: (_) => UnreadMessagesCubit()
//           //         ..listenToUnreadMessages(userId),
//           //     ),
//           //   ],
//           //   child: const MainPage(),
//           // );
//         }

//         // User is not logged in
//         return const SigninPage();
//       },
//     );
//   }
// }






// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:drift_app/cubits/forgot_password/forgot_pass_cubit.dart';
// import 'package:drift_app/cubits/google_signin/google_signin_cubit.dart';
// import 'package:drift_app/cubits/siginup/signup_cubit.dart';
// import 'package:drift_app/cubits/signin/signin_cubit.dart';
// import 'package:drift_app/cubits/theme_cubit/theme_cubit.dart';
// import 'package:drift_app/cubits/theme_cubit/theme_state.dart';
// import 'package:drift_app/cubits/user_profile_cubit/user_profile_cubit.dart';
// import 'package:drift_app/pages/forgot_pass_page.dart';
// import 'package:drift_app/pages/map_page.dart';
// import 'package:drift_app/pages/signin_page.dart';
// import 'package:drift_app/pages/signup_page.dart';
// import 'package:drift_app/themes/dark_theme.dart';
// import 'package:drift_app/themes/light_theme.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const Drift());
// }

// class Drift extends StatelessWidget {
//   const Drift({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => SigninCubit()),
//         BlocProvider(create: (_) => ForgotPassCubit()),
//         BlocProvider(create: (_) => GoogleSigninCubit()),
//         BlocProvider(create: (_) => UserProfileCubit()),
//         BlocProvider(create: (_) => ThemeCubit()),
//         BlocProvider(create: (_) => SignupCubit()),
//       ],
//       child: BlocBuilder<ThemeCubit, ThemeState>(
//         builder: (context, state) {
//           return MaterialApp(
//             theme: lightTheme,
//             darkTheme: darkTheme,
//             themeMode: state.themeMode,
//             debugShowCheckedModeBanner: false,
//             routes: {
//               SigninPage.id: (context) => const SigninPage(),
//               SignupPage.id: (context) => const SignupPage(),
//               MapPage.id: (context) => const MapPage(),
//               ForgotPassPage.id: (context) => const ForgotPassPage(),
//             },
//             home: const AuthWrapper(),
//           );
//         },
//       ),
//     );
//   }
// }

// // ── Auth Wrapper ───────────────────────────────────────────────────────────────
// class AuthWrapper extends StatefulWidget {
//   const AuthWrapper({super.key});
 
//   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
// }
 
// class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
 
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
 
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) _updatePresence(user.uid, state);
//   }
 
//   Future<void> _updatePresence(String userId, AppLifecycleState state) async {
//     final firestore = FirebaseFirestore.instance;
//     try {
//       if (state == AppLifecycleState.hidden) return;
//       final isOnline = state == AppLifecycleState.resumed;
//       await firestore.collection('users').doc(userId).update({
//         'isOnline': isOnline,
//         'lastSeen': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       debugPrint('Presence update error: $e');
//     }
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
 
//         // Loading
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
 
//         // Logged in → MainPage (no back stack, user cannot navigate back)
//         if (snapshot.hasData && snapshot.data != null) {
//           final userId = snapshot.data!.uid;
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _updatePresence(userId, AppLifecycleState.resumed);
//           });
//           return const MapPage();
//         }
 
//         // Not logged in → SigninPage (no back stack)
//         return const SigninPage();
//       },
//     );
//   }
// }


// // ignore_for_file: deprecated_member_use
// import 'dart:async';
// import 'dart:convert';
// import 'package:drift_app/services/saved_locations_service_firebase.dart';
// import 'package:drift_app/widgets/custom_drawer.dart';
// import 'package:drift_app/widgets/custom_text_field.dart';
// import 'package:drift_app/widgets/fab_btn.dart';
// import 'package:drift_app/widgets/glass_cont.dart';
// import 'package:drift_app/widgets/loading_pill.dart';
// import 'package:drift_app/widgets/mini_cards.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
// import '../models/route_info.dart';
// import '../models/saved_location_model.dart';
// import '../pages/add_save_location.dart';
// import '../services/location_service.dart';
// import '../services/routing_service.dart';
// import '../widgets/map_markers.dart';
// import '../widgets/route_info_sheet.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});
//   static String id = 'map page';

//   static String get userId => FirebaseAuth.instance.currentUser?.uid ?? '';

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   final _mapCtrl = MapController();

//   LatLng? _myLocation;
//   LatLng? _destination;
//   RouteInfo? _route;
//   bool _loadingGPS = true;
//   bool _loadingRoute = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   StreamSubscription? _gpsSub;
//   final TextEditingController _searchController = TextEditingController();
//   List<Marker> _markers = [];
//   String _tileUrl =
//       'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';

//   late final SavedLocationService _savedService = SavedLocationService(
//     userId: MapPage.userId,
//   );

//   @override
//   void initState() {
//     super.initState();
//     _initGPS();
//   }

//   @override
//   void dispose() {
//     _gpsSub?.cancel();
//     _searchController.dispose();
//     super.dispose();
//   }

//   // ══ GPS ════════════════════════════════════════════════════════════════════
//   Future<void> _initGPS() async {
//     try {
//       final loc = await LocationService.getCurrentLocation();
//       if (!mounted) return;
//       setState(() {
//         _myLocation = loc;
//         _loadingGPS = false;
//       });
//       _mapCtrl.move(loc, 17);
//       _gpsSub = LocationService.getStream().listen((loc) {
//         if (mounted) setState(() => _myLocation = loc);
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _loadingGPS = false;
//         _myLocation = const LatLng(30.0444, 31.2357);
//       });
//       _mapCtrl.move(_myLocation!, 12);
//       _showError(e.toString());
//     }
//   }

//   // ══ SEARCH ════════════════════════════════════════════════════════════════
//   Future<LatLng?> searchPlace(String query) async {
//     final url = Uri.parse(
//       'https://nominatim.openstreetmap.org/search'
//       '?q=${Uri.encodeComponent(query)}&format=json&limit=1',
//     );
//     final response = await http.get(
//       url,
//       headers: {'User-Agent': 'MyFlutterApp/1.0'},
//     );
//     final data = jsonDecode(response.body) as List;
//     if (data.isEmpty) return null;
//     return LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
//   }

//   Future<void> _search() async {
//     final result = await searchPlace(_searchController.text);
//     if (result == null) return;
//     setState(() {
//       _markers = [
//         Marker(
//           point: result,
//           child: const Icon(Icons.location_on, color: Colors.red, size: 40),
//         ),
//       ];
//     });
//     _mapCtrl.move(result, 15);
//   }

//   // ══ MAP TAP → ROUTE ═══════════════════════════════════════════════════════
//   Future<void> _onMapTap(TapPosition _, LatLng point) async {
//     if (_loadingRoute || _myLocation == null) return;
//     setState(() {
//       _destination = point;
//       _route = null;
//       _loadingRoute = true;
//     });
//     try {
//       final route = await RoutingService.getRoute(
//         origin: _myLocation!,
//         destination: point,
//       );
//       if (!mounted) return;
//       setState(() {
//         _route = route;
//         _loadingRoute = false;
//       });
//       _mapCtrl.fitCamera(
//         CameraFit.bounds(
//           bounds: LatLngBounds.fromPoints(route.points),
//           padding: const EdgeInsets.all(60),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _loadingRoute = false);
//       _showError('فشل في جلب المسار');
//     }
//   }

//   // ══ MINI CARD TAP → ROUTE ═════════════════════════════════════════════════
//   Future<void> _goToSaved(SavedLocation loc) async {
//     final point = LatLng(loc.lat, loc.lng);
//     if (_myLocation == null) {
//       _mapCtrl.move(point, 15);
//       return;
//     }
//     setState(() {
//       _destination = point;
//       _route = null;
//       _loadingRoute = true;
//       _markers = [];
//     });
//     try {
//       final route = await RoutingService.getRoute(
//         origin: _myLocation!,
//         destination: point,
//       );
//       if (!mounted) return;
//       setState(() {
//         _route = route;
//         _loadingRoute = false;
//       });
//       _mapCtrl.fitCamera(
//         CameraFit.bounds(
//           bounds: LatLngBounds.fromPoints(route.points),
//           padding: const EdgeInsets.all(60),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _loadingRoute = false);
//       _showError('فشل في جلب المسار');
//     }
//   }

//   // ══ OPEN ADD LOCATION SHEET ═══════════════════════════════════════════════
//   void _openAddSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (_) => AddLocationSheet(service: _savedService),
//     );
//   }

//   void _clearRoute() {
//     setState(() {
//       _destination = null;
//       _route = null;
//       _markers = [];
//     });
//     if (_myLocation != null) _mapCtrl.move(_myLocation!, 15);
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: Colors.red[400],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   // ══ BUILD ════════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     final bottomPad = MediaQuery.of(context).padding.bottom;
//     final topPad = MediaQuery.of(context).padding.top;
//     final colors = Theme.of(context).colorScheme;

//     return Scaffold(
//       key: _scaffoldKey,
//       body: Stack(
//         children: [
//           // ══ MAP ══════════════════════════════════════
//           FlutterMap(
//             mapController: _mapCtrl,
//             options: MapOptions(
//               initialCenter: const LatLng(30.0444, 31.2357),
//               initialZoom: 12,
//               minZoom: 5,
//               maxZoom: 18,
//               onTap: _onMapTap,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: _tileUrl,
//                 subdomains: const ['a', 'b', 'c', 'd'],
//                 userAgentPackageName: 'com.example.drift',
//                 maxZoom: 19,
//               ),
//               if (_route != null)
//                 PolylineLayer(
//                   polylines: [
//                     Polyline(
//                       points: _route!.points,
//                       strokeWidth: 8,
//                       color: colors.primary,
//                       borderStrokeWidth: 2,
//                       borderColor: Colors.white.withOpacity(0.6),
//                     ),
//                   ],
//                 ),
//               MarkerLayer(
//                 markers: [
//                   if (_myLocation != null)
//                     Marker(
//                       point: _myLocation!,
//                       width: 44,
//                       height: 44,
//                       child: const UserLocationMarker(),
//                     ),
//                   if (_destination != null)
//                     Marker(
//                       point: _destination!,
//                       width: 44,
//                       height: 44,
//                       child: const DestinationMarker(),
//                     ),
//                   ..._markers,
//                 ],
//               ),
//             ],
//           ),

//           // ══ GPS LOADING ══════════════════════════════
//           if (_loadingGPS)
//             ColoredBox(
//               color: Colors.black,
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircularProgressIndicator(color: colors.primary),
//                     const SizedBox(height: 14),
//                     Text(
//                       'جاري تحديد موقعك...',
//                       style: TextStyle(fontSize: 15, color: colors.onSurface),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//           // ══ SEARCH BAR + MINI CARDS ═══════════════════
//           Positioned(
//             top: topPad + 10,
//             left: 16,
//             right: 16,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomTextField(
//                         controller: _searchController,
//                         hintText: 'Search City...',
//                         hintSize: 22,
//                         fillColor: colors.background,
//                         suffixIcon: IconButton(
//                           icon: Padding(
//                             padding: const EdgeInsets.only(right: 10),
//                             child: Icon(Icons.search, color: colors.onSurface),
//                           ),
//                           onPressed: () => _search(),
//                         ),
//                         onSubmitted: (context) => _search(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: EdgeInsets.all(3),
//                       decoration: BoxDecoration(
//                         border: BoxBorder.all(
//                           color: colors.onSurface,
//                           width: 2,
//                         ),
//                         shape: BoxShape.circle,
//                         color: colors.background,
//                       ),
//                       child: IconButton(
//                         onPressed: () {
//                           _scaffoldKey.currentState?.openEndDrawer();
//                         },
//                         icon: Icon(Icons.menu_rounded, color: colors.onSurface),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),

//                 // ── Mini Cards (Firebase real-time) ──────────────────────────
//                 StreamBuilder<List<SavedLocation>>(
//                   stream: _savedService.stream(),
//                   builder: (context, snapshot) {
//                     final locations = snapshot.data ?? [];
//                     if (locations.isEmpty) return const SizedBox.shrink();
//                     return SizedBox(
//                       height: 50,
//                       child: ListView.separated(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: locations.length,
//                         // ignore: unnecessary_underscores
//                         separatorBuilder: (_, __) => const SizedBox(width: 8),
//                         itemBuilder: (_, i) => MiniCard(
//                           label: locations[i].name,
//                           onTap: () => _goToSaved(locations[i]),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // ══ MAP STYLE BUTTONS ════════════════════════
//           Positioned(
//             bottom: 155,
//             right: 16,
//             child: Column(
//               children: [
//                 FabBtn(
//                   icon: Icons.light_mode,
//                   color: colors.onSurface,
//                   onTap: () => setState(
//                     () => _tileUrl =
//                         'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 FabBtn(
//                   icon: Icons.dark_mode,
//                   color: colors.onSurface,
//                   onTap: () => setState(
//                     () => _tileUrl =
//                         'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 FabBtn(
//                   icon: Icons.my_location_rounded,
//                   color: colors.onSurface,
//                   onTap: () {
//                     if (_myLocation != null) _mapCtrl.move(_myLocation!, 16);
//                   },
//                 ),
//                 const SizedBox(height: 8),

//                 // ── Add saved location ────────────────────────────────────────
//                 FabBtn(
//                   icon: Icons.add_location_alt_rounded,
//                   color: colors.onSurface,
//                   onTap: _openAddSheet,
//                 ),

//                 // ── Clear route (only when route is active) ───────────────────
//                 if (_destination != null) ...[
//                   const SizedBox(height: 8),
//                   FabBtn(
//                     icon: Icons.clear_rounded,
//                     color: Colors.red,
//                     onTap: _clearRoute,
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           // ══ ROUTE LOADING ════════════════════════════
//           if (_loadingRoute)
//             Positioned(
//               bottom: bottomPad + 20,
//               left: 0,
//               right: 0,
//               child: const Center(child: LoadingPill()),
//             ),

//           // ══ ROUTE INFO ═══════════════════════════════
//           if (_route != null)
//             Positioned(
//               bottom: bottomPad,
//               left: 0,
//               right: 0,
//               child: RouteInfoSheet(route: _route!, onClear: _clearRoute),
//             ),
//         ],
//       ),
//       endDrawer: CustomDrawer(),
//       bottomSheet: GlassCont(height: 155,),
//     );
//   }
// }



// import 'package:drift_app/helper/const.dart';
// import 'package:drift_app/pages/map_page.dart';
// import 'package:drift_app/widgets/custom_button.dart';
// import 'package:flutter/material.dart';

// class HistoryPage extends StatelessWidget {
//   const HistoryPage({super.key});

//   static String id = 'History Page';

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Scaffold(
//       backgroundColor: colors.background,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               const SizedBox(height: 15),
//               Row(
//                 children: [
                 
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: Icon(Icons.arrow_back_ios_new, color: colors.onSurface,size: 25,),
//                   ),
          
//                   Text
//                   (
//                     'History',
//                     style:TextStyle
//                     (
//                       color: colors.onSurface,
//                       fontFamily: fontFamily,
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold
//                     ) ,
//                   )
//                 ],
//               ),
          
//               const SizedBox(height: 55,),
          
//               SizedBox
//               (
//                 height: 250,
//                 child: Image.asset(logoPath2)
//               ),
//               const SizedBox(height: 10,),
          
//                   Padding(
//                     padding: const EdgeInsets.only(left: 38.0),
//                     child: Text
//                     (
//                       "You didn't make trips yet",
//                       style:TextStyle
//                       (
//                         color: colors.onSurface,
//                         fontFamily: fontFamily,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold
//                       ) ,
//                     ),
//                   ),

//                   SizedBox(
//                     width: 300,
//                     child: CustomButtom
//                     (
//                       backgroundColor: colors.surface, 
//                       text: 'Make one Now',
//                       icon: IconButton
//                       (
//                         onPressed: ()=> Navigator.pushNamed(context, MapPage.id), 
//                         icon: Icon
//                         (
//                           Icons.arrow_forward_rounded,
//                           size: 35,
//                           color: colors.onSurface,
//                         )
//                       ),
//                     ),
//                   )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//=======================================================================================

// ══════════════════════════════════════════════════════════════════════════════
//  HOW TO USE — from anywhere in the app:
//
//  showModalBottomSheet(
//    context: context,
//    isScrollControlled: true,
//    shape: RoundedRectangleBorder(
//      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//    ),
//    builder: (_) => AddLocationSheet(service: _savedService),
//  );
// ══════════════════════════════════════════════════════════════════════════════
