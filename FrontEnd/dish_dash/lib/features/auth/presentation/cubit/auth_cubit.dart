import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
  }) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await loginUseCase(email, password);

    _handleAuthResult(result);
  }

  Future<void> register({
    required String userName,
    required String email,
    required String password,
    String? gender,
    int? level,
  }) async {
    emit(AuthLoading());

    final result = await registerUseCase(
        userName: userName,
        email: email,
        password: password,
        gender: gender,
        level: level,
    );

    result.fold(
          (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
          (message) => emit(RegisterSuccess(message: message)),
    );
  }

  void _handleAuthResult(Either<Failure, Unit> result) {
    result.fold(
          (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
          (_) => emit(LoginSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'Unexpected error occurred';
  }
}