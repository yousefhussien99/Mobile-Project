import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../data/repositories/restaurant_repository_impl.dart';
import '../entities/restaurant.dart';

class GetAllRestaurantsUseCase {
  final RestaurantRepository repository;

  GetAllRestaurantsUseCase(this.repository);

  Future<Either<Failure, List<Restaurant>>> call() async {
    return await repository.getAllRestaurants();
  }

}