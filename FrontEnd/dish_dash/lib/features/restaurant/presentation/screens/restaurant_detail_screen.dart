import 'package:dish_dash/features/restaurant/presentation/screens/restaurant_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/storeProduct_model.dart';
import '../cubit/restaurant_cubit.dart';
import '../cubit/restaurant_state.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailsPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantCubit>().fetchProductsByRestaurant(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBF9),
      body: BlocBuilder<RestaurantCubit, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFC23435)));
          } else if (state is RestaurantError) {
            return Center(child: Text(state.message));
          } else if (state is StoreProductsLoaded && state.storeProducts.isNotEmpty) {
            final storeProducts = state.storeProducts;
            final store = storeProducts.first.store;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Custom Header (Restaurant Image + Back Button)
                  _buildHeader(store),
                  const SizedBox(height: 16),

                  // Restaurant Info
                  _buildRestaurantInfo(store),

                  // Add padding around the Divider and align text to the left
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16), // Add padding to the sides
                    child: const Divider(height: 36), // Divider with padding
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16), // Add padding to the sides
                    child: const Text(
                      "Products",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Product List
                  ...storeProducts.map((storeProduct) => _buildProductCard(storeProduct)).toList(),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No data found"));
          }
        },
      ),
    );
  }

  Widget _buildHeader(store) {
    return Stack(
      children: [
        // Restaurant Image
        ClipRRect(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
          child: SizedBox(
            width: double.infinity,
            height: 300,
            child: SvgPicture.asset(
              store.imgUrl,
              fit: BoxFit.cover,
              placeholderBuilder: (context) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),
        // Back Button + Title
        Positioned(
          top: 40,
          left: 16,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantInfo(store) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            store.name.replaceAll('â', "'"),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Open",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 18),
              Icon(Icons.location_on, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  store.location ?? 'No address provided',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(StoreProductModel storeProduct) {
    final product = storeProduct.product;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                _fixEncoding(product.imgUrl),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 50),
              ),
            ),
            const SizedBox(width: 14),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fixEncoding(product.name),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description ?? 'No description',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${storeProduct.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fixEncoding(String text) {
    return text
        .replaceAll('Ã¨', 'è')
        .replaceAll('Ã©', 'é')
        .replaceAll('Ã¢', 'â')
        .replaceAll('Ãª', 'ê')
        .replaceAll('Ã®', 'î')
        .replaceAll('Ã´', 'ô')
        .replaceAll('Ã¹', 'ù')
        .replaceAll('Ã»', 'û')
        .replaceAll('Ã ', 'à')
        .replaceAll('Ã§', 'ç')
        .replaceAll('â', "'") // common apostrophe replacement
        .replaceAll('Â', '')    // remove extra encoding artifacts
        .replaceAll(' ', '');   // optional: remove space for CaffèLatte style
  }
}
