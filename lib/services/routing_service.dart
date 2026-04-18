import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/route_info.dart';

class RoutingService {
  static const _base = 'http://router.project-osrm.org/route/v1/driving';

  static Future<RouteInfo> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    // ⚠️ OSRM بياخد longitude أولاً ثم latitude
    final url = Uri.parse(
      '$_base/'
      '${origin.longitude},${origin.latitude};'
      '${destination.longitude},${destination.latitude}'
      '?overview=full&geometries=polyline',
    );

    final res = await http.get(url).timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) throw Exception('Server error');

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['code'] != 'Ok') throw Exception('OSRM error');

    final route = json['routes'][0];
    return RouteInfo(
      points: PolylineDecoder.decode(route['geometry'] as String),
      distanceMeters: (route['distance'] as num).toDouble(),
      durationSeconds: (route['duration'] as num).toDouble(),
    );
  }
}