import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
          child: Icon(Icons.my_location, color: Colors.blue),
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
    dynamic restaurant,
    DirectionsLoaded state,
    ) {
  final theme = Theme.of(context);

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRestaurantHeader(context, restaurant),
        const SizedBox(height: 16),
        buildLocationInfo(context, restaurant),
        const SizedBox(height: 16),
        buildRouteInfo(context, state),
      ],
    ),
  );
}

Widget buildRestaurantHeader(BuildContext context, dynamic restaurant) {
  final theme = Theme.of(context);

  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: getIconBackgroundColor(restaurant.type),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          getRestaurantIcon(restaurant.type),
          color: Colors.white,
          size: 28,
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurant.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              restaurant.type,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Color(0xFFC23435),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


Widget buildLocationInfo(BuildContext context, dynamic restaurant) {
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
        Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onRetry,
          child: const Text('Try Again'),
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