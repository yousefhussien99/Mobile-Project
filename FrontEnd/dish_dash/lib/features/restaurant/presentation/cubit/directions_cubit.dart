import 'package:dish_dash/features/restaurant/presentation/cubit/directions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dish_dash/features/restaurant/domain/entities/restaurant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class DirectionsCubit extends Cubit<DirectionsState> {
  final mapController = MapController();
  DirectionsCubit() : super(DirectionsInitial());

  
  double calculatePathDistance(List<LatLng> points) {
    if (points.length < 2) {
      return 0;
    }
    
    double totalDistance = 0;
    
    for (int i = 0; i < points.length - 1; i++) {
      double segmentDistance = Geolocator.distanceBetween(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );
      
      segmentDistance = segmentDistance / 1000;
      
      
      totalDistance += segmentDistance;
    }
    
    return totalDistance;
  }

  Future<void> loadDirections({
    required Restaurant restaurant,
    required Position? currentPosition,
  }) async {
    try {
      emit(DirectionsLoading());

      if (currentPosition == null) {
        throw Exception('Current location not available');
      }

      // Get route points from OSRM
      final points = await getRoutePoints(
        LatLng(currentPosition.latitude, currentPosition.longitude),
        LatLng(restaurant.latitude, restaurant.longitude),
      );

      final markers = await setupMarkers(restaurant, currentPosition);
      final polyline = Polyline(
        points: points,
        strokeWidth: 4,
        color: Color(0xFFEF9F27),
        strokeCap: StrokeCap.round,
        strokeJoin: StrokeJoin.round,
      );

      // Calculate the path distance
      final pathDistance = calculatePathDistance(points);

      emit(DirectionsLoaded(
        markers: markers,
        polyline: polyline,
        distance: pathDistance,
      ));
    } catch (e) {
      emit(DirectionsError('Failed to load directions: $e'));
    }
  }  



  Future<List<Marker>> setupMarkers(
    Restaurant restaurant,
    Position? currentPosition,
  ) async {
    List<Marker> markers = [];

    if (currentPosition != null) {
      markers.add(
        Marker(
          point: LatLng(currentPosition.latitude, currentPosition.longitude),
          width: 40,
          height: 40,
          builder: (context) => Transform.translate(
            offset: Offset(0, 0), // Reduced from -20 to -10
            child: Icon(
              Icons.location_pin,
              color: Colors.blue,
              size: 40,
            ),
          ),
          anchorPos: AnchorPos.align(AnchorAlign.top),
        ),
      );
    }

    markers.add(
      Marker(
        point: LatLng(restaurant.latitude, restaurant.longitude),
        width: 40,
        height: 40,
        builder: (context) => Transform.translate(
          offset: Offset(0, 0), // Reduced from -20 to -10
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/loc.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        anchorPos: AnchorPos.align(AnchorAlign.top),
      ),
    );

    return markers;
  }

  Future<List<LatLng>> getRoutePoints(LatLng start, LatLng end) async {
    try {
      final response = await http.get(Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}'
        '?overview=full&geometries=polyline'
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final String encodedPolyline = data['routes'][0]['geometry'];
          
          PolylinePoints polylinePoints = PolylinePoints();
          List<PointLatLng> decodedPoints = 
              polylinePoints.decodePolyline(encodedPolyline);

          List<LatLng> points = decodedPoints
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
              
          // Add a small offset to create space between markers and polyline
          final double offset = 0.00001; // Adjust this value as needed
          LatLng adjustedStart = LatLng(
            start.latitude - offset,
            start.longitude
          );
          LatLng adjustedEnd = LatLng(
            end.latitude - offset,
            end.longitude
          );
              
          if (points.isNotEmpty) {
            points.insert(0, adjustedStart);
            points.add(adjustedEnd);
          } else {
            points = [adjustedStart, adjustedEnd];
          }

          return points;
        }
      }
      throw Exception('Failed to fetch route');
    } catch (e) {
      print('Error getting route: $e');
      return [start, end];
    }
  }


}