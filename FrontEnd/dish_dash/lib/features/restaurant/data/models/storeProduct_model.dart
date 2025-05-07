
import 'package:dish_dash/features/restaurant/domain/entities/storeProduct.dart';

class StoreProductModel extends StoreProduct {
  const StoreProductModel({
    required int id,
    required int quantity,
    required String price,
    required int store,
    required int product,
  }) : super(
          id: id,
          quantity: quantity,
          price: price,
          store: store,
          product: product,
        );

  factory StoreProductModel.fromJson(Map<String, dynamic> json) {
    return StoreProductModel(
      id: json['id'],
      quantity: json['quantity'],
      price: json['price'],
      store: json['store'],
      product: json['product'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'price': price,
      'store': store,
      'product': product,
    };
  }
}