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
// // ignore_for_file: deprecated_member_use
// import 'dart:async';
// import 'dart:convert';
// import 'package:drift_app/helper/const.dart';
// import 'package:drift_app/widgets/glass_cont.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';

// enum TripMode { ride, cityToCity, delivery, takeMeOut }

// enum TripState { idle, searchingDriver, driverFound }

// class TripBottomSheet extends StatefulWidget {
//   final LatLng? myLocation;
//   final Function(LatLng destination, String cityName) onDestinationSelected;
//   final VoidCallback onClear;

//   const TripBottomSheet({
//     super.key,
//     required this.myLocation,
//     required this.onDestinationSelected,
//     required this.onClear,
//   });

//   @override
//   State<TripBottomSheet> createState() => TripBottomSheetState();
// }

// class TripBottomSheetState extends State<TripBottomSheet>
//     with TickerProviderStateMixin {
//   TripMode _selectedMode = TripMode.ride;
//   TripState _tripState = TripState.idle;

//   final TextEditingController _citySearchController = TextEditingController();
//   List<_PlaceSuggestion> _suggestions = [];
//   bool _loadingSearch = false;
//   bool _showSuggestions = false;
//   Timer? _debounce;

//   // Route info
//   String? _selectedCity;
//   double _price = 0;
//   double _basePriceKm = 3.5; // EGP per km
//   double? _routeDistanceKm;
//   double? _routeDurationMin;
//   bool _hasRoute = false;

//   // Driver search
//   // ignore: unused_field
//   int _driversFound = 0;
//   Timer? _driverSearchTimer;
//   late AnimationController _pulseController;
//   late AnimationController _slideController;
//   late Animation<double> _slideAnimation;

//   final DraggableScrollableController _sheetController =
//       DraggableScrollableController();

//   static const Map<TripMode, _ModeInfo> _modeInfo = {
//     TripMode.ride: _ModeInfo(
//       icon: Icons.directions_car_rounded,
//       label: 'Ride',
//       color: Color(0xFF6C63FF),
//     ),
//     TripMode.cityToCity: _ModeInfo(
//       icon: Icons.route_rounded,
//       label: 'City to City',
//       color: Color(0xFF00C9A7),
//     ),
//     TripMode.delivery: _ModeInfo(
//       icon: Icons.delivery_dining_rounded,
//       label: 'Delivery',
//       color: Color(0xFFFF6B6B),
//     ),
//     TripMode.takeMeOut: _ModeInfo(
//       icon: Icons.explore_rounded,
//       label: 'Take Me Out',
//       color: Color(0xFFFFBE0B),
//     ),
//   };

//   @override
//   void initState() {
//     super.initState();
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..repeat(reverse: true);

//     _slideController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//     _slideAnimation = CurvedAnimation(
//       parent: _slideController,
//       curve: Curves.easeOutCubic,
//     );
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _driverSearchTimer?.cancel();
//     _pulseController.dispose();
//     _slideController.dispose();
//     _citySearchController.dispose();
//     super.dispose();
//   }

//   // ══ SEARCH ════════════════════════════════════════════════════════════════
//   void _onSearchChanged(String value) {
//     _debounce?.cancel();
//     if (value.trim().length < 2) {
//       setState(() {
//         _suggestions = [];
//         _showSuggestions = false;
//       });
//       return;
//     }
//     _debounce = Timer(const Duration(milliseconds: 450), () {
//       _fetchSuggestions(value.trim());
//     });
//   }

//   Future<void> _fetchSuggestions(String query) async {
//     setState(() => _loadingSearch = true);
//     try {
//       final url = Uri.parse(
//         'https://nominatim.openstreetmap.org/search'
//         '?q=${Uri.encodeComponent(query)}&format=json&limit=5&addressdetails=1',
//       );
//       final res = await http.get(url, headers: {'User-Agent': 'DriftApp/1.0'});
//       final data = jsonDecode(res.body) as List;
//       setState(() {
//         _suggestions = data
//             .map(
//               (e) => _PlaceSuggestion(
//                 displayName: e['display_name'] ?? '',
//                 shortName: _shortName(e),
//                 lat: double.parse(e['lat']),
//                 lon: double.parse(e['lon']),
//               ),
//             )
//             .toList();
//         _showSuggestions = true;
//         _loadingSearch = false;
//       });
//     } catch (_) {
//       setState(() => _loadingSearch = false);
//     }
//   }

//   String _shortName(Map e) {
//     final addr = e['address'] as Map? ?? {};
//     return addr['city'] ??
//         addr['town'] ??
//         addr['village'] ??
//         addr['county'] ??
//         e['display_name']?.toString().split(',').first ??
//         '';
//   }

//   void _selectPlace(_PlaceSuggestion place) {
//     setState(() {
//       _selectedCity = place.shortName;
//       _citySearchController.text = place.shortName;
//       _showSuggestions = false;
//       _suggestions = [];
//     });
//     widget.onDestinationSelected(LatLng(place.lat, place.lon), place.shortName);
//     _expandSheet();
//   }

//   void _expandSheet() {
//     _sheetController.animateTo(
//       0.55,
//       duration: const Duration(milliseconds: 350),
//       curve: Curves.easeOutCubic,
//     );
//   }

//   // ══ ROUTE & PRICE ════════════════════════════════════════════════════════
//   void updateRouteInfo({
//     required double distanceKm,
//     required double durationMin,
//   }) {
//     final base = switch (_selectedMode) {
//       TripMode.ride => 3.5,
//       TripMode.cityToCity => 5.0,
//       TripMode.delivery => 4.0,
//       TripMode.takeMeOut => 6.0,
//     };
//     setState(() {
//       _routeDistanceKm = distanceKm;
//       _routeDurationMin = durationMin;
//       _basePriceKm = base;
//       _price = (distanceKm * base).clamp(25, 9999);
//       _hasRoute = true;
//     });
//     _slideController.forward(from: 0);
//   }

//   void clearRoute() {
//     setState(() {
//       _hasRoute = false;
//       _selectedCity = null;
//       _citySearchController.clear();
//       _tripState = TripState.idle;
//       _driversFound = 0;
//       _price = 0;
//     });
//     _slideController.reverse();
//     _driverSearchTimer?.cancel();
//     widget.onClear();
//   }

//   // ══ PRICE EDIT ═══════════════════════════════════════════════════════════
//   void _adjustPrice(double delta) {
//     setState(() {
//       _price = (_price + delta).clamp(10, 9999);
//     });
//   }

//   // ══ START TRIP ═══════════════════════════════════════════════════════════
//   void _startTrip() {
//     setState(() {
//       _tripState = TripState.searchingDriver;
//       _driversFound = 0;
//     });
//     _expandSheet();

//     // Simulate finding drivers progressively
//     int elapsed = 0;
//     _driverSearchTimer = Timer.periodic(const Duration(seconds: 2), (t) {
//       elapsed += 2;
//       if (!mounted) {
//         t.cancel();
//         return;
//       }

//       // Randomly find a driver between 4–14 seconds
//       if (elapsed >= 4 && (elapsed >= 14 || _randomBool(elapsed))) {
//         t.cancel();
//         setState(() {
//           _tripState = TripState.driverFound;
//           _driversFound = 1;
//         });
//       }
//     });
//   }

//   bool _randomBool(int elapsed) {
//     // Probability increases with time
//     final chance = (elapsed - 2) / 14.0;
//     return (DateTime.now().millisecondsSinceEpoch % 100) / 100.0 < chance;
//   }

//   void _cancelSearch() {
//     _driverSearchTimer?.cancel();
//     setState(() {
//       _tripState = TripState.idle;
//       _driversFound = 0;
//     });
//   }

//   // ══ BUILD ════════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return DraggableScrollableSheet(
//       controller: _sheetController,
//       initialChildSize: 0.22,
//       minChildSize: 0.14,
//       maxChildSize: 0.82,
//       snap: true,
//       snapSizes: const [0.22, 0.45, 0.82],
//       builder: (context, scrollController) {
//         return GlassCont(
//           top: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
//           right: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
//           left: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
//           padding: const EdgeInsets.symmetric(horizontal: 0),
//           child: ListView(
//             controller: scrollController,
//             padding: EdgeInsets.zero,
//             children: [
//               _buildHandle(colors),
//               _buildModeTabs(colors),
//               const SizedBox(height: 12),
//               _buildSearchBar(colors),
//               if (_showSuggestions) _buildSuggestions(colors),
//               if (_hasRoute && !_showSuggestions) ...[
//                 SlideTransition(
//                   position: Tween<Offset>(
//                     begin: const Offset(0, 0.3),
//                     end: Offset.zero,
//                   ).animate(_slideAnimation),
//                   child: FadeTransition(
//                     opacity: _slideAnimation,
//                     child: Column(
//                       children: [
//                         _buildRouteInfo(colors),
//                         _buildPriceEditor(colors),
//                         _buildStartButton(colors),
//                         const SizedBox(height: 24),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHandle(ColorScheme colors) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         width: 40,
//         height: 4,
//         decoration: BoxDecoration(
//           color: colors.onSurface.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(2),
//         ),
//       ),
//     );
//   }

//   Widget _buildModeTabs(ColorScheme colors) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: TripMode.values.map((mode) {
//           final info = _modeInfo[mode]!;
//           final selected = _selectedMode == mode;
//           return Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 setState(() => _selectedMode = mode);
//                 if (_hasRoute) {
//                   updateRouteInfo(
//                     distanceKm: _routeDistanceKm ?? 0,
//                     durationMin: _routeDurationMin ?? 0,
//                   );
//                 }
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 220),
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                   color: selected
//                       ? info.color.withOpacity(0.15)
//                       : colors.surfaceVariant.withOpacity(0.4),
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(
//                     color: selected ? info.color : Colors.transparent,
//                     width: 1.5,
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       info.icon,
//                       color: selected
//                           ? info.color
//                           : colors.onSurface.withOpacity(0.45),
//                       size: 22,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       info.label,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: selected
//                             ? FontWeight.w700
//                             : FontWeight.w400,
//                         color: selected
//                             ? info.color
//                             : colors.onSurface.withOpacity(0.5),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildSearchBar(ColorScheme colors) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Container(
//         decoration: BoxDecoration(
//           color: colors.surfaceVariant.withOpacity(0.5),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: colors.onSurface.withOpacity(0.12)),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 14),
//             Icon(
//               Icons.search_rounded,
//               color: colors.onSurface.withOpacity(0.4),
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 controller: _citySearchController,
//                 onChanged: _onSearchChanged,
//                 style: TextStyle(color: colors.onSurface, fontSize: 15),
//                 decoration: InputDecoration(
//                   hintText: _hintText,
//                   hintStyle: TextStyle(
//                     color: colors.onSurface.withOpacity(0.35),
//                     fontSize: 15,
//                   ),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//               ),
//             ),
//             if (_loadingSearch)
//               Padding(
//                 padding: const EdgeInsets.only(right: 12),
//                 child: SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: colors.primary,
//                   ),
//                 ),
//               )
//             else if (_selectedCity != null)
//               IconButton(
//                 icon: Icon(
//                   Icons.close_rounded,
//                   color: colors.onSurface.withOpacity(0.4),
//                   size: 18,
//                 ),
//                 onPressed: clearRoute,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   String get _hintText {
//     return switch (_selectedMode) {
//       TripMode.ride => 'Where to?',
//       TripMode.cityToCity => 'Destination city...',
//       TripMode.delivery => 'Delivery address...',
//       TripMode.takeMeOut => 'Surprise me... or pick a city',
//     };
//   }

//   Widget _buildSuggestions(ColorScheme colors) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
//       decoration: BoxDecoration(
//         color: colors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: colors.onSurface.withOpacity(0.1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.12),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Column(
//           children: _suggestions.asMap().entries.map((entry) {
//             final i = entry.key;
//             final s = entry.value;
//             return InkWell(
//               onTap: () => _selectPlace(s),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 13,
//                 ),
//                 decoration: BoxDecoration(
//                   border: i < _suggestions.length - 1
//                       ? Border(
//                           bottom: BorderSide(
//                             color: colors.onSurface.withOpacity(0.07),
//                           ),
//                         )
//                       : null,
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(7),
//                       decoration: BoxDecoration(
//                         color: colors.primary.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.place_rounded,
//                         color: colors.primary,
//                         size: 15,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             s.shortName,
//                             style: TextStyle(
//                               color: colors.onSurface,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                             ),
//                           ),
//                           Text(
//                             s.displayName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: colors.onSurface.withOpacity(0.45),
//                               fontSize: 11,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildRouteInfo(ColorScheme colors) {
//     final mode = _modeInfo[_selectedMode]!;
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: mode.color.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: mode.color.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           Icon(mode.icon, color: mode.color, size: 28),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _selectedCity ?? '',
//                   style: TextStyle(
//                     color: colors.onSurface,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   '${_routeDistanceKm?.toStringAsFixed(1) ?? '--'} km  •  ${_routeDurationMin?.toStringAsFixed(0) ?? '--'} min',
//                   style: TextStyle(
//                     color: colors.onSurface.withOpacity(0.5),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               color: mode.color.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               mode.label,
//               style: TextStyle(
//                 color: mode.color,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 11,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPriceEditor(ColorScheme colors) {
//     final mode = _modeInfo[_selectedMode]!;
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       decoration: BoxDecoration(
//         color: colors.surfaceVariant.withOpacity(0.4),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: colors.onSurface.withOpacity(0.1)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Offer Price',
//                   style: TextStyle(
//                     color: colors.onSurface.withOpacity(0.5),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   'EGP ${_price.toStringAsFixed(0)}',
//                   style: TextStyle(
//                     color: colors.onSurface,
//                     fontSize: 26,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 Text(
//                   '${_basePriceKm.toStringAsFixed(1)} EGP/km  •  tap ↑↓ to adjust',
//                   style: TextStyle(
//                     color: colors.onSurface.withOpacity(0.35),
//                     fontSize: 10,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               _PriceArrowBtn(
//                 icon: Icons.keyboard_arrow_up_rounded,
//                 color: mode.color,
//                 onTap: () => _adjustPrice(5),
//               ),
//               const SizedBox(height: 6),
//               _PriceArrowBtn(
//                 icon: Icons.keyboard_arrow_down_rounded,
//                 color: Colors.redAccent,
//                 onTap: () => _adjustPrice(-5),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStartButton(ColorScheme colors) {
//     if (_tripState == TripState.searchingDriver) {
//       return _buildSearchingDriverUI(colors);
//     }
//     if (_tripState == TripState.driverFound) {
//       return _buildDriverFoundUI(colors);
//     }

//     final mode = _modeInfo[_selectedMode]!;
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//       child: GestureDetector(
//         onTap: _startTrip,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 17),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [mode.color, mode.color.withOpacity(0.75)],
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: mode.color.withOpacity(0.4),
//                 blurRadius: 20,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.local_taxi_rounded, color: Colors.white, size: 22),
//               SizedBox(width: 10),
//               Text(
//                 'Start Trip',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 17,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 0.3,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchingDriverUI(ColorScheme colors) {
//     final mode = _modeInfo[_selectedMode]!;
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//       child: Column(
//         children: [
//           AnimatedBuilder(
//             animation: _pulseController,
//             // ignore: unnecessary_underscores
//             builder: (_, __) {
//               return Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 18),
//                 decoration: BoxDecoration(
//                   color: mode.color.withOpacity(
//                     0.08 + _pulseController.value * 0.07,
//                   ),
//                   borderRadius: BorderRadius.circular(18),
//                   border: Border.all(
//                     color: mode.color.withOpacity(
//                       0.3 + _pulseController.value * 0.3,
//                     ),
//                     width: 1.5,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       width: 32,
//                       height: 32,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 3,
//                         color: mode.color,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'Searching for drivers nearby...',
//                       style: TextStyle(
//                         color: colors.onSurface,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 15,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Offer: EGP ${_price.toStringAsFixed(0)}',
//                       style: TextStyle(
//                         color: mode.color,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 10),
//           GestureDetector(
//             onTap: _cancelSearch,
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: Colors.red.withOpacity(0.3)),
//               ),
//               child: const Center(
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(
//                     color: Colors.redAccent,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDriverFoundUI(ColorScheme colors) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color(0xFF00C9A7).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: const Color(0xFF00C9A7).withOpacity(0.4)),
//         ),
//         child: Column(
//           children: [
//             const Icon(
//               Icons.check_circle_rounded,
//               color: Color(0xFF00C9A7),
//               size: 40,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Driver Found!',
//               style: TextStyle(
//                 color: colors.onSurface,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Your driver is on the way',
//               style: TextStyle(
//                 color: colors.onSurface.withOpacity(0.5),
//                 fontSize: 13,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const CircleAvatar(
//                   radius: 22,
//                   backgroundColor: Color(0xFF00C9A7),
//                   child: Icon(
//                     Icons.person_rounded,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Adnan Sakr',
//                       style: TextStyle(
//                         color: colors.onSurface,
//                         fontWeight: FontWeight.w700,
//                         fontFamily: fontFamily,
//                         fontSize: 15,
//                       ),
//                     ),
//                     Text(
//                       '⭐ 5.0 • Toyota Supra • SAk 272',
//                       style: TextStyle(
//                         color: colors.onSurface.withOpacity(0.5),
//                         fontSize: 12,
//                         fontFamily: fontFamily,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 14),
//             Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       // call driver action
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF00C9A7).withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.call_rounded,
//                             color: Color(0xFF00C9A7),
//                             size: 18,
//                           ),
//                           SizedBox(width: 6),
//                           Text(
//                             'Call',
//                             style: TextStyle(
//                               color: Color(0xFF00C9A7),
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: clearRoute,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.red.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.close_rounded,
//                             color: Colors.redAccent,
//                             size: 18,
//                           ),
//                           SizedBox(width: 6),
//                           Text(
//                             'Cancel',
//                             style: TextStyle(
//                               color: Colors.redAccent,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Helpers ────────────────────────────────────────────────────────────────────

// class _PlaceSuggestion {
//   final String displayName;
//   final String shortName;
//   final double lat;
//   final double lon;
//   const _PlaceSuggestion({
//     required this.displayName,
//     required this.shortName,
//     required this.lat,
//     required this.lon,
//   });
// }

// class _ModeInfo {
//   final IconData icon;
//   final String label;
//   final Color color;
//   const _ModeInfo({
//     required this.icon,
//     required this.label,
//     required this.color,
//   });
// }

// class _PriceArrowBtn extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;
//   const _PriceArrowBtn({
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.12),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, color: color, size: 22),
//       ),
//     );
//   }
// }
//========================================================================================
// // ignore_for_file: deprecated_member_use
// import 'dart:async';
// import 'dart:convert';
// import 'package:drift_app/cubits/theme_cubit/theme_cubit.dart';
// import 'package:drift_app/cubits/theme_cubit/theme_state.dart';
// import 'package:drift_app/services/saved_locations_service_firebase.dart';
// import 'package:drift_app/widgets/custom_drawer.dart';
// import 'package:drift_app/widgets/custom_text_field.dart';
// import 'package:drift_app/widgets/fab_btn.dart';
// import 'package:drift_app/widgets/loading_pill.dart';
// import 'package:drift_app/widgets/mini_cards.dart';
// import 'package:drift_app/widgets/trip_bottom_sheet.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
// import '../models/route_info.dart';
// import '../models/saved_location_model.dart';
// import '../pages/add_save_location.dart';
// import '../services/location_service.dart';
// import '../services/routing_service.dart';
// import '../widgets/map_markers.dart';

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

//   final GlobalKey<TripBottomSheetState> _tripSheetKey =
//       GlobalKey<TripBottomSheetState>();

//   StreamSubscription? _gpsSub;
//   final TextEditingController _searchController = TextEditingController();
//   List<Marker> _markers = [];
//   late String mapMode;
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

//   // ══ SEARCH (top bar) ══════════════════════════════════════════════════════
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

//       // 👇 Notify the trip sheet about the new route
//       final distKm = route.distanceMeters / 1000;
//       final durMin = route.durationSeconds / 60;
//       _tripSheetKey.currentState?.updateRouteInfo(
//         distanceKm: distKm,
//         durationMin: durMin,
//       );
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _loadingRoute = false);
//       _showError('فشل في جلب المسار');
//     }
//   }

//   // ══ TRIP SHEET: destination selected ═════════════════════════════════════
//   Future<void> _onTripDestinationSelected(LatLng point, String cityName) async {
//     if (_myLocation == null) {
//       _mapCtrl.move(point, 13);
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

//       // Update trip sheet with route info
//       final distKm = route.distanceMeters / 1000;
//       final durMin = route.durationSeconds / 60;
//       _tripSheetKey.currentState?.updateRouteInfo(
//         distanceKm: distKm,
//         durationMin: durMin,
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
//       _showError('Route failed: ${e.toString()}');
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
//     _tripSheetKey.currentState?.clearRoute();
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
//               maxZoom: 19,
//               onTap: _onMapTap,
//             ),
//             children: [
//               BlocListener<ThemeCubit, ThemeState>(
//                 listener: (context, state) {
//                   if (state.themeMode == ThemeMode.light) {
//                     setState(() {
//                       _tileUrl =
//                           'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';
//                     });
//                   } else {
//                     _tileUrl =
//                         'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
//                   }
//                 },
//                 child: TileLayer(
//                   urlTemplate: _tileUrl,
//                   subdomains: const ['a', 'b', 'c', 'd'],
//                   userAgentPackageName: 'com.example.drift',
//                   maxZoom: 19,
//                 ),
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
//                         hintSize: 18,
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
//                       padding: const EdgeInsets.all(3),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           // ← fixed (was BoxBorder.all)
//                           color: colors.onSurface.withOpacity(0.6),
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
//             bottom: 200, // raised to sit above the bottom sheet
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
//                 FabBtn(
//                   icon: Icons.add_location_alt_rounded,
//                   color: colors.onSurface,
//                   onTap: _openAddSheet,
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
//               bottom: bottomPad + 180,
//               left: 0,
//               right: 0,
//               child: const Center(child: LoadingPill()),
//             ),

//           // ══ TRIP BOTTOM SHEET ════════════════════════
//           // Replaces the old GlassCont and RouteInfoSheet
//           Positioned.fill(
//             child: TripBottomSheet(
//               key: _tripSheetKey,
//               myLocation: _myLocation,
//               onDestinationSelected: _onTripDestinationSelected,
//               onClear: () {
//                 setState(() {
//                   _destination = null;
//                   _route = null;
//                   _markers = [];
//                 });
//                 if (_myLocation != null) _mapCtrl.move(_myLocation!, 15);
//               },
//             ),
//           ),
//         ],
//       ),
//       endDrawer: CustomDrawer(),
//     );
//   }
// }
//==========================================================================================

// import 'package:drift_app/classes/mode_info.dart';
// import 'package:drift_app/widgets/price_arrow.dart';
// import 'package:flutter/material.dart';

// class PriceEditor extends StatelessWidget {
//   final double price;
//   final double basePriceKm;
//   final void Function() onTapPluse;
//   final void Function() onTapminse;
//   final ModeInfo mode;
//   const PriceEditor(
//       {super.key,
//       required this.price,
//       required this.basePriceKm,
//       required this.onTapPluse,
//       required this.onTapminse,
//       required this.mode});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       decoration: BoxDecoration(
//         color: colors.surfaceVariant.withOpacity(0.4),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: colors.onSurface.withOpacity(0.1)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Offer Price',
//                   style: TextStyle(
//                     color: colors.onSurface.withOpacity(0.5),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   'EGP ${price.toStringAsFixed(0)}',
//                   style: TextStyle(
//                     color: colors.onSurface,
//                     fontSize: 26,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 Text(
//                   '${basePriceKm.toStringAsFixed(1)} EGP/km  •  tap ↑↓ to adjust',
//                   style: TextStyle(
//                     color: colors.onSurface.withOpacity(0.35),
//                     fontSize: 10,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               PriceArrowBtn(
//                 icon: Icons.keyboard_arrow_up_rounded,
//                 color: mode.color,
//                 onTap: onTapPluse,
//               ),
//               const SizedBox(height: 6),
//               PriceArrowBtn(
//                 icon: Icons.keyboard_arrow_down_rounded,
//                 color: Colors.redAccent,
//                 onTap: onTapminse,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//============================================================================================
// // ignore_for_file: deprecated_member_use
// import 'dart:async';
// import 'dart:convert';
// import 'package:drift_app/classes/mode_info.dart';
// import 'package:drift_app/classes/place_suggestion.dart';
// import 'package:drift_app/widgets/build_handle.dart';
// import 'package:drift_app/widgets/custom_search_bar.dart';
// import 'package:drift_app/widgets/glass_cont.dart';
// import 'package:drift_app/widgets/mode_tabs.dart';
// import 'package:drift_app/widgets/price_editor.dart';
// import 'package:drift_app/widgets/route_info.dart';
// import 'package:drift_app/widgets/start_button.dart';
// import 'package:drift_app/widgets/suggestions.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';

// enum TripMode { ride, cityToCity, delivery, takeMeOut }

// enum TripState { idle, searchingDriver, driverFound }

// class TripBottomSheet extends StatefulWidget {
//   final LatLng? myLocation;
//   final Function(LatLng destination, String cityName) onDestinationSelected;
//   final VoidCallback onClear;

//   const TripBottomSheet({
//     super.key,
//     required this.myLocation,
//     required this.onDestinationSelected,
//     required this.onClear,
//   });

//   @override
//   State<TripBottomSheet> createState() => TripBottomSheetState();
// }

// class TripBottomSheetState extends State<TripBottomSheet>
//     with TickerProviderStateMixin {
//   TripMode selectedMode = TripMode.ride;
//   TripState tripState = TripState.idle;

//   final TextEditingController citySearchController = TextEditingController();
//   List<PlaceSuggestion> suggestions = [];
//   bool loadingSearch = false;
//   bool _showSuggestions = false;
//   Timer? _debounce;

//   // Route info
//   String? selectedCity;
//   double price = 0;
//   double basePriceKm = 3.5; // EGP per km
//   double? routeDistanceKm;
//   double? routeDurationMin;
//   bool _hasRoute = false;

//   // Driver search
//   // ignore: unused_field
//   int _driversFound = 0;
//   Timer? _driverSearchTimer;
//   late AnimationController pulseController;
//   late AnimationController _slideController;
//   late Animation<double> _slideAnimation;

//   final DraggableScrollableController _sheetController =
//       DraggableScrollableController();

//   static const Map<TripMode, ModeInfo> modeInfo = {
//     TripMode.ride: ModeInfo(
//       icon: Icons.directions_car_rounded,
//       label: 'Ride',
//       color: Color(0xFF6C63FF),
//     ),
//     TripMode.cityToCity: ModeInfo(
//       icon: Icons.route_rounded,
//       label: 'City to City',
//       color: Color(0xFF00C9A7),
//     ),
//     TripMode.delivery: ModeInfo(
//       icon: Icons.delivery_dining_rounded,
//       label: 'Delivery',
//       color: Color(0xFFFF6B6B),
//     ),
//     TripMode.takeMeOut: ModeInfo(
//       icon: Icons.explore_rounded,
//       label: 'Take Me Out',
//       color: Color(0xFFFFBE0B),
//     ),
//   };

//   @override
//   void initState() {
//     super.initState();
//     pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..repeat(reverse: true);

//     _slideController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//     _slideAnimation = CurvedAnimation(
//       parent: _slideController,
//       curve: Curves.easeOutCubic,
//     );
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _driverSearchTimer?.cancel();
//     pulseController.dispose();
//     _slideController.dispose();
//     citySearchController.dispose();
//     super.dispose();
//   }

//   // ══ SEARCH ════════════════════════════════════════════════════════════════
//   onSearchChanged(String value) {
//     _debounce?.cancel();

//     if (value.trim().isEmpty) {
//       clearRoute();
//       return;
//     }
//     _debounce = Timer(const Duration(milliseconds: 450), () {
//       _fetchSuggestions(value.trim());
//     });
//   }

//   Future<void> _fetchSuggestions(String query) async {
//     setState(() => loadingSearch = true);
//     try {
//       final url = Uri.parse(
//         'https://nominatim.openstreetmap.org/search'
//         '?q=${Uri.encodeComponent(query)}&format=json&limit=5&addressdetails=1',
//       );
//       final res = await http.get(url, headers: {'User-Agent': 'DriftApp/1.0'});
//       final data = jsonDecode(res.body) as List;
//       setState(() {
//         suggestions = data
//             .map(
//               (e) => PlaceSuggestion(
//                 displayName: e['display_name'] ?? '',
//                 shortName: _shortName(e),
//                 lat: double.parse(e['lat']),
//                 lon: double.parse(e['lon']),
//               ),
//             )
//             .toList();
//         _showSuggestions = true;
//         loadingSearch = false;
//       });
//     } catch (_) {
//       setState(() => loadingSearch = false);
//     }
//   }

//   String _shortName(Map e) {
//     final addr = e['address'] as Map? ?? {};
//     return addr['city'] ??
//         addr['town'] ??
//         addr['village'] ??
//         addr['county'] ??
//         e['display_name']?.toString().split(',').first ??
//         '';
//   }

//   void selectPlace(PlaceSuggestion place) {
//     setState(() {
//       selectedCity = place.shortName;
//       citySearchController.text = place.shortName;
//       _showSuggestions = false;
//       suggestions = [];
//     });
//     widget.onDestinationSelected(LatLng(place.lat, place.lon), place.shortName);
//     _expandSheet();
//   }

//   void _expandSheet() {
//     _sheetController.animateTo(
//       0.55,
//       duration: const Duration(milliseconds: 350),
//       curve: Curves.easeOutCubic,
//     );
//   }

//   // ══ ROUTE & PRICE ════════════════════════════════════════════════════════
//   void updateRouteInfo({
//     required double distanceKm,
//     required double durationMin,
//   }) {
//     final base = switch (selectedMode) {
//       TripMode.ride => 3.5,
//       TripMode.cityToCity => 5.0,
//       TripMode.delivery => 4.0,
//       TripMode.takeMeOut => 6.0,
//     };
//     setState(() {
//       routeDistanceKm = distanceKm;
//       routeDurationMin = durationMin;
//       basePriceKm = base;
//       price = (distanceKm * base).clamp(25, 9999);
//       _hasRoute = true;
//     });
//     _slideController.forward(from: 0);
//   }

//   void clearRoute() {
//     setState(() {
//       _hasRoute = false;
//       selectedCity = null;
//       citySearchController.clear();
//       tripState = TripState.idle;
//       _driversFound = 0;
//       price = 0;
//     });
//     _slideController.reverse();
//     _driverSearchTimer?.cancel();
//     widget.onClear();
//   }

//   // ══ PRICE EDIT ═══════════════════════════════════════════════════════════
//   void adjustPrice(double delta) {
//     setState(() {
//       price = (price + delta).clamp(20, 9999);
//     });
//   }

//   // ══ START TRIP ═══════════════════════════════════════════════════════════
//   void startTrip() {
//     setState(() {
//       tripState = TripState.searchingDriver;
//       _driversFound = 0;
//     });
//     _expandSheet();

//     // Simulate finding drivers progressively
//     int elapsed = 0;
//     _driverSearchTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       elapsed += 2;
//       if (!mounted) {
//         t.cancel();
//         return;
//       }

//       // Randomly find a driver between 4–14 seconds
//       if (elapsed >= 4 && (elapsed >= 14 || _randomBool(elapsed))) {
//         t.cancel();
//         setState(() {
//           tripState = TripState.driverFound;
//           _driversFound = 5;
//         });
//       }
//     });
//   }

//   bool _randomBool(int elapsed) {
//     // Probability increases with time
//     final chance = (elapsed - 2) / 14.0;
//     return (DateTime.now().millisecondsSinceEpoch % 100) / 100.0 < chance;
//   }

//   void cancelSearch() {
//     _driverSearchTimer?.cancel();
//     setState(() {
//       tripState = TripState.idle;
//       _driversFound = 0;
//     });
//   }

//   // ══ BUILD ════════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return DraggableScrollableSheet(
//       controller: _sheetController,
//       initialChildSize: 0.22,
//       minChildSize: 0.14,
//       maxChildSize: 0.82,
//       snap: true,
//       snapSizes: const [0.22, 0.45, 0.82],
//       builder: (context, scrollController) {
//         return GlassCont(
//           top: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
//           right: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
//           left: BorderSide(color: colors.onSurface.withOpacity(0.3), width: 1),
//           padding: const EdgeInsets.symmetric(horizontal: 0),
//           child: ListView(
//             controller: scrollController,
//             padding: EdgeInsets.zero,
//             children: [
//               const BuildHandle(),
//               ModeTabs(
//                 modeInfo: modeInfo,
//                 selectedMode: selectedMode,
//                 onTap: (mode) {
//                   setState(() {
//                     selectedMode = mode;
//                   });

//                   if (_hasRoute &&
//                       routeDistanceKm != null &&
//                       routeDurationMin != null) {
//                     updateRouteInfo(
//                       distanceKm: routeDistanceKm!,
//                       durationMin: routeDurationMin!,
//                     );
//                   }
//                 },
//               ),
//               const SizedBox(height: 12),
//               CustomSearchBar(
//                 citySearchController: citySearchController,
//                 loadingSearch: loadingSearch,
//                 hintText: hintText,
//                 selectedCity: selectedCity,
//                 onChanged: onSearchChanged,
//                 onPressed: clearRoute,
//               ),
//               if (_showSuggestions)
//                 Suggestions(
//                   suggestions: suggestions,
//                   onTap: selectPlace,
//                 ),
//               if (_hasRoute && !_showSuggestions) ...[
//                 SlideTransition(
//                   position: Tween<Offset>(
//                     begin: const Offset(0, 0.3),
//                     end: Offset.zero,
//                   ).animate(_slideAnimation),
//                   child: FadeTransition(
//                     opacity: _slideAnimation,
//                     child: Column(
//                       children: [
//                         RouteInfo(
//                             mode: modeInfo[selectedMode]!,
//                             selectedCity: selectedCity,
//                             routeDistanceKm: routeDistanceKm,
//                             routeDurationMin: routeDurationMin),
//                         PriceEditor(
//                             price: price,
//                             basePriceKm: basePriceKm,
//                             onTapPluse: () => adjustPrice(5),
//                             onTapminse: () => adjustPrice(-5),
//                             mode: modeInfo[selectedMode]!),
//                         StartButton(
//                           tripState: tripState,
//                           modeInfo: modeInfo,
//                           selectedMode: selectedMode,
//                           pulseController: pulseController,
//                           price: price,
//                           onTapSearchinDriver: cancelSearch,
//                           onTapDriverFound: clearRoute,
//                           onTapStrartTrip: startTrip,
//                           mode: modeInfo[selectedMode]!,
//                         ),
//                         const SizedBox(height: 24),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   String get hintText {
//     return switch (selectedMode) {
//       TripMode.ride => 'Where to?',
//       TripMode.cityToCity => 'Destination city...',
//       TripMode.delivery => 'Delivery address...',
//       TripMode.takeMeOut => 'Surprise me... or pick a city',
//     };
//   }
// }



