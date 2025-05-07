import 'package:bloc/bloc.dart';
import 'package:dish_dash/features/restaurant/domain/usecases/get_all_restaurants_usecase.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/restaurant_state.dart';

// Cubit
class RestaurantCubit extends Cubit<RestaurantState> {
  final GetAllRestaurantsUseCase getAllRestaurantsUseCase;
  
  RestaurantCubit({
    required this.getAllRestaurantsUseCase,
  }) : super(RestaurantInitial());

  void setSearchFocus(bool isFocused) {
    if (state is RestaurantLoaded) {
      final currentState = state as RestaurantLoaded;
      emit(currentState.copyWith(isSearchFocused: isFocused));
    }
  }

  void loadRestaurants() async {
    emit(RestaurantLoading());

    final result = await getAllRestaurantsUseCase();
    
    result.fold(
      (failure) => emit(RestaurantError(failure.message)),
      (restaurants) => emit(RestaurantLoaded(
        restaurants: restaurants,
        filteredRestaurants: restaurants,
      )),
    );
  }

  void searchRestaurants(String query) {
    if (state is RestaurantLoaded) {
      final currentState = state as RestaurantLoaded;

      // Filter restaurants based on query
      final filteredList = query.isEmpty
          ? currentState.restaurants
          : currentState.restaurants.where((restaurant) {
              return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
                     restaurant.type.toLowerCase().contains(query.toLowerCase());
            }).toList();

      emit(currentState.copyWith(
        filteredRestaurants: filteredList,
        searchQuery: query,
      ));
    }
  }
}