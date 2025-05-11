import 'package:dartz/dartz.dart';
import 'package:dish_dash/core/errors/failure.dart';
import 'package:dish_dash/features/restaurant/domain/entities/product.dart';
import 'package:dish_dash/features/restaurant/domain/repositories/restaurant_repository.dart';

import '../../data/models/storeProduct_model.dart';
import '../entities/storeProduct.dart';

class GetProductByIdUseCase {
  final RestaurantRepository repository;

  GetProductByIdUseCase(this.repository);

  Future<Either<Failure, List<StoreProductModel>>>  call(String query) async {
    return await repository.getPopularProducts(query);
  }
}