import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../../../core/const/const.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> register(UserModel user);
  Future<void> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final String baseUrl = Constants.baseUrl;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> register(UserModel user) async {
    try {
      final response = await dio.post(
        '$baseUrl/auth/register/',
        data: user.toJson(),
      );

      if (response.statusCode == 201) {
        return response.data['message']; // "User registered successfully"
      } else {
        throw ServerException(message: 'Registration failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final error = e.response?.data;
        final emailError = error?['email']?.join(' ') ?? 'Email already exists';
        throw ServerException(message: emailError);
      } else {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Unexpected error during registration',
        );
      }
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        '$baseUrl/auth/token/',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['access'];
        final refreshToken = response.data['refresh'];

        final decodedToken = Jwt.parseJwt(accessToken);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);
        await prefs.setString('username', decodedToken['username'] ?? '');
        await prefs.setString('email', decodedToken['email'] ?? '');
      } else {
        throw ServerException(message: 'Invalid login credentials');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['detail'] ?? 'Login failed';
      throw ServerException(message: errorMessage);
    }
  }
}
