import 'package:dish_dash/features/restaurant/domain/entities/restaurant.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/directions_cubit.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/directions_state.dart';
import 'package:dish_dash/features/restaurant/presentation/widgets/directions_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

class DirectionsScreen extends StatefulWidget {
  final dynamic restaurant;
  final Position? currentPosition;

  const DirectionsScreen({
    Key? key,
    required this.restaurant,
    this.currentPosition,
  }) : super(key: key);

  @override
  State<DirectionsScreen> createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends State<DirectionsScreen> {
  late final DirectionsCubit _directionsCubit;

  @override
  void initState() {
    super.initState();
    _directionsCubit = DirectionsCubit();
    _loadDirections();
  }

  Future<void> _loadDirections() async {
    await _directionsCubit.loadDirections(
      restaurant: widget.restaurant,
      currentPosition: widget.currentPosition,
    );
  }

  @override
  void dispose() {
    _directionsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor:Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Directions to ${widget.restaurant.name}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocBuilder<DirectionsCubit, DirectionsState>(
        bloc: _directionsCubit,
        builder: (context, state) {
          if (state is DirectionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DirectionsError) {
            return buildErrorState(_loadDirections, state.message);
          } else if (state is DirectionsLoaded) {
            final bounds = LatLngBounds.fromPoints(state.polyline.points);

            return Column(
              children: [
                Expanded(child: buildMapSection(_directionsCubit, state, bounds)),
                const SizedBox(height: 12),
                buildInfoSection(context, widget.restaurant, state),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
