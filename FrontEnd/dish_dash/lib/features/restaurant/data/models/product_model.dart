import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    super.imageUrl,
    required super.price,
    required super.restaurantName,
    required super.currency,
    required super.tags, required super.category,
    required super.subcategory,

  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    if (json['price'] <= 0) {
      throw ArgumentError('Price must be positive');
    }

    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num).toDouble(),
      restaurantName: json['restaurantName'] as String,
      currency: json['currency'] as String,
      tags: (json['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'price': price,
      'restaurantName': restaurantName,
    };
  }
}