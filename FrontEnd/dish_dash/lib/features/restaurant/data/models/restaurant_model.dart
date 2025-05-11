import '../../domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.type,
    required super.location,
    required super.latitude,
    required super.longitude,
    required super.imgUrl,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? 0,  // Default value if key is missing or null
      name: json['name'] ?? 'Unknown',  // Default value for name
      type: json['type'] ?? 'Unknown',  // Default value for type
      location: json['location'] ?? 'Unknown',  // Default value for location
      latitude: json['latitude']?.toDouble() ?? 0.0,  // Handle possible null
      longitude: json['longitude']?.toDouble() ?? 0.0,  // Handle possible null
      imgUrl: json['imgUrl'] ?? '',  // Default empty string if null
    );
  }
}
