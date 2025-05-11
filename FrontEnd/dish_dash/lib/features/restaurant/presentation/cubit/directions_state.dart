import 'package:flutter_map/flutter_map.dart';

class DirectionsState {}

class DirectionsInitial extends DirectionsState {}

class DirectionsLoading extends DirectionsState {}

class DirectionsLoaded extends DirectionsState {
  final List<Marker> markers;
  final Polyline polyline;
  final double distance; // Add this property

  DirectionsLoaded({
    required this.markers,
    required this.polyline,
    required this.distance,
  });
}

class DirectionsError extends DirectionsState {
  final String message;

  DirectionsError(this.message);
}