import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final String imgUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imgUrl,
  });

  @override

  List<Object?> get props => [id, name, description, imgUrl];
}
