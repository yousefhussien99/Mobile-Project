// lib/features/restaurant/presentation/widgets/directions_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:dish_dash/features/restaurant/domain/entities/restaurant.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/directions_cubit.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/directions_state.dart';

Widget buildMapSection(
  DirectionsCubit directionsCubit,
  DirectionsLoaded state,
  LatLngBounds bounds,
) {
  return Stack(
    children: [
      FlutterMap(
        mapController: directionsCubit.mapController,
        options: MapOptions(
          bounds: bounds,
          boundsOptions: FitBoundsOptions(
            padding: EdgeInsets.all(50.0),
          ),
          maxZoom: 18.0,
          minZoom: 5.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.dish.dash.app',
          ),
          PolylineLayer(
            polylines: [state.polyline],
          ),
          MarkerLayer(
            markers: state.markers,
          ),
        ],
      ),
      Positioned(
        right: 16,
        bottom: 16,
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.white,
          child: Icon(Icons.my_location, color: Colors.black),
          onPressed: () {
            directionsCubit.mapController.fitBounds(
              bounds,
              options: FitBoundsOptions(
                padding: EdgeInsets.all(50.0),
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget buildInfoSection(
  BuildContext context,
  Restaurant restaurant,
  DirectionsLoaded state,
) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, -3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildRestaurantHeader(context, restaurant),
        SizedBox(height: 16),
        buildLocationInfo(context, restaurant),
        SizedBox(height: 10),
        buildRouteInfo(context, state),
      ],
    ),
  );
}

Widget buildRestaurantHeader(BuildContext context, Restaurant restaurant) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: getIconBackgroundColor(restaurant.type),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          getRestaurantIcon(restaurant.type),
          color: Colors.white,
          size: 24,
        ),
      ),
      SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurant.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2),
            Text(
              restaurant.type,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildLocationInfo(BuildContext context, Restaurant restaurant) {
  return Row(
    children: [
      Icon(Icons.location_on, color: Colors.grey),
      SizedBox(width: 8),
      Expanded(
        child: Text(
          restaurant.location,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ],
  );
}

Widget buildRouteInfo(BuildContext context, DirectionsLoaded state) {
  return Column(
    children: [
      Row(
        children: [
          Icon(Icons.directions_car, color: Colors.grey),
          SizedBox(width: 8),
          Text(
            'Route Distance: ${state.distance.toStringAsFixed(2)} km',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Icon(Icons.access_time, color: Colors.grey),
          SizedBox(width: 8),
          Text(
            'Est. Time: ${calculateEstimatedTime(state.distance)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget buildErrorState(VoidCallback onRetry, String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 48, color: Colors.red),
        SizedBox(height: 16),
        Text(message),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: onRetry,
          child: Text('Retry'),
        ),
      ],
    ),
  );
}

// Helper functions
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

String calculateEstimatedTime(double distanceInKm) {
  final double averageSpeedKmH = 30;
  final double timeInHours = distanceInKm / averageSpeedKmH;
  
  if (timeInHours < 1) {
    final int minutes = (timeInHours * 60).round();
    return '$minutes min';
  } else {
    final int hours = timeInHours.floor();
    final int minutes = ((timeInHours - hours) * 60).round();
    return '$hours h ${minutes} min';
  }
}