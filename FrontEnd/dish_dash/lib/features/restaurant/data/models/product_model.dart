import 'package:dish_dash/features/restaurant/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imgUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imgUrl: json['imgUrl'],
    );
  }

  @override
  List<Object?> get props => super.props;
}