// lib/presentation/cubits/states/map_state.dart
import 'package:dish_dash/features/restaurant/domain/entities/restaurant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<Restaurant> restaurants;
  final List<Marker> markers;
  final Position? currentPosition;

  MapLoaded({
    required this.restaurants,
    required this.markers,
    this.currentPosition,
  });
}

class MapError extends MapState {
  final String message;

  MapError(this.message);
}