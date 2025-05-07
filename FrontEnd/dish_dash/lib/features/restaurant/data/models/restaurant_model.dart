// lib/data/models/restaurant_model.dart
import '../../domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  RestaurantModel({
    required int id,
    required String name,
    required String type,
    required String location,
    required double latitude,
    required double longitude,
  }) : super(
          id: id,
          name: name,
          type: type,
          location: location,
          latitude: latitude,
          longitude: longitude,
        );

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}