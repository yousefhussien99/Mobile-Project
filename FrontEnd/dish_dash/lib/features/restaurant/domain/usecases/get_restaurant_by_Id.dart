import 'package:dartz/dartz.dart';
import 'package:dish_dash/core/errors/failure.dart';
import 'package:dish_dash/features/restaurant/domain/entities/restaurant.dart';
import 'package:dish_dash/features/restaurant/domain/repositories/restaurant_repository.dart';

class GetRestaurantByIdUseCase {
  final RestaurantRepository repository;

  GetRestaurantByIdUseCase(this.repository);

  Future<Either<Failure, Restaurant>> call(String id) async {
    return await repository.getRestaurantById(id);
  }
}