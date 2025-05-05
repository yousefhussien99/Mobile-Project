// States
import '../../data/models/product_model.dart';
import '../../domain/entities/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  final String searchQuery;

  ProductLoading(this.searchQuery);
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final String searchQuery;

  ProductLoaded({
    required this.products,
    required this.searchQuery,
  });
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}