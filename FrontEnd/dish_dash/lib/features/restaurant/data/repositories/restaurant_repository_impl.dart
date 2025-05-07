import 'package:dartz/dartz.dart';
import 'package:dish_dash/features/restaurant/data/models/storeProduct_model.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_datasource.dart';
import '../models/product_model.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Restaurant>> getRestaurantById(String id) async {
    try {
      final restaurant = await remoteDataSource.getRestaurantById(id);
      return Right(restaurant);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error while fetching restaurant'));
    }
  }


  @override
  Future<Either<Failure, List<Restaurant>>> getAllRestaurants() async {
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
  Future<Either<Failure, List<Product>>> getProducts() async {
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
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error while fetching product'));
    }
  }

  

}


// @override
// Future<Either<Failure, Unit>> addRestaurant(
//   String name,
//   String description,
//   String address,
//   String phone,
//   String imageUrl,
// ) async {
//   try {
//     final restaurantModel = RestaurantModel(
//       id: 0,
//       name: name,
//       type: description,
//       location: address,
//       latitude: 0.0,
//       longitude: 0.0,
//     );
//     await remoteDataSource.addRestaurant(restaurantModel);
//     return const Right(unit);
//   } on ServerException catch (e) {
//     return Left(ServerFailure(e.message));
//   } catch (_) {
//     return Left(ServerFailure('Unexpected error while adding restaurant'));
//   }
// }

// @override
// Future<Either<Failure, Unit>> updateRestaurant(
//   String id,
//   String name,
//   String description,
//   String address,
//   String phone,
//   String imageUrl,
// ) async {
//   try {
//     final restaurantModel = RestaurantModel(
//       id: int.parse(id),
//       name: name,
//       type: description,
//       location: address,
//       latitude: 0.0,
//       longitude: 0.0,
//     );
//     await remoteDataSource.updateRestaurant(restaurantModel);
//     return const Right(unit);
//   } on ServerException catch (e) {
//     return Left(ServerFailure(e.message));
//   } catch (_) {
//     return Left(ServerFailure('Unexpected error while updating restaurant'));
//   }
// }

// @override
// Future<Either<Failure, Unit>> deleteRestaurant(String id) async {
//   try {
//     await remoteDataSource.deleteRestaurant(id);
//     return const Right(unit);
//   } on ServerException catch (e) {
//     return Left(ServerFailure(e.message));
//   } catch (_) {
//     return Left(ServerFailure('Unexpected error while deleting restaurant'));
//   }
// }


  // @override
// Future<Either<Failure, Unit>> addProduct(
//   String name,
//   String description,
//   String imageUrl,
//   double price,
//   String restaurantId,
// ) async {
//   try {
//     final productModel = ProductModel(
//       id: 0,
//       name: name,
//       description: description,
//     );
//     await remoteDataSource.addProduct(productModel);
//     return const Right(unit);
//   } on ServerException catch (e) {
//     return Left(ServerFailure(e.message));
//   } catch (_) {
//     return Left(ServerFailure('Unexpected error while adding product'));
//   }
// }


// @override
// Future<Either<Failure, Unit>> updateProduct(
//   String id,
//   String name,
//   String description,
//   String imageUrl,
//   double price,
// ) async {
//   try {
//     final productModel = ProductModel(
//       id: int.parse(id),
//       name: name,
//       description: description,
//     );
//     await remoteDataSource.updateProduct(productModel);
//     return const Right(unit);
//   } on ServerException catch (e) {
//     return Left(ServerFailure(e.message));
//   } catch (_) {
//     return Left(ServerFailure('Unexpected error while updating product'));
//   }
// }

// @override
// Future<Either<Failure, Unit>> deleteProduct(String id) async {
//   try {
//     await remoteDataSource.deleteProduct(id);
//     return const Right(unit);
//   } on ServerException catch (e) {
//     return Left(ServerFailure(e.message));
//   } catch (_) {
//     return Left(ServerFailure('Unexpected error while deleting product'));
//   }
// }