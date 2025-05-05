class Restaurant {
  final String id;
  final String name;
  final String logoUrl;
  final List<String> categories;
  final bool isOpen;
  final String? address;



  Restaurant({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.categories,
    required this.isOpen,
    required this.address,
    required String coverImageUrl,
  });
}
