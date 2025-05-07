import 'package:dish_dash/features/restaurant/domain/entities/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

IconData getRestaurantIcon(String type) {
  switch (type.toLowerCase()) {
    case 'cafe':
      return Icons.coffee;
    case 'restaurant':
      return Icons.restaurant;
    default:
      return Icons.dining;
  }
}

Color getIconBackgroundColor(String type) {
  switch (type.toLowerCase()) {
    case 'cafe':
      return Colors.brown;
    case 'restaurant':
      return Colors.teal;
    default:
      return Colors.grey;
  }
}

Widget buildRestaurantList(
  BuildContext context,
  List<Restaurant> restaurants,
  Function(LatLng) onLocationTap,
) {
  return ListView.builder(
    itemCount: restaurants.length,
    itemBuilder: (context, index) {
      final restaurant = restaurants[index];
      return ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: getIconBackgroundColor(restaurant.type),
          ),
          child: Center(
            child: Icon(
              getRestaurantIcon(restaurant.type),
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(restaurant.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(restaurant.location),
            Text(
              restaurant.type,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          onLocationTap(LatLng(
            restaurant.latitude,
            restaurant.longitude,
          ));
        },
      );
    },
  );
}