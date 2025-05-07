import 'package:dartz/dartz.dart';
import 'package:dish_dash/core/errors/failure.dart';
import 'package:dish_dash/features/restaurant/domain/entities/product.dart';
import 'package:dish_dash/features/restaurant/domain/repositories/restaurant_repository.dart';

class GetProductByIdUseCase {
  final RestaurantRepository repository;

  GetProductByIdUseCase(this.repository);

  Future<Either<Failure, Product>> call(String id) async {
    return await repository.getProductById(id);
  }
}