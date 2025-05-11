import 'dart:convert';
import 'package:dish_dash/core/const/const.dart';
import 'package:dish_dash/core/errors/exceptions.dart';
import 'package:dish_dash/features/restaurant/data/models/product_model.dart';
import 'package:dish_dash/features/restaurant/data/models/restaurant_model.dart';
import 'package:dish_dash/features/restaurant/data/models/storeProduct_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/storeProduct.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<StoreProductModel>> getPopularProducts(String query);
  Future<List<RestaurantModel>> getAllRestaurants();
  Future<List<StoreProductModel>> getProductsByRestaurant(String restaurantId);
  Future<List<ProductModel>> getProducts();
  Future<List<StoreProductModel>> getProductsBySearch(String query);
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final client = http.Client();
  final baseUrl = Constants.baseUrl;

  static final RestaurantRemoteDataSourceImpl _instance = 
      RestaurantRemoteDataSourceImpl._internal();

  RestaurantRemoteDataSourceImpl._internal();

  factory RestaurantRemoteDataSourceImpl() {
    return _instance;
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<StoreProductModel>> getPopularProducts(String query) async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/product/store/products/name/?product_name=$query'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => StoreProductModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'Unauthorized access');
    } else {
      throw ServerException(message: 'Failed to fetch products');
    }
  }


  @override
  Future<List<RestaurantModel>> getAllRestaurants() async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/store/stores/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => RestaurantModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'Unauthorized access');
    } else {
      throw ServerException(message: 'Failed to fetch all restaurants');
    }
  }

 @override
  Future<List<StoreProductModel>> getProductsByRestaurant(String restaurantId) async {
    try {
      final headers = await _getHeaders();
      
      final url = '$baseUrl/product/store/$restaurantId/products/';

      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        
        return jsonList.map((json) => StoreProductModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw ServerException(message: 'Unauthorized access');
      } else {
        throw ServerException(message: 'Failed to fetch restaurant products');
      }
    } catch (e, stackTrace) {
      print('Exception occurred while fetching products: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/product/products/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'Unauthorized access');
    } else {
      throw ServerException(message: 'Failed to fetch products');
    }
  }

  @override
  Future<List<StoreProductModel>> getProductsBySearch(String query) async {
    try {
      return await _fetchAndFilterProducts(query);
    } catch (e, stackTrace) {
      print('Exception in getProductsBySearch: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }


  Future<List<StoreProductModel>> _fetchAndFilterProducts(String query) async {
    final List<int> restaurantIds = [19, 20, 21, 22, 23, 24];

    // Fetch all restaurant products in parallel
    final List<List<StoreProductModel>> allProductLists = await Future.wait(
        restaurantIds.map((id) => getProductsByRestaurant(id.toString()))
    );

    // Flatten all products into one list
    final List<StoreProductModel> allProducts = allProductLists.expand((list) => list).toList();
    final List<StoreProductModel> matchedProducts = [];

    // Match by product name
    for (final product in allProducts) {
      if (product.product.name.toLowerCase().contains(query.toLowerCase())) {
        matchedProducts.add(product);
      }
    }

    // Match by product description (only if not already matched)
    for (final product in allProducts) {
      if (product.product.description.toLowerCase().contains(query.toLowerCase()) &&
          !matchedProducts.any((p) => p.id == product.id)) {
        matchedProducts.add(product);
      }
    }

    return matchedProducts;
  }

}