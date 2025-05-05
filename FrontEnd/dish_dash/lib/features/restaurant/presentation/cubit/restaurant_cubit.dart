import 'package:bloc/bloc.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/restaurant_state.dart';
import '../../domain/entities/restaurant.dart';

// part 'restaurant_state.dart';

// Cubit
class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit() : super(RestaurantInitial());

  void setSearchFocus(bool isFocused) {
    if (state is RestaurantLoaded) {
      final currentState = state as RestaurantLoaded;
      emit(currentState.copyWith(isSearchFocused: isFocused));
    }
  }

  void loadRestaurants() async {
    emit(RestaurantLoading());

    try {

      await Future.delayed(const Duration(milliseconds: 500));

      final restaurants = [
        Restaurant(
          id: '1',
          name: 'Starbucks',
          logoUrl: 'assets/logos/starbucks.svg',
          categories: ['Coffee'],
          isOpen: true,
          address: '123 Coffee St, Brewtown',
          coverImageUrl: 'assets/logos/starbucks.svg',
        ),
        Restaurant(
          id: '2',
          name: 'Subway',
          logoUrl: 'assets/logos/subway.svg',
          categories: ['Fast Food'],
          isOpen: true,
          address: '456 Sandwich Ave, Deli City',
          coverImageUrl: 'assets/logos/subway.svg',
        ),
        Restaurant(
          id: '3',
          name: 'Burger King',
          logoUrl: 'assets/logos/burger_king.svg',
          categories: ['Fast Food'],
          isOpen: true,
          address: '123 Main St, Cityville',
          coverImageUrl: 'assets/logos/burger_king.svg',
        ),
        Restaurant(
          id: '4',
          name: 'Taco Bell',
          logoUrl: 'assets/logos/taco_bell.svg',
          categories: ['Coffee'],
          isOpen: true,
          address: '456 Elm St, Townsville',
          coverImageUrl: 'assets/logos/taco_bell.svg',

        ),
        Restaurant(
          id: '5',
          name: 'Pizza Hut',
          logoUrl: 'assets/logos/pizza_hut.svg',
          categories: ['Fast Food'],
          isOpen: true,
          address: '789 Oak St, Villagetown',
          coverImageUrl: 'assets/logos/pizza_hut.svg',
        ),
        Restaurant(
          id: '6',
          name: 'McDonald\'s',
          logoUrl: 'assets/logos/mcdonalds.svg',
          categories: ['Fast Food'],
          isOpen: true,
          address: '101 Pine St, Hamletburg',
          coverImageUrl: 'assets/logos/mcdonalds.svg',
        ),
      ];

      emit(RestaurantLoaded(
        restaurants: restaurants,
        filteredRestaurants: restaurants,
      ));
    } catch (e) {
      emit(RestaurantError('Failed to load restaurants: $e'));
    }
  }

  void searchRestaurants(String query) {
    if (state is RestaurantLoaded) {
      final currentState = state as RestaurantLoaded;

      // 1. Filter restaurants based on query
      final filteredList = query.isEmpty
          ? currentState.restaurants
          : currentState.restaurants.where((restaurant) {
        return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.categories.any((category) =>
                category.toLowerCase().contains(query.toLowerCase()));
      }).toList();

      final suggestions = _generateSuggestions(
        query: query,
        restaurants: currentState.restaurants,
      );

      emit(currentState.copyWith(
        filteredRestaurants: filteredList,
        searchQuery: query,
        searchSuggestions: suggestions,
      ));
    }
  }

  List<String> _generateSuggestions({
    required String query,
    required List<Restaurant> restaurants,
  }) {
    if (query.isEmpty) return [];

    final suggestions = <String>{};

    suggestions.addAll(
      restaurants
          .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
          .map((r) => r.name)
          .take(3),
    );


    suggestions.addAll(
      restaurants
          .expand((r) => r.categories)
          .where((category) => category.toLowerCase().contains(query.toLowerCase()))
          .toSet()
          .take(2),
    );

    return suggestions.toList();
  }
}

