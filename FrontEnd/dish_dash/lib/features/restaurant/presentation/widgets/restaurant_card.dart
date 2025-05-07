import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../domain/entities/restaurant.dart';
import '../screens/restaurant_detail_screen.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({
    super.key,
    required this.restaurant,
  });

  // Get first letter or first word character
  String _getDisplayText() {
    if (restaurant.name.isEmpty) return '';
    return restaurant.name[0].toUpperCase();
  }

  // Generate random color
  Color _getRandomColor() {
    final List<Color> colors = [
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.purple[400]!,
      Colors.orange[400]!,
      Colors.red[400]!,
      Colors.teal[400]!,
      Colors.indigo[400]!,
      Colors.pink[400]!,
    ];

    // Use name as seed to keep color consistent for same restaurant
    final random = math.Random(restaurant.name.length);
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(
              restaurantId: restaurant.id.toString(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _getRandomColor(),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    _getDisplayText(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
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
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.type,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}