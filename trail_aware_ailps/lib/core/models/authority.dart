import 'package:latlong2/latlong.dart';

/// Represents a trail authority responsible for a geographic region.
class Authority {
  const Authority({
    required this.id,
    required this.name,
    required this.responsibleRegion,
    required this.contactEmail,
    required this.centerCoordinate,
    required this.radiusKm,
  });

  final String id;
  final String name;
  final String responsibleRegion;
  final String contactEmail;
  final LatLng centerCoordinate;

  /// Jurisdiction radius in kilometers — used for geo-routing incoming reports.
  final double radiusKm;
}
