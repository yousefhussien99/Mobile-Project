import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit() : super(RestaurantInitial());
}
