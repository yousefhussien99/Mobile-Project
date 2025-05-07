import 'package:dish_dash/features/restaurant/domain/usecases/get_products.dart';
import 'package:dish_dash/features/restaurant/presentation/cubit/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;
  List<Product> _allProducts = [];

  ProductCubit({
    required this.getProductsUseCase,
  }) : super(ProductInitial()) {
    // Load all products when cubit is initialized
    _loadAllProducts();
  }

  Future<void> _loadAllProducts() async {
    emit(ProductLoading('')); // Emit loading state

    final result = await getProductsUseCase();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) {
        _allProducts = products;
        emit(ProductLoaded(products: products, searchQuery: '')); // Emit loaded state with all products
      },
    );
  }

  void searchProducts(String query) async {
    emit(ProductLoading(query));

    try {
      if (query.isEmpty) {
        emit(ProductLoaded(products: _allProducts, searchQuery: query));
        return;
      }

      final filteredProducts = _allProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase());
      }).toList();

      emit(ProductLoaded(products: filteredProducts, searchQuery: query));
    } catch (e) {
      emit(ProductError('Failed to search products: $e'));
    }
  }
}