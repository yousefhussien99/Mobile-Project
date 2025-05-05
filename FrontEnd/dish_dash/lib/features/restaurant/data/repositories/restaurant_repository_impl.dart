import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, Unit>> addRestaurant(
    String name,
    String description,
    String address,
    String phone,
    String imageUrl,
  );

  Future<Either<Failure, List<Restaurant>>> getRestaurants();

  Future<Either<Failure, Restaurant>> getRestaurantById(String id);

  Future<Either<Failure, Unit>> updateRestaurant(
    String id,
    String name,
    String description,
    String address,
    String phone,
    String imageUrl,
  );

  Future<Either<Failure, Unit>> deleteRestaurant(String id);
  Future<Either<Failure, List<Restaurant>>> getAllRestaurants();
  Future<Either<Failure, List<Restaurant>>> getProductsByRestaurant(
    String restaurantId,
  );
}