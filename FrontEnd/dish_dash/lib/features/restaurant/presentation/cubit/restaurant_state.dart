
//
// sealed class RestaurantState extends Equatable {
//   const RestaurantState();
// }
//
// final class RestaurantInitial extends RestaurantState {
//   @override
//   List<Object> get props => [];
// }

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/restaurant_model.dart';
import '../../domain/entities/restaurant.dart';

// part of 'restaurant_cubit.dart';
// States
abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<Restaurant> restaurants;
  final List<Restaurant> filteredRestaurants;
  final String searchQuery;
  final bool isSearchFocused;
  final List<String> searchSuggestions;

  RestaurantLoaded({
    required this.restaurants,
    required this.filteredRestaurants,
    this.searchQuery = '',
    this.isSearchFocused = false,
    this.searchSuggestions = const [],
  });

  @override
  List<Object> get props => [
    restaurants,
    filteredRestaurants,
    searchQuery,
    isSearchFocused,
    searchSuggestions,
  ];

  RestaurantLoaded copyWith({
    List<Restaurant>? restaurants,
    List<Restaurant>? filteredRestaurants,
    String? searchQuery,
    bool? isSearchFocused,
    List<String>? searchSuggestions,
  }) {
    return RestaurantLoaded(
      restaurants: restaurants ?? this.restaurants,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchFocused: isSearchFocused ?? this.isSearchFocused,
      searchSuggestions: searchSuggestions ?? this.searchSuggestions,
    );
  }
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError(this.message);

  @override
  List<Object> get props => [message];
}