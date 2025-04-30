import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> register(
      String userName,
      String email,
      String password,
      String? gender,
      int? level,
      ) async {
    try {
      final userModel = UserModel(
        userName: userName,
        email: email,
        password: password,
        gender: gender,
        level: level,
      );

      final message = await remoteDataSource.register(userModel);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error during registration'));
    }
  }

  @override
  Future<Either<Failure, Unit>> login(
      String email,
      String password,
      ) async {
    try {
      await remoteDataSource.login(email: email, password: password);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error during login'));
    }
  }
}
