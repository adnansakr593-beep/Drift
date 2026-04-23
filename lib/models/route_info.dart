import 'package:latlong2/latlong.dart';

class RouteInfo {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;

  RouteInfo({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds, double? routeDurationMin,
  });

  String get distanceText {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '${distanceMeters.toInt()} m';
  }

  String get durationText {
    final minutes = (durationSeconds / 60).round();
    if (minutes >= 60) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      return '${h}h ${m}m';
    }
    return '$minutes دقيقة';
  }
}

class PolylineDecoder {
  static List<LatLng> decode(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }
}