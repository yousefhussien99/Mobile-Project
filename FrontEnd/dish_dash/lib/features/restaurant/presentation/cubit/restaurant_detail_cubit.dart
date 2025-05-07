import 'package:dish_dash/features/restaurant/domain/usecases/get_products_by_restaurant_usecase.dart';
import 'package:dish_dash/features/restaurant/domain/usecases/get_restaurant_by_Id.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/restaurant_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestaurantDetailCubit extends Cubit<RestaurantDetailState> {
  final GetRestaurantByIdUseCase getRestaurantByIdUseCase;
  final GetProductsByRestaurantUseCase getProductsByRestaurantUseCase;

  RestaurantDetailCubit({
    required this.getRestaurantByIdUseCase,
    required this.getProductsByRestaurantUseCase,
  }) : super(RestaurantDetailInitial());

  void loadRestaurantDetails(String restaurantId) async {
    emit(RestaurantDetailLoading(restaurantId));

    try {
      // Get restaurant details
      final restaurantResult = await getRestaurantByIdUseCase(restaurantId);
      
      await restaurantResult.fold(
        (failure) {
          emit(RestaurantDetailError(failure.message));
          return;
        },
        (restaurant) async {
          // Get restaurant products
          final productsResult = await getProductsByRestaurantUseCase(restaurantId);
          
          productsResult.fold(
            (failure) => emit(RestaurantDetailError(failure.message)),
            (products) => emit(RestaurantDetailLoaded(
              restaurant: restaurant,
              menuItems: products,
            )),
          );
        },
      );
    } catch (e) {
      emit(RestaurantDetailError('Failed to load restaurant details: $e'));
    }
  }
}