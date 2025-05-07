
import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<Restaurant> restaurants;
  final List<Restaurant> filteredRestaurants;
  final String searchQuery;
  final bool isSearchFocused;

  const RestaurantLoaded({
    required this.restaurants,
    required this.filteredRestaurants,
    this.searchQuery = '',
    this.isSearchFocused = false,
  });

  @override
  List<Object?> get props => [
        restaurants,
        filteredRestaurants,
        searchQuery,
        isSearchFocused,
      ];

  RestaurantLoaded copyWith({
    List<Restaurant>? restaurants,
    List<Restaurant>? filteredRestaurants,
    String? searchQuery,
    bool? isSearchFocused,
  }) {
    return RestaurantLoaded(
      restaurants: restaurants ?? this.restaurants,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchFocused: isSearchFocused ?? this.isSearchFocused,
    );
  }
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError(this.message);

  @override
  List<Object?> get props => [message];
}