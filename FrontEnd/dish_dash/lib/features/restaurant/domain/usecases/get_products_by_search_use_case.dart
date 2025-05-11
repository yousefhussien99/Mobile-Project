import 'package:dartz/dartz.dart';
import 'package:dish_dash/core/errors/failure.dart';
import 'package:dish_dash/features/restaurant/domain/entities/restaurant.dart';
import 'package:dish_dash/features/restaurant/domain/repositories/restaurant_repository.dart';

import '../../data/models/storeProduct_model.dart';
import '../entities/storeProduct.dart';

class GetRestaurantByIdUseCase {
  final RestaurantRepository repository;

  GetRestaurantByIdUseCase(this.repository);

  Future<Either<Failure, List<StoreProductModel>>> call(String query) async {
    return await repository.getProductsBySearch(query);
  }
}