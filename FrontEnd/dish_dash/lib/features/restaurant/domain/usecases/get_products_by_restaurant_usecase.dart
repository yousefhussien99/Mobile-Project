import 'package:dartz/dartz.dart';

import 'package:dish_dash/core/errors/failure.dart';

import 'package:dish_dash/features/restaurant/domain/entities/restaurant.dart';

import '../../data/repositories/restaurant_repository_impl.dart';
import '../entities/product.dart';

class GetProductsByRestaurantUseCase {
  final RestaurantRepository restaurantRepository;

  GetProductsByRestaurantUseCase(this.restaurantRepository);

  Future<Either<Failure, List<Restaurant>>> call(String restaurantId) async {
    return await restaurantRepository.getProductsByRestaurant(restaurantId);
  }
}