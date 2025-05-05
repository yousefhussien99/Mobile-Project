import 'package:dish_dash/features/restaurant/presentation/widgets/restaurant_card.dart';
import 'package:flutter/material.dart';


import '../../data/models/restaurant_model.dart';
import '../../domain/entities/restaurant.dart';

class RestaurantGrid extends StatelessWidget {
  final List<Restaurant> restaurants;

  const RestaurantGrid({
    super.key,
    required this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return Hero(
            tag: 'restaurant-${restaurants[index].id}',
            child: Material(
              type: MaterialType.transparency,
              child: RestaurantCard(restaurant: restaurants[index]),
            ),
          );
        },
      ),
    );
  }
}
