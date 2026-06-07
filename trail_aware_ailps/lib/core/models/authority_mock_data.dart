import 'package:latlong2/latlong.dart';
import 'authority.dart';

/// Mock list of Alpine trail authorities for geo-routing.
/// In production this would be fetched from a backend API.
const List<Authority> kMockAuthorities = [
  Authority(
    id: 'NP-BERCHTESGADEN',
    name: 'Nationalpark Berchtesgaden',
    responsibleRegion: 'Bavaria, Germany',
    contactEmail: 'trails@nationalpark-berchtesgaden.de',
    centerCoordinate: LatLng(47.5500, 12.9800),
    radiusKm: 40,
  ),
  Authority(
    id: 'NP-GESAEUSE',
    name: 'Nationalpark Gesäuse',
    responsibleRegion: 'Styria, Austria',
    contactEmail: 'info@gesaeuse.at',
    centerCoordinate: LatLng(47.5800, 14.6200),
    radiusKm: 35,
  ),
  Authority(
    id: 'NP-HOHE-TAUERN',
    name: 'Nationalpark Hohe Tauern',
    responsibleRegion: 'Salzburg / Carinthia / Tyrol, Austria',
    contactEmail: 'office@hohetauern.at',
    centerCoordinate: LatLng(47.1000, 12.7000),
    radiusKm: 80,
  ),
  Authority(
    id: 'NP-GRAN-PARADISO',
    name: 'Parco Nazionale Gran Paradiso',
    responsibleRegion: "Aosta Valley, Italy",
    contactEmail: 'info@pngp.it',
    centerCoordinate: LatLng(45.5200, 7.2500),
    radiusKm: 50,
  ),
  Authority(
    id: 'CAI-AOSTA',
    name: 'Club Alpino Italiano — Sezione di Aosta',
    responsibleRegion: 'Aosta Valley, Italy',
    contactEmail: 'aosta@cai.it',
    centerCoordinate: LatLng(45.7370, 7.3200),
    radiusKm: 30,
  ),
];
