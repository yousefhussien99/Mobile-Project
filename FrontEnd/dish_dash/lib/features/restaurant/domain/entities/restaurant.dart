// lib/domain/entities/restaurant.dart
class Restaurant {
  final int id;
  final String name;
  final String type;
  final String location;
  final double latitude;
  final double longitude;

  Restaurant({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.latitude,
    required this.longitude,
  });
}