import 'package:equatable/equatable.dart';

class StoreProduct extends Equatable {
  final int id;
  final int quantity;
  final String price;
  final int store;
  final int product;

  const StoreProduct({
    required this.id,
    required this.quantity,
    required this.price,
    required this.store,
    required this.product,
  });

  @override
  List<Object?> get props => [id, quantity, price, store, product];
}