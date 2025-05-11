import 'package:dish_dash/features/restaurant/domain/entities/restaurant.dart';
import 'package:dish_dash/features/restaurant/domain/usecases/get_all_restaurants_usecase.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/map_state.dart';
import 'package:dish_dash/features/restaurant/presentation/screens/directions_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class MapCubit extends Cubit<MapState> {
  final GetAllRestaurantsUseCase getRestaurantsUseCase;

  MapCubit({required this.getRestaurantsUseCase}) : super(MapInitial());

  Position? currentPosition;

  Future<void> loadRestaurants() async {
    final result = await getRestaurantsUseCase.call();
    result.fold(
          (failure) => emit(MapError('Failed to load restaurants')),
          (restaurants) {
        final markers = _createMarkers(restaurants);
        emit(MapLoaded(
          markers: markers,
          currentPosition: currentPosition,
          restaurants: restaurants,
        ));
      },
    );
  }

  void updateWithFilteredRestaurants(List<dynamic> filteredRestaurants) {
    final current = state;
    if (current is MapLoaded &&
        _areRestaurantListsEqual(current.restaurants, filteredRestaurants)) {
      return; // Skip update if list is the same
    }

    final markers = _createMarkers(filteredRestaurants);
    emit(MapLoaded(
      markers: markers,
      currentPosition: currentPosition,
      restaurants: filteredRestaurants,
    ));
  }

  bool _areRestaurantListsEqual(List<dynamic> a, List<dynamic> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  Future<void> getCurrentLocation() async {
    try {
      emit(MapLoading());

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(MapError('Location services are disabled. Please enable location services in your device settings.'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(MapError('Location permissions are denied. Please grant location permissions to use this feature.'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(MapError('Location permissions are permanently denied. Please enable them in your device settings.'));
        return;
      }

      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('Current Location: Latitude: ${currentPosition?.latitude}, Longitude: ${currentPosition?.longitude}');

      await loadRestaurants();
    } catch (e) {
      emit(MapError('Error getting location: ${e.toString()}'));
    }
  }

  List<Marker> _createMarkers(List<dynamic> restaurants) {
    List<Marker> markers = [];

    // Current location marker
    if (currentPosition != null) {
      markers.add(
        Marker(
          point: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          width: 50,
          height: 50,
          builder: (context) => const Icon(
            Icons.my_location,
            color: Colors.blueAccent,
            size: 40,
          ),
        ),
      );
    }

    // Restaurant markers
    markers.addAll(
      restaurants.map((restaurant) {
        return Marker(
          point: LatLng(restaurant.latitude, restaurant.longitude),
          width: 40,
          height: 40,
          builder: (context) => Builder(
            builder: (innerContext) => GestureDetector(
              onTap: () {
                Navigator.push(
                  innerContext,
                  MaterialPageRoute(
                    builder: (context) => DirectionsScreen(
                      restaurant: restaurant,
                      currentPosition: currentPosition,
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.food_bank_rounded,
                color: Color(0xFFC23435),
                size: 40,
              ),
            ),
          ),
        );
      }).toList(),
    );

    return markers;
  }
}
