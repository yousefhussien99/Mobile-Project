// map_screen.dart
import 'package:dish_dash/features/restaurant/presentation/cubit/map_cubit.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/map_state.dart';
import 'package:dish_dash/features/restaurant/presentation/widgets/map_section.dart';
import 'package:dish_dash/features/restaurant/presentation/widgets/map_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';


class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  double sheetHeight = 200;
  final double minHeight = 100;
  final double maxHeight = 600;
  double startDragY = 0;


  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showLocationDialog(
          'Location services are disabled. Please enable location services to use this feature.'
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        showLocationDialog(
          'This app needs location permission to show nearby restaurants.'
        );
      }

      initializeLocation();
    } catch (e) {
      print('Error checking location permission: $e');
    }
  }

  void showLocationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Permission Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              initializeLocation();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> initializeLocation() async {
    final mapCubit = context.read<MapCubit>();
    await mapCubit.getCurrentLocation();
    await mapCubit.loadRestaurants();
  }

  void centerOnLocation(LatLng location) {
    mapController.move(location, 15.0);
  }

  Positioned searchBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search restaurants...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MapCubit, MapState>(
          builder: (context, state) {
            return Stack(
              children: [
                // Search Bar
                searchBar(context),

                // Map
                mapSection(state, mapController),

                // Location Buttons
                if (state is MapLoaded)
                  locButtons(state),

                // Draggable Results Panel
                resultsSection(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Positioned resultsSection(BuildContext context, MapState state) {
    // Filter restaurants based on search query
    final filteredRestaurants = (state is MapLoaded)
        ? state.restaurants.where((restaurant) {
            return restaurant.name.toLowerCase().contains(searchQuery) ||
                  restaurant.type.toLowerCase().contains(searchQuery) ||
                  restaurant.location.toLowerCase().contains(searchQuery);
          }).toList()
        : [];

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragStart: (details) {
          startDragY = details.globalPosition.dy;
        },
        onVerticalDragUpdate: (details) {
          setState(() {
            double dragDelta = startDragY - details.globalPosition.dy;
            sheetHeight = (sheetHeight + dragDelta).clamp(minHeight, maxHeight);
            startDragY = details.globalPosition.dy;
          });
        },
        child: Container(
          height: sheetHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
            children: [
              // Drag Handle
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nearby Restaurants',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (state is MapLoaded)
                      Text(
                        '${filteredRestaurants.length} found',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
              // Restaurant List
              if (state is MapLoaded)
                Expanded(
                  child: filteredRestaurants.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No restaurants found',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (searchQuery.isNotEmpty)
                              Text(
                                'Try different search terms',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredRestaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = filteredRestaurants[index];
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
                              centerOnLocation(LatLng(
                                restaurant.latitude,
                                restaurant.longitude,
                              ));
                            },
                          );
                        },
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }


  Positioned locButtons(MapLoaded state) {
    return Positioned(
                  right: 16,
                  bottom: sheetHeight + 20,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        mini: true,
                        heroTag: 'location_button',
                        child: Icon(Icons.my_location),
                        onPressed: () {
                          if (state.currentPosition != null) {
                            centerOnLocation(LatLng(
                              state.currentPosition!.latitude,
                              state.currentPosition!.longitude,
                            ));
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      FloatingActionButton(
                        mini: true,
                        heroTag: 'refresh_button',
                        child: Icon(Icons.refresh),
                        onPressed: initializeLocation,
                      ),
                    ],
                  ),
                );
  }

}

