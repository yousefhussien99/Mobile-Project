import 'package:dartz/dartz.dart';
import 'package:dish_dash/core/errors/failure.dart';
import 'package:dish_dash/features/restaurant/domain/entities/product.dart';
import 'package:dish_dash/features/restaurant/domain/repositories/restaurant_repository.dart';

class GetProductsUseCase {
  final RestaurantRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}