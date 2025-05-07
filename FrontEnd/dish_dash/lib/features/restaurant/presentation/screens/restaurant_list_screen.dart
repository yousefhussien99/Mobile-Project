import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/restaurant_cubit.dart';
import '../cubit/restaurant_state.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/search_bar.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  @override
  void initState() {
    super.initState();
    // Load restaurants when screen initializes
    context.read<RestaurantCubit>().loadRestaurants();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<RestaurantCubit, RestaurantState>(
        listener: (context, state) {
          if (state is RestaurantError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RestaurantLoaded) {
            return _buildLoadedState(context, state);
          }

          if (state is RestaurantError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<RestaurantCubit>().loadRestaurants(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          print(state);
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, RestaurantLoaded state) {
    // Define popular searches with tags
    final Map<String, List<String>> popularSearchesWithTags = {
      "Grilled chicken": ["Chicken", "Grilled", "Main Course"],
      "Pasta": ["Italian", "Main Course", "Vegetarian"],
      "Sushi": ["Japanese", "Seafood", "Healthy"],
      "Club sandwiches": ["Sandwich", "Lunch", "Quick Meal"],
      "Cheesecake": ["Dessert", "Sweet", "Bakery"],
    };

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        if (state.isSearchFocused) {
          context.read<RestaurantCubit>().setSearchFocus(false);
        }
      },
      child: RefreshIndicator(
        onRefresh: () async => context.read<RestaurantCubit>().loadRestaurants(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to DishDash!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC23435),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Explore available restaurants and cafes',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomSearchBar(
                      onChanged: (query) => context
                          .read<RestaurantCubit>()
                          .searchRestaurants(query),
                      onFocusChanged: (isFocused) => context
                          .read<RestaurantCubit>()
                          .setSearchFocus(isFocused),
                      suggestions: [],
                      isSearchFocused: state.isSearchFocused,
                      popularSearchesWithTags: popularSearchesWithTags,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) => RestaurantCard(
                    restaurant: state.filteredRestaurants[index],
                  ),
                  childCount: state.filteredRestaurants.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}