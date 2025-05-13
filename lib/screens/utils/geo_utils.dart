import 'dart:math';

class GeoUtils {
  static const double earthRadius = 6371000; // Earth's radius in meters

  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final double lat1Rad = lat1 * pi / 180;
    final double lon1Rad = lon1 * pi / 180;
    final double lat2Rad = lat2 * pi / 180;
    final double lon2Rad = lon2 * pi / 180;

    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;

    return distance;
  }

  static bool isWithinGeofence(
    double lat,
    double lon,
    double centerLat,
    double centerLon,
    double radius,
  ) {
    final distance = calculateDistance(lat, lon, centerLat, centerLon);
    return distance <= radius;
  }
}
