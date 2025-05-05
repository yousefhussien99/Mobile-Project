import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
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

// Cubit
class RestaurantDetailCubit extends Cubit<RestaurantDetailState> {
  RestaurantDetailCubit() : super(RestaurantDetailInitial());

  void loadRestaurantDetails(String restaurantId) async {
    emit(RestaurantDetailLoading(restaurantId));

    try {
      // Simulate API call with mock data
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock data for Burger King
      if (restaurantId == '3') {
        final restaurant = Restaurant(
          id: '3',
          name: 'Burger King',
          logoUrl: 'assets/logos/burger_king.png',
          categories: ['Fast Food'],
          isOpen: true,
          address: '1453 W Manchester Ave Los Angeles CA 90047',
          coverImageUrl: 'assets/covers/burger_king_cover.jpg',
        );

        final menuItems = [
          // Popular Items
          Product(
            id: '1',
            name: 'Extreme cheese whopper JR',
            imageUrl: 'assets/menu/extreme_cheese_whopper.jpg',
            price: 5.99,
            category: 'Popular Items',
            subcategory: 'Burger',
            restaurantName: 'Burger King',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
          ),
          Product(
            id: '2',
            name: 'Singles BBQ bacon cheese burger',
            imageUrl: 'assets/menu/bbq_bacon_burger.jpg',
            price: 7.99,
            category: 'Popular Items',
            subcategory: 'Burger',
            restaurantName: 'Burger King',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
          ),
          Product(
            id: '3',
            name: 'Potato bun cheese burger',
            imageUrl: 'assets/menu/potato_bun_burger.jpg',
            price: 3.99,
            category: 'Popular Items',
            subcategory: 'Burger',
            restaurantName: '',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
          ),

          // Hot Burger Combo
          Product(
            id: '4',
            name: 'Combo Spicy Tender',
            imageUrl: 'assets/menu/spicy_tender.jpg',
            price: 10.15,
            category: 'Hot Burger Combo',
            subcategory: 'Burger combo',
            restaurantName: 'Burger King',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
          ),
          Product(
            id: '5',
            name: 'Combo Tender Grill',
            imageUrl: 'assets/menu/tender_grill.jpg',
            price: 10.15,
            category: 'Hot Burger Combo',
            subcategory: 'Burger combo',
            restaurantName: 'Burger King',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
          ),
          Product(
            id: '6',
            name: 'Combo BBQ Bacon',
            imageUrl: 'assets/menu/combo_bbq_bacon.jpg',
            price: 10.15,
            category: 'Hot Burger Combo',
            subcategory: 'Burger combo',
            restaurantName: 'Burger King',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
          ),

          // Fried Chicken
          Product(
            id: '7',
            name: 'Chicken BBQ',
            imageUrl: 'assets/menu/chicken_bbq.jpg',
            price: 10.15,
            category: 'Fried Chicken',
            subcategory: 'Burger combo',
            restaurantName: 'Burger King',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
          ),
          Product(
            id: '8',
            name: 'Combo Chicken Crispy',
            imageUrl: 'assets/menu/chicken_crispy.jpg',
            price: 10.15,
            category: 'Fried Chicken',
            subcategory: 'Burger combo',
            restaurantName: 'Burger King',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
          ),
          Product(
            id: '9',
            name: 'Combo BBQ Bacon Chicken',
            imageUrl: 'assets/menu/bbq_bacon_chicken.jpg',
            price: 10.15,
            category: 'Fried Chicken',
            subcategory: 'Burger combo',
            restaurantName: 'Burger King',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
          ),
        ];

        emit(RestaurantDetailLoaded(
          restaurant: restaurant,
          menuItems: menuItems,
        ));
      }
      // Mock data for other restaurants
      else {
        final restaurant = Restaurant(
          id: restaurantId,
          name: 'Restaurant $restaurantId',
          logoUrl: 'assets/logos/restaurant.png',
          categories: ['Fast Food'],
          isOpen: true,
          address: '123 Main St, City, State 12345',
          coverImageUrl: 'assets/covers/restaurant_cover.jpg',
        );

        final menuItems = [
          Product(
            id: '1',
            name: 'Menu Item 1',
            imageUrl: 'assets/menu/item1.jpg',
            price: 7.99,
            category: 'Popular Items',
            subcategory: 'Burger',
            restaurantName: 'Restaurant $restaurantId',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
          ),
          Product(
            id: '2',
            name: 'Menu Item 2',
            imageUrl: 'assets/menu/item2.jpg',
            price: 8.99,
            category: 'Popular Items',
            subcategory: 'Burger',
            restaurantName: 'Restaurant $restaurantId',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
          ),
        ];

        emit(RestaurantDetailLoaded(
          restaurant: restaurant,
          menuItems: menuItems,
        ));
      }
    } catch (e) {
      emit(RestaurantDetailError('Failed to load restaurant details: $e'));
    }
  }
}
