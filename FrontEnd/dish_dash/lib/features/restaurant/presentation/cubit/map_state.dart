import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<dynamic> restaurants;
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

