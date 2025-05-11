import 'package:dartz/dartz.dart';
import 'package:dish_dash/features/restaurant/data/models/storeProduct_model.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_datasource.dart';
import '../models/product_model.dart';
import '../models/restaurant_model.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<StoreProductModel>>> getPopularProducts(String query) async {
    try {
      final restaurant = await remoteDataSource.getPopularProducts(query);
      return Right(restaurant);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error while fetching restaurant'));
    }
  }


  @override
  Future<Either<Failure, List<RestaurantModel>>> getAllRestaurants() async {
    try {
      final restaurants = await remoteDataSource.getAllRestaurants();
      return Right(restaurants);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error while fetching all restaurants'));
    }
  }

  @override
  Future<Either<Failure, List<StoreProductModel>>> getProductsByRestaurant(
    String restaurantId,
  ) async {
    try {
      final products = await remoteDataSource.getProductsByRestaurant(restaurantId);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error while fetching restaurant products'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final products = await remoteDataSource.getProducts();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error while fetching products'));
    }
  }

  @override
  Future<Either<Failure, List<StoreProductModel>>> getProductsBySearch(String query) async {
    try {
      final product = await remoteDataSource.getProductsBySearch(query);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error while fetching product'));
    }
  }

}
