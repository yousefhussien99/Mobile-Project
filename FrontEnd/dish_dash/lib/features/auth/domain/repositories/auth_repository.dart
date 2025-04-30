import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure,Unit>> login(
     String email, String password,
  );

  Future<Either<Failure,String>> register(
     String userName, String email, String password, String? gender, int? level,
  );
}
