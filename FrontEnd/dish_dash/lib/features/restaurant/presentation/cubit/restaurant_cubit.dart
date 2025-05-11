import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/restaurant_model.dart';
import '../../domain/repositories/restaurant_repository.dart';
import 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final RestaurantRepository repository;
  List<RestaurantModel>? _cachedRestaurants;


  RestaurantCubit(this.repository,) : super(RestaurantInitial());

  Future<void> fetchRestaurants({bool force = false}) async {
    if (_cachedRestaurants != null && !force) {
      emit(RestaurantsLoaded(_cachedRestaurants!));
      return;
    }

    emit(RestaurantLoading());

    final result = await repository.getAllRestaurants();
    result.fold(
          (failure) => emit(RestaurantError(failure.message)),
          (restaurants) {
        _cachedRestaurants = restaurants;
        emit(RestaurantsLoaded(restaurants));
      },
    );
  }



  Future<void> fetchProducts() async {
    emit(RestaurantLoading());
    final result = await repository.getProducts();
    result.fold(
          (failure) => emit(RestaurantError(failure.message)),
          (products) => emit(ProductsLoaded(products)),
    );
  }

  Future<void> fetchProductsByRestaurant(String restaurantId) async {
    emit(RestaurantLoading());
    final result = await repository.getProductsByRestaurant(restaurantId);
    result.fold(
          (failure) => emit(RestaurantError(failure.message)),
          (products) => emit(StoreProductsLoaded(products)),
    );
  }

  Future<void> fetchPopularProducts(String query) async {
    emit(RestaurantLoading());
    final result = await repository.getPopularProducts(query);
    result.fold(
          (failure) => emit(RestaurantError(failure.message)),
          (products) => emit(StoreProductsLoaded(products)),
    );
  }

  Future<void> fetchProductsBySearch(String query) async {
    emit(RestaurantLoading());
    final result = await repository.getProductsBySearch(query);
    result.fold(
          (failure) => emit(RestaurantError(failure.message)),
          (products) => emit(StoreProductsLoaded(products)),
    );
  }

  void clearProducts() {
    emit(StoreProductsLoaded([]));
  }

}
