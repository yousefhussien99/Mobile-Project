import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String userName,
    required String email,
    required String password,
    String? gender,
    int? level,
  }) async {
    return await repository.register(userName, email, password, gender, level);
  }
}
