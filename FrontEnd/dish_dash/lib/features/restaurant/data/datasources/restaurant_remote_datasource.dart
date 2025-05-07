import 'dart:convert';
import 'package:dish_dash/core/const/const.dart';
import 'package:dish_dash/core/errors/exceptions.dart';
import 'package:dish_dash/features/restaurant/data/models/product_model.dart';
import 'package:dish_dash/features/restaurant/data/models/restaurant_model.dart';
import 'package:dish_dash/features/restaurant/data/models/storeProduct_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class RestaurantRemoteDataSource {
  Future<RestaurantModel> getRestaurantById(String id);
  Future<List<RestaurantModel>> getAllRestaurants();
  Future<List<StoreProductModel>> getProductsByRestaurant(String restaurantId);
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
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
  Future<RestaurantModel> getRestaurantById(String id) async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/store/stores/$id/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return RestaurantModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'Unauthorized access');
    } else {
      throw ServerException(message: 'Failed to fetch restaurant');
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
      print('Getting products for restaurant ID: $restaurantId');
      final headers = await _getHeaders();
      
      final url = '$baseUrl/product/store/$restaurantId/products/';
      print('Making GET request to: $url');

      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Successfully parsed JSON list. Number of products: ${jsonList.length}');
        
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
  Future<ProductModel> getProductById(String id) async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/product/products/$id/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'Unauthorized access');
    } else {
      throw ServerException(message: 'Failed to fetch product');
    }
  }

  void dispose() {
    client.close();
  }
}