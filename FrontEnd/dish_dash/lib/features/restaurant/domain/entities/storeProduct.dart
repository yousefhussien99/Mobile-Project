import 'package:equatable/equatable.dart';

class RestaurantAll extends Equatable {
  final int id;
  final String name;
  final String type;
  final String location;
  final double latitude;
  final double longitude;
  final String imgUrl;

  const RestaurantAll({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.imgUrl,
  });

  @override
  List<Object?> get props =>
      [id, name, type, location, latitude, longitude, imgUrl];
}

class ProductAll extends Equatable {
  final int id;
  final String name;
  final String description;
  final String imgUrl;

  const ProductAll({
    required this.id,
    required this.name,
    required this.description,
    required this.imgUrl,
  });

  @override
  List<Object?> get props => [id, name, description, imgUrl];
}

class StoreProduct extends Equatable {
  final int id;
  final int quantity;
  final double price;
  final RestaurantAll store;
  final ProductAll product;

  const StoreProduct({
    required this.id,
    required this.quantity,
    required this.price,
    required this.store,
    required this.product,
  });

  @override
  List<Object?> get props => [id, quantity, price, store, product];
}
