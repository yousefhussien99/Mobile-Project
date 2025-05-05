class Product {
  final String id;
  final String name;
  final String? imageUrl;
  final double price;
  final String restaurantName;
  final String currency;
  final List<String> tags;
  final String category;
  final String subcategory;

 const  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.restaurantName,
    required this.currency,
    required this.tags,
    required this.category,
    required this.subcategory,

  });

  List<Object?> get props => [
    id,
    name,
    imageUrl,
    price,
    restaurantName,
    currency,
    tags,
  ];
}
