import 'package:dio/dio.dart';
import 'package:dish_dash/features/restaurant/data/datasources/restaurant_remote_datasource.dart';
import 'package:dish_dash/features/restaurant/data/repositories/restaurant_repository_impl.dart';
import 'package:dish_dash/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:dish_dash/features/restaurant/domain/usecases/get_all_restaurants_usecase.dart';
import 'package:dish_dash/features/restaurant/domain/usecases/get_product_by_id.dart';
import 'package:dish_dash/features/restaurant/domain/usecases/get_products.dart';
import 'package:dish_dash/features/restaurant/domain/usecases/get_products_by_restaurant_usecase.dart';
import 'package:dish_dash/features/restaurant/domain/usecases/get_restaurant_by_Id.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/directions_cubit.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/map_cubit.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/product_cubit.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/restaurant_detail_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
final sl = GetIt.instance;

Future<void> init() async {
  // ✅ External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  // ✅ Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<RestaurantRemoteDataSource>(
          () => RestaurantRemoteDataSourceImpl());        

  // ✅ Repository
  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<RestaurantRepository>(
          () => RestaurantRepositoryImpl(sl()));        

  // ✅ UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetAllRestaurantsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsByRestaurantUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetRestaurantByIdUseCase(sl()));


  // ✅ Cubit
  sl.registerFactory(() => AuthCubit(loginUseCase: sl(), registerUseCase:sl()));
  sl.registerFactory(() => RestaurantCubit(getAllRestaurantsUseCase: sl()));
  sl.registerFactory(() => ProductCubit(getProductsUseCase: sl()));
  sl.registerFactory(() => RestaurantDetailCubit(getRestaurantByIdUseCase: sl<GetRestaurantByIdUseCase>(), getProductsByRestaurantUseCase: sl<GetProductsByRestaurantUseCase>()));
  sl.registerFactory(() => MapCubit(getRestaurantsUseCase: sl()));
  sl.registerFactory(() => DirectionsCubit());

}
