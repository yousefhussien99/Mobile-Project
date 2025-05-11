import 'package:dish_dash/features/restaurant/domain/entities/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'package:latlong2/latlong.dart';

Widget buildRestaurantList(
    BuildContext context,
    List<dynamic> restaurants,
    Function(LatLng) onLocationTap,
    ) {
  return ListView.builder(
    itemCount: restaurants.length,
    itemBuilder: (context, index) {
      final restaurant = restaurants[index];
      Color cardBackgroundColor = Colors.white;

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: cardBackgroundColor, // Set background color of the card
        child: ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: Container(
            width: 70, // Make the image bigger
            height: 70, // Adjust the height for the image
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white, // Add a white background to the SVG container
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SvgPicture.asset(
                restaurant.imgUrl, // Assuming you have SVG icons stored locally
                width: 70, // Increase width for the image
                height: 70, // Increase height for the image
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: Text(
            _fixEncoding(restaurant.name),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  restaurant.location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Text(
                restaurant.type,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red, // Make the type text red
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
        ),
      );
    },
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
