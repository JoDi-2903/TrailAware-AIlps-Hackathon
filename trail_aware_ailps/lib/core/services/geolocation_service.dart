import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/authority.dart';
import '../models/authority_mock_data.dart';

/// Provides current device position and resolves the responsible authority
/// for a given set of coordinates.
class GeolocationService {
  /// Request permission if needed and return the current position.
  /// Returns `null` if permission is denied, location unavailable, or on
  /// simulator — never throws.
  Future<Position?> getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      // Simulator / no GPS hardware → caller falls back to mock coordinates.
      return null;
    }
  }

  /// Mock elevation derived from coordinates (clamps to realistic Alpine range).
  /// Real implementation would call an elevation API (e.g. Open-Elevation).
  double getElevation(double lat, double lng) {
    return (lat * 30 + lng.abs() * 15).clamp(800, 3500);
  }

  /// Find the nearest authority whose jurisdiction covers [lat, lng].
  /// Falls back to the first authority if none match.
  Authority resolveAuthority(double lat, double lng) {
    Authority nearest = kMockAuthorities.first;
    double minDistance = double.infinity;

    for (final authority in kMockAuthorities) {
      final distance = _haversineKm(
        lat,
        lng,
        authority.centerCoordinate.latitude,
        authority.centerCoordinate.longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
        nearest = authority;
      }
    }

    return nearest;
  }

  /// Haversine great-circle distance in kilometers.
  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const double r = 6371; // Earth radius km
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _toRad(double deg) => deg * pi / 180;

  /// Returns a `LatLng` for flutter_map from a `Position`.
  LatLng positionToLatLng(Position pos) => LatLng(pos.latitude, pos.longitude);
}
