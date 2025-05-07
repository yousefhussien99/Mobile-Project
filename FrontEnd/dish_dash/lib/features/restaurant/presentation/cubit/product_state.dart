// States
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  final String searchQuery;

  const ProductLoading(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final String searchQuery;

  const ProductLoaded({
    required this.products,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [products, searchQuery];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}