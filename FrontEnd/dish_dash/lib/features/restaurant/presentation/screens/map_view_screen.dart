import 'package:dish_dash/features/restaurant/presentation/cubit/map_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/map_state.dart';
import '../widgets/map_section.dart';
import '../widgets/map_widgets.dart';

class MapScreen extends StatefulWidget {
  final List<dynamic> restaurants;

  const MapScreen({super.key, required this.restaurants});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  bool _mapReady = false;

  void _onMapReady() {
    setState(() {
      _mapReady = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    context.read<MapCubit>().getCurrentLocation();
  }


  void _moveToLocation(LatLng location) {
    if (_mapReady) {
      _mapController.move(location, 15.0);
    } else {
      print('Map not ready yet!');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              return mapSection(state, _mapController, _onMapReady);
            },
          ),

          // My Location Button
          Positioned(
            top: 40,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'myLocationBtn',
              onPressed: () {
                final state = context.read<MapCubit>().state;
                if (state is MapLoaded && state.currentPosition != null) {
                  _moveToLocation(
                    LatLng(
                      state.currentPosition!.latitude,
                      state.currentPosition!.longitude,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Current location not available')),
                  );
                }
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.my_location, color: Colors.blueAccent),
            ),
          ),

          // Restaurant List
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                ],
              ),
              padding: EdgeInsets.all(8),
              child: buildRestaurantList(
                context,
                widget.restaurants,
                _moveToLocation,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
