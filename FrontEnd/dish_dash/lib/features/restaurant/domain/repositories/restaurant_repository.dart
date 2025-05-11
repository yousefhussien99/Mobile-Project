import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/product_model.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/storeProduct_model.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, List<RestaurantModel>>> getAllRestaurants();
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, List<StoreProductModel>>> getProductsByRestaurant(
      String restaurantId);
  Future<Either<Failure, List<StoreProductModel>>> getPopularProducts(String query);
  Future<Either<Failure, List<StoreProductModel>>> getProductsBySearch(String query);
}

