// States
import '../../domain/entities/product.dart';
import '../../domain/entities/restaurant.dart';

abstract class RestaurantDetailState {}

class RestaurantDetailInitial extends RestaurantDetailState {}

class RestaurantDetailLoading extends RestaurantDetailState {
  final String restaurantId;

  RestaurantDetailLoading(this.restaurantId);
}

class RestaurantDetailLoaded extends RestaurantDetailState {
  final Restaurant restaurant;
  final List<Product> menuItems;
  final Map<String, List<Product>> categorizedMenuItems;

  RestaurantDetailLoaded({
    required this.restaurant,
    required this.menuItems,
  }) : categorizedMenuItems = _categorizeMenuItems(menuItems);

  static Map<String, List<Product>> _categorizeMenuItems(List<Product> items) {
    final Map<String, List<Product>> result = {};

    for (var item in items) {
      if (!result.containsKey(item.category)) {
        result[item.category] = [];
      }
      result[item.category]!.add(item);
    }

    return result;
  }
}

class RestaurantDetailError extends RestaurantDetailState {
  final String message;

  RestaurantDetailError(this.message);
}
