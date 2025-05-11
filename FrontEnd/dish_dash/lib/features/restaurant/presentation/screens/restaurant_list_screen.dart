import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../cubit/restaurant_cubit.dart';
import '../cubit/restaurant_state.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/search_bar.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _HomePageState();
}

class _HomePageState extends State<RestaurantListScreen> {
  String userName = "";

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _fetchRestaurants(force: false); // fetch on initial load
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'Guest';
    });
  }

  Future<void> _fetchRestaurants({bool force = false}) async {
    await context.read<RestaurantCubit>().fetchRestaurants(force: force);
  }

  void _onScreenVisible() {
    _fetchRestaurants(force: true); // force refresh when screen is visible
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBF9),
      body: SafeArea(
        child: VisibilityDetector(
          key: const Key('restaurant-list'),
          onVisibilityChanged: (visibilityInfo) {
            if (visibilityInfo.visibleFraction > 0.5) {
              _onScreenVisible(); // Refresh data when screen is more than 50% visible
            }
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 8),
              Text('Welcome, $userName 👋🏻',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Explore available restaurants and cafés in DishDash.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 20),
              const SearchBarWidget(),
              const SizedBox(height: 24),
              const Text(
                'Restaurants & Cafés',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              BlocBuilder<RestaurantCubit, RestaurantState>(
                builder: (context, state) {
                  if (state is RestaurantLoading) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFFC23435)));
                  } else if (state is RestaurantError) {
                    return Center(child: Text(state.message));
                  } else if (state is RestaurantsLoaded) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.restaurants.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        return RestaurantCardWidget(restaurant: state.restaurants[index]);
                      },
                    );
                  } else {
                    return const SizedBox(); // Placeholder for initial state
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
