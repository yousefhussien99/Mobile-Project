import 'package:dartz/dartz.dart';
import 'package:dish_dash/features/restaurant/domain/repositories/restaurant_repository.dart';
import '../../../../core/errors/failure.dart';
import '../entities/restaurant.dart';

class GetAllRestaurantsUseCase {
  final RestaurantRepository repository;
  GetAllRestaurantsUseCase(this.repository);

  Future<Either<Failure, List<Restaurant>>> call() async {
    return await repository.getAllRestaurants();
  }
}
