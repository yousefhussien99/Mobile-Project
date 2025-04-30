import 'package:equatable/equatable.dart';

/// 🔹 Base Failure Class
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// 🔹 Specific Failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class OfflineFailure extends Failure {
  const OfflineFailure() : super("No internet connection.");
}

class EmptyCacheFailure extends Failure {
  const EmptyCacheFailure() : super("No data found in cache.");
}

class WrongDataFailure extends Failure {
  const WrongDataFailure() : super("Invalid data provided.");
}

class DatabaseFailure extends Failure {
  const DatabaseFailure() : super("Database error occurred.");
}
