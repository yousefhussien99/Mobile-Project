import 'package:dartz/dartz.dart';
import 'package:dish_dash/features/restaurant/data/models/product_model.dart';
import 'package:dish_dash/features/restaurant/data/models/storeProduct_model.dart';
import 'package:dish_dash/features/restaurant/domain/entities/product.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, Restaurant>> getRestaurantById(String id);
  Future<Either<Failure, List<Restaurant>>> getAllRestaurants();
  Future<Either<Failure, List<StoreProductModel>>> getProductsByRestaurant(
    String restaurantId,
  );
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
}

// Restaurants
// Future<Either<Failure, Unit>> addRestaurant(
//   String name,
//   String description,
//   String address,
//   String phone,
//   String imageUrl,
// );


// Future<Either<Failure, Unit>> updateRestaurant(
//   String id,
//   String name,
//   String description,
//   String address,
//   String phone,
//   String imageUrl,
// );

  // Products
// Future<Either<Failure, Unit>> addProduct(
//   String name,
//   String description,
//   String imageUrl,
//   double price,
//   String restaurantId,
// );


  // Future<Either<Failure, Unit>> deleteRestaurant(String id);


// Future<Either<Failure, Unit>> updateProduct(
//   String id,
//   String name,
//   String description,
//   String imageUrl,
//   double price,
// );

// Future<Either<Failure, Unit>> deleteProduct(String id);
// searchProducts(query)
