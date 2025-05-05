import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, Unit>> addProduct(
    String name,
    String description,
    String imageUrl,
    double price,
    String restaurantId,
  );

  Future<Either<Failure, List<Product>>> getProducts();

  Future<Either<Failure, Product>> getProductById(String id);

  Future<Either<Failure, Unit>> updateProduct(
    String id,
    String name,
    String description,
    String imageUrl,
    double price,
  );

  Future<Either<Failure, Unit>> deleteProduct(String id);
  // searchProducts(query)
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}