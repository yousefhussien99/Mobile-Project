import 'package:dartz/dartz.dart';
import 'package:dish_dash/core/errors/failure.dart';
import 'package:dish_dash/features/restaurant/domain/entities/product.dart';
import 'package:dish_dash/features/restaurant/domain/repositories/restaurant_repository.dart';

import '../../data/models/product_model.dart';

class GetProductsUseCase {
  final RestaurantRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductModel>>> call() async {
    return await repository.getProducts();
  }
}