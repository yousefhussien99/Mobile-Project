import '../../domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
   RestaurantModel({
    required super.id,
    required super.name,
    required super.logoUrl,
    required super.categories,
    required super.isOpen,
    super.address,
    required super.coverImageUrl,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      categories: List<String>.from(json['categories'] as List),
      isOpen: json['isOpen'] as bool,
      address: json['address'] as String?,
      coverImageUrl: json['coverImageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'categories': categories,
      'isOpen': isOpen,
    };
  }
}