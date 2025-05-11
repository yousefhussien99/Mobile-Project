import 'package:dish_dash/features/restaurant/domain/entities/storeProduct.dart';

class StoreProductModel extends StoreProduct {
  const StoreProductModel({
    required super.id,
    required super.quantity,
    required super.price,
    required super.store,
    required super.product,
  });

  factory StoreProductModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return StoreProductModel(
      id: json['id'],
      quantity: json['quantity'],
      price: parseDouble(json['price']),
      store: RestaurantAll(
        id: json['store']['id'],
        name: json['store']['name'],
        type: json['store']['type'],
        location: json['store']['location'],
        latitude: parseDouble(json['store']['latitude']),
        longitude: parseDouble(json['store']['longitude']),
        imgUrl: json['store']['imgUrl'],
      ),
      product: ProductAll(
        id: json['id'],
        name: json['productName'] ?? json['product_name'],
        description: json['description'],
        imgUrl: json['imageProduct'],
      ),
    );
  }
}
