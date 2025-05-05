import 'package:flutter/material.dart';

import '../../data/models/restaurant_model.dart';
import '../../domain/entities/restaurant.dart';
import '../screens/restaurant_detail_screen.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({
    super.key,
    required this.restaurant,
  });

  Color _getCardColor(String name) {
    switch (name) {
      case 'Starbucks':
        return Colors.green;
      case 'Subway':
        return Colors.amber;
      case 'Burger King':
        return Colors.amber;
      case 'Taco Bell':
        return Colors.purple;
      case 'Pizza Hut':
        return Colors.red;
      case 'McDonald\'s':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to restaurant detail screen when tapped
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(
              restaurantId: restaurant.id,
              restaurantName: restaurant.name,
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: _getCardColor(restaurant.name),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: _buildLogo(restaurant.name),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.verified,
                        color: Colors.green[700],
                        size: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Open',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        restaurant.categories.join(', '),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(String name) {
    // In a real app, you would use Image.asset with the actual logo files
    // Here we're creating simplified logo representations
    switch (name) {
      case 'Starbucks':
        return const Icon(Icons.coffee, size: 50, color: Colors.white);
      case 'Subway':
        return const Text(
          'SUB\nWAY',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        );
      case 'Burger King':
        return const Text(
          'BURGER\nKING',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        );
      case 'Taco Bell':
        return const Text(
          'TACO\nBELL',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        );
      case 'Pizza Hut':
        return const Text(
          'Pizza\nHut',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontStyle: FontStyle.italic,
          ),
        );
      case 'McDonald\'s':
        return const Text(
          'M',
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 50,
          ),
        );
      default:
        return const Icon(Icons.restaurant, size: 50, color: Colors.white);
    }
  }
}
