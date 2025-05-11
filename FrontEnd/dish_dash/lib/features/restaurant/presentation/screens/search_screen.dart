import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/map_cubit.dart';
import '../cubit/restaurant_cubit.dart';
import '../cubit/restaurant_state.dart';
import '../widgets/menu_item_card.dart';
import 'map_view_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _popularProducts = ['Cheeseburger', 'French Fries', 'Iced Coffee'];
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<RestaurantCubit>().fetchProductsBySearch(query);
    } else {
      context.read<RestaurantCubit>().clearProducts();
    }
  }

  void _onPopularProductTapped(String productName) {
    _searchController.text = productName;
    context.read<RestaurantCubit>().fetchPopularProducts(productName);
    setState(() {});
  }

  void _toggleView() {
    setState(() {
      _showMap = !_showMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBF9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7A869A)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          hintText: '🔍 Search on DishDash',
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.highlight_remove, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged();
                              context.read<RestaurantCubit>().clearProducts();
                              context.read<MapCubit>().updateWithFilteredRestaurants([]);
                              setState(() {});
                            },
                          )
                              : null,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'DM Sans',
                        ),
                        onChanged: (_) {
                          _onSearchChanged();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  // Switch Button
                  IconButton(
                    icon: Icon(
                      _showMap ? Icons.list_alt : Icons.map,
                      color: const Color(0xFF7A869A),
                    ),
                    onPressed: _toggleView,
                  ),
                ],
              ),
            ),

            // Popular Products Section (Outside Search Bar Padding)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popular Products',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _popularProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final product = _popularProducts[index];
                        return GestureDetector(
                          onTap: () => _onPopularProductTapped(product),
                          child: Chip(
                            label: Text(product),
                            backgroundColor: const Color(0xFFC23435),
                            labelStyle: const TextStyle(color: Colors.white),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: BlocBuilder<RestaurantCubit, RestaurantState>(
                builder: (context, state) {
                  final query = _searchController.text.trim();

                  if (_showMap) {
                    // MAP VIEW
                    final restaurants = (state is StoreProductsLoaded)
                        ? state.storeProducts.map((e) => e.store).toSet().toList()
                        : [];
                    // Update the map with the filtered restaurants
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (restaurants.isNotEmpty) {
                        context.read<MapCubit>().updateWithFilteredRestaurants(restaurants);
                      }
                    });

                    return Column(
                      children: [
                        Expanded(
                          child: MapScreen(restaurants: restaurants),
                        ),
                      ],
                    );
                  } else {
                    // PRODUCT LIST VIEW
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Builder(
                              builder: (_) {
                                if (query.isEmpty) {
                                  return const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.fastfood, size: 88, color: Colors.grey),
                                        SizedBox(height: 12),
                                        Text(
                                          'Search for a product to get started.',
                                          style: TextStyle(fontSize: 16, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                if (state is RestaurantLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(color: Color(0xFFC23435)),
                                  );
                                } else if (state is RestaurantError) {
                                  return Center(child: Text(state.message));
                                } else if (state is StoreProductsLoaded && state.storeProducts.isNotEmpty) {
                                  return ListView.separated(
                                    itemCount: state.storeProducts.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final product = state.storeProducts[index];
                                      return ProductCardWidget(product: product);
                                    },
                                  );
                                } else {
                                  return const Center(
                                    child: Text(
                                      'No products found.',
                                      style: TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
