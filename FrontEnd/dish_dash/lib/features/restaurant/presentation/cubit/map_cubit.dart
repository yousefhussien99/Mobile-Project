// lib/presentation/cubits/map_cubit.dart
import 'package:dish_dash/features/restaurant/domain/entities/restaurant.dart';
import 'package:dish_dash/features/restaurant/domain/usecases/get_all_restaurants_usecase.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/map_state.dart';
import 'package:dish_dash/features/restaurant/presentation/screens/directions_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';  
import 'package:latlong2/latlong.dart';  
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';  

// lib/presentation/cubits/map_cubit.dart
// map_cubit.dart
class MapCubit extends Cubit<MapState> {
  final GetAllRestaurantsUseCase getRestaurantsUseCase;
  
  MapCubit({required this.getRestaurantsUseCase}) : super(MapInitial());

  Position? currentPosition;

  Future<void> loadRestaurants() async {
    try {
      emit(MapLoading());
      final result = await getRestaurantsUseCase();
      
      result.fold(
        (failure) => emit(MapError(failure.message)),
        (restaurants) {
          final markers = _createMarkers(restaurants);
          emit(MapLoaded(
            restaurants: restaurants,
            markers: markers,
            currentPosition: currentPosition,
          ));
        },
      );
    } catch (e) {
      emit(MapError('Unexpected error occurred: $e'));
    }
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
        emit(MapError(
          'Location permissions are permanently denied. Please enable them in your device settings.'
        ));
        return;
      }

      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      // Print current location
      print('Current Location:');
      print('Latitude: ${currentPosition?.latitude}');
      print('Longitude: ${currentPosition?.longitude}');

      await loadRestaurants();
    } catch (e) {
      emit(MapError('Error getting location: ${e.toString()}'));
    }
  }

  List<Marker> _createMarkers(List<Restaurant> restaurants) {
    List<Marker> markers = [];
    
    // Add current location marker if available
    if (currentPosition != null) {
      markers.add(
        Marker(
          point: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          width: 40,
          height: 40,
          builder: (context) => Icon(
            Icons.location_pin,
            color: Colors.blue,
            size: 35,
          ),
        ),
      );
    }

    // Add restaurant markers with tap handlers
    markers.addAll(
      restaurants.map((restaurant) {
        return Marker(
          point: LatLng(restaurant.latitude, restaurant.longitude),
          width: 40,
          height: 40,
          builder: (context) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DirectionsScreen(
                    restaurant: restaurant,
                    currentPosition: currentPosition,
                  ),
                ),
              );
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/loc.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      }),
    );

    return markers;
  }  
}