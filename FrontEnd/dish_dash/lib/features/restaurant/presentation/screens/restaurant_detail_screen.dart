import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/restaurant.dart';
import '../cubit/restaurant_detail_cubit.dart';
import '../widgets/menu_item_card.dart';


class RestaurantDetailScreen extends StatelessWidget {
  final String restaurantId;
  final String restaurantName;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantDetailCubit()..loadRestaurantDetails(restaurantId),
      child: Scaffold(
        body: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
          builder: (context, state) {
            if (state is RestaurantDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RestaurantDetailLoaded) {
              return RestaurantDetailView(
                restaurant: state.restaurant,
                categorizedMenuItems: state.categorizedMenuItems,
              );
            } else if (state is RestaurantDetailError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class RestaurantDetailView extends StatelessWidget {
  final Restaurant restaurant;
  final Map<String, List<Product>> categorizedMenuItems;

  const RestaurantDetailView({
    super.key,
    required this.restaurant,
    required this.categorizedMenuItems,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar with Restaurant Cover Image
        SliverAppBar(
          expandedHeight: 200.0,
          pinned: true,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: _buildCoverImage(),
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
                Row(
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.verified,
                      color: Colors.green[700],
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Open',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        restaurant.address ?? '',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Menu Categories and Items
        ...categorizedMenuItems.entries.map((entry) {
          final category = entry.key;
          final items = entry.value;

          return SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 24.0,
                  bottom: 16.0,
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2B47),
                  ),
                ),
              ),
              if (category == 'Popular Items')
                _buildPopularItemsGrid(items)
              else
                ...items.map((item) => MenuItemCard(menuItem: item)).toList(),
            ]),
          );
        }).toList(),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }

  Widget _buildCoverImage() {
    // In a real app, you would use Image.network with the actual cover image
    return Container(
      color: Colors.red,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/placeholder.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/placeholder.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularItemsGrid(List<Product> items) {
    return Container(
      height: 220,
      padding: const EdgeInsets.only(left: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 150,
                    width: 180,
                    color: Colors.grey[200],
                    child: _buildMenuItemImage(isPopular: true),
                  ),
                ),
                const SizedBox(height: 8),
                // Item Name
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Price and Category
                Row(
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.subcategory,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItemImage({bool isPopular = false}) {
    // In a real app, you would use Image.network with the actual image
    if (isPopular) {
      return Container(
        color: const Color(0xFFF8F5E4),
        child: Center(
          child: Icon(
            Icons.fastfood,
            size: 40,
            color: Colors.amber[800],
          ),
        ),
      );
    } else {
      return Container(
        color: const Color(0xFFF8F5E4),
        child: Center(
          child: Icon(
            Icons.fastfood,
            size: 30,
            color: Colors.amber[800],
          ),
        ),
      );
    }
  }
}
