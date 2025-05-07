import 'package:dish_dash/features/restaurant/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required int id,
    required String name,
    required String description,
  }) : super(
          id: id,
          name: name,
          description: description,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  List<Object?> get props => super.props;
}