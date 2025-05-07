import 'package:dish_dash/features/restaurant/domain/entities/storeProduct.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/restaurant_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/restaurant.dart';
import '../cubit/restaurant_detail_cubit.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantDetailCubit>().loadRestaurantDetails(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
        builder: (context, state) {
          if (state is RestaurantDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RestaurantDetailLoaded) {
            return RestaurantDetailView(
              restaurant: state.restaurant,
              storeProducts: state.menuItems,
            );
          } else if (state is RestaurantDetailError) {
            return Center(child: Text(state.message));
          } else {
            print(state);
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}

class RestaurantDetailView extends StatelessWidget {
  final Restaurant restaurant;
  final List<StoreProduct> storeProducts;

  const RestaurantDetailView({
    super.key,
    required this.restaurant,
    required this.storeProducts,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 200.0,
          pinned: true,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.restaurant,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        // Restaurant Info
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  restaurant.type,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  restaurant.location,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Products List
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Available Products',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...storeProducts.map((item) => _buildStoreProductItem(item)).toList(),
          ]),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }

  Widget _buildStoreProductItem(StoreProduct storeProduct) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Product #${storeProduct.product}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\$${storeProduct.price}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.inventory_2_outlined, 
                          size: 16, 
                          color: Colors.grey[600]
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'In Stock: ${storeProduct.quantity}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    // You might want to add a button to add to cart here
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Add to cart functionality
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 36),
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}