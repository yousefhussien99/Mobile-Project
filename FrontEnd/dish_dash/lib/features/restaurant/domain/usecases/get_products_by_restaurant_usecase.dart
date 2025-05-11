import 'package:dartz/dartz.dart';
import 'package:dish_dash/core/errors/failure.dart';
import 'package:dish_dash/features/restaurant/domain/repositories/restaurant_repository.dart';

import '../../data/models/storeProduct_model.dart';
import '../entities/storeProduct.dart';

class GetProductsByRestaurantUseCase {
  final RestaurantRepository repository;

  GetProductsByRestaurantUseCase(this.repository);

  Future<Either<Failure, List<StoreProductModel>>> call(String restaurantId) async {
    return await repository.getProductsByRestaurant(restaurantId);
  }
}