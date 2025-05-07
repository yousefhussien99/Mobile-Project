import 'package:dish_dash/features/restaurant/domain/entities/storeProduct.dart';
import '../../domain/entities/restaurant.dart';

// States
abstract class RestaurantDetailState {}

class RestaurantDetailInitial extends RestaurantDetailState {}

class RestaurantDetailLoading extends RestaurantDetailState {
  final String restaurantId;

  RestaurantDetailLoading(this.restaurantId);
}

class RestaurantDetailLoaded extends RestaurantDetailState {
  final Restaurant restaurant;
  final List<StoreProduct> menuItems;
  final Map<String, List<StoreProduct>> categorizedMenuItems;

  RestaurantDetailLoaded({
    required this.restaurant,
    required this.menuItems,
  }) : categorizedMenuItems = _categorizeMenuItems(menuItems);

  static Map<String, List<StoreProduct>> _categorizeMenuItems(List<StoreProduct> items) {
    final Map<String, List<StoreProduct>> result = {};

    for (var item in items) {
      // You might want to use a different field for categorization
      // since StoreProduct doesn't have a description field
      String category = 'Products'; // or use some other categorization logic
      
      if (!result.containsKey(category)) {
        result[category] = [];
      }
      result[category]!.add(item);
    }

    return result;
  }
}

class RestaurantDetailError extends RestaurantDetailState {
  final String message;

  RestaurantDetailError(this.message);
}