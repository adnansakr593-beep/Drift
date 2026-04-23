// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
// import '../models/route_info.dart';

// class RoutingService {
//   static const _base = 'http://router.project-osrm.org/route/v1/driving';

//   static Future<RouteInfo> getRoute({
//     required LatLng origin,
//     required LatLng destination,
//   }) async {
//     // ⚠️ OSRM بياخد longitude أولاً ثم latitude
//     final url = Uri.parse(
//       '$_base/'
//       '${origin.longitude},${origin.latitude};'
//       '${destination.longitude},${destination.latitude}'
//       '?overview=full&geometries=polyline',
//     );

//     final res = await http.get(url).timeout(const Duration(seconds: 15));
//     if (res.statusCode != 200) throw Exception('Server error');

//     final json = jsonDecode(res.body) as Map<String, dynamic>;
//     if (json['code'] != 'Ok') throw Exception('OSRM error');

//     final route = json['routes'][0];
//     return RouteInfo(
//       points: PolylineDecoder.decode(route['geometry'] as String),
//       distanceMeters: (route['distance'] as num).toDouble(),
//       durationSeconds: (route['duration'] as num).toDouble(),
//     );
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/route_info.dart';

class RoutingService {
  // Primary: OSRM demo server
  static const _primary = 'http://router.project-osrm.org/route/v1/driving';
  // Fallback: OpenRouteService (free, no key needed for basic use)
  // ignore: unused_field
  static const _fallback = 'https://api.openrouteservice.org/v2/directions/driving-car';

  static Future<RouteInfo> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      return await _osrmRoute(origin, destination);
    } catch (e) {
      // Try fallback with straight-line if everything fails
      return _straightLineRoute(origin, destination);
    }
  }

  static Future<RouteInfo> _osrmRoute(LatLng origin, LatLng dest) async {
    final url = Uri.parse(
      '$_primary/'
      '${origin.longitude},${origin.latitude};'
      '${dest.longitude},${dest.latitude}'
      '?overview=full&geometries=polyline',
    );

    final res = await http.get(
      url,
      headers: {'User-Agent': 'DriftApp/1.0'},
    ).timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final code = json['code'];
    
    if (code != 'Ok') {
      throw Exception('OSRM code: $code — ${json['message'] ?? ''}');
    }

    final route = json['routes'][0];
    return RouteInfo(
      points: PolylineDecoder.decode(route['geometry'] as String),
      distanceMeters: (route['distance'] as num).toDouble(),
      durationSeconds: (route['duration'] as num).toDouble(),
    );
  }

  // Straight-line fallback — draws a direct line between two points
  static RouteInfo _straightLineRoute(LatLng origin, LatLng dest) {
    const Distance distance = Distance();
    final meters = distance.as(LengthUnit.Meter, origin, dest);
    return RouteInfo(
      points: [origin, dest],
      distanceMeters: meters,
      durationSeconds: meters / 10, // rough estimate ~36 km/h
    );
  }
}