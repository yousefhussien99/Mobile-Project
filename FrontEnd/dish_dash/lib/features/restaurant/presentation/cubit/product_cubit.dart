import 'package:dish_dash/features/restaurant/presentation/cubit/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_model.dart';
import '../../domain/entities/product.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  void searchProducts(String query) async {
    emit(ProductLoading(query));

    try {
      // Simulate API call with mock data
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock data for burgers
      if (query.toLowerCase().contains('burger')) {
        final products = [
          Product(
            id: '1',
            name: 'Original burger',
            imageUrl: 'assets/products/original_burger.jpg',
            price: 70,
            restaurantName: 'Buffalo Burger',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
            category: 'burger',
            subcategory: 'cheesy',

          ),
          Product(
            id: '2',
            name: 'Extreme cheese burger',
            imageUrl: 'assets/products/extreme_cheese_burger.jpg',
            price: 85,
            restaurantName: 'Burger King',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
            category: 'burger',
            subcategory: 'cheesy',
          ),
          Product(
            id: '3',
            name: 'Smashed cheese burger',
            imageUrl: 'assets/products/smashed_cheese_burger.jpg',
            price: 75,
            restaurantName: 'Daddy\'s Burger',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
            category: 'burger',
            subcategory: 'cheesy',
          ),
          Product(
            id: '4',
            name: 'BBQ mushroom burger',
            imageUrl: 'assets/products/bbq_mushroom_burger.jpg',
            price: 90,
            restaurantName: 'Butcher\'s Burger',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
            category: 'burger',
            subcategory: 'cheesy',
          ),
          Product(
            id: '5',
            name: 'Extreme cheese burger',
            imageUrl: 'assets/products/extreme_cheese_burger2.jpg',
            price: 95,
            restaurantName: 'Gourmet Burger',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
            category: 'burger',
            subcategory: 'cheesy',
          ),
        ];
        emit(ProductLoaded(products: products, searchQuery: query));
      }
      // Mock data for other food items
      else if (query.toLowerCase().contains('chicken')) {
        final products = [
          Product(
            id: '6',
            name: 'Grilled chicken',
            imageUrl: 'assets/products/grilled_chicken.jpg',
            price: 85,
            restaurantName: 'KFC',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
            category: 'chicken',
            subcategory: 'grilled',
          ),
          Product(
            id: '7',
            name: 'Chicken sandwich',
            imageUrl: 'assets/products/chicken_sandwich.jpg',
            price: 65,
            restaurantName: 'Chick-fil-A',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
            category: 'chicken',
            subcategory: 'sandwich',

          ),
        ];
        emit(ProductLoaded(products: products, searchQuery: query));
      }
      // Mock data for pasta
      else if (query.toLowerCase().contains('pasta')) {
        final products = [
          Product(
            id: '8',
            name: 'Pasta primavera',
            imageUrl: 'assets/products/pasta_primavera.jpg',
            price: 70,
            restaurantName: 'Italian Bistro',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
            category: 'pasta',
            subcategory: 'primavera',
          ),
          Product(
            id: '9',
            name: 'Spaghetti carbonara',
            imageUrl: 'assets/products/spaghetti_carbonara.jpg',
            price: 80,
            restaurantName: 'Pasta Palace',
            currency: 'EGP',
            tags: ['spicy', 'cheesy'],
            category: 'pasta',
            subcategory: 'carbonara',
          ),
        ];
        emit(ProductLoaded(products: products, searchQuery: query));
      }
      // Default empty results
      else {
        emit(ProductLoaded(products: [], searchQuery: query));
      }
    } catch (e) {
      emit(ProductError('Failed to load products: $e'));
    }
  }
}
