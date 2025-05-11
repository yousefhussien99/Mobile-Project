import 'package:equatable/equatable.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/storeProduct_model.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => []; // Empty props list in base class
}

class RestaurantInitial extends RestaurantState {
  @override
  List<Object?> get props => []; // No fields, no need to override
}

class RestaurantLoading extends RestaurantState {
  @override
  List<Object?> get props => []; // No fields, no need to override
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError(this.message);

  @override
  List<Object?> get props => [message]; // Equates based on the message
}

class RestaurantsLoaded extends RestaurantState {
  final List<RestaurantModel> restaurants;

  const RestaurantsLoaded(this.restaurants);

  @override
  List<Object?> get props => [restaurants]; // Equates based on the restaurants list
}

class ProductsLoaded extends RestaurantState {
  final List<ProductModel> products;

  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products]; // Equates based on the products list
}

class StoreProductsLoaded extends RestaurantState {
  final List<StoreProductModel> storeProducts;

  const StoreProductsLoaded(this.storeProducts);

  @override
  List<Object?> get props => [storeProducts]; // Equates based on the store products list
}
