import 'package:dish_dash/features/restaurant/presentation/cubit/map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Positioned mapSection(MapState state, MapController mapController, VoidCallback onMapReady) {
  LatLng defaultCenter = LatLng(30.0444, 31.2357); // Cairo, Egypt

  return Positioned.fill(
    child: (state is MapError)
        ? Center(child: Text(state.message))
        : FlutterMap(
      mapController: mapController,
      options: MapOptions(
        onMapReady: onMapReady,
        center: state is MapLoaded && state.currentPosition != null
            ? LatLng(state.currentPosition!.latitude, state.currentPosition!.longitude)
            : defaultCenter,
        zoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.dish.dash.app',
        ),
        MarkerLayer(
          markers: state is MapLoaded ? state.markers : [],
        ),
      ],
    ),
  );
}
