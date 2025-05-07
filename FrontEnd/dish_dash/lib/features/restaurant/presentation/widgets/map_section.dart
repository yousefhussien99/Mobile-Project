import 'package:dish_dash/features/restaurant/presentation/cubit/map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Positioned mapSection(MapState state, MapController mapController) {
  return Positioned.fill(
              top: 80,
              child: state is MapLoading
                  ? Center(child: CircularProgressIndicator())
                  : state is MapError
                      ? Center(child: Text(state.message))
                      : state is MapLoaded
                          ? FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                center: state.currentPosition != null
                                    ? LatLng(
                                        state.currentPosition!.latitude,
                                        state.currentPosition!.longitude,
                                      )
                                    : LatLng(40.7128, -74.006),
                                zoom: 14.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.dish.dash.app',
                                ),
                                MarkerLayer(markers: state.markers),
                              ],
                            )
                          : Container(),
            );
}

