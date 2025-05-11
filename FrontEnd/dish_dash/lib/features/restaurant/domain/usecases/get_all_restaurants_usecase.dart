import 'package:dartz/dartz.dart';
import 'package:dish_dash/features/restaurant/domain/repositories/restaurant_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/restaurant_model.dart';
import '../entities/restaurant.dart';

class GetAllRestaurantsUseCase {
  final RestaurantRepository repository;
  GetAllRestaurantsUseCase(this.repository);

  Future<Either<Failure, List<RestaurantModel>>> call() async {
    return await repository.getAllRestaurants();
  }
}
