import 'package:equatable/equatable.dart';

/// Base class for all failures in the app
/// Using sealed class pattern for exhaustive pattern matching
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic error;

  const Failure({
    required this.message,
    this.code,
    this.error,
  });

  @override
  List<Object?> get props => [message, code, error];
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.error,
  });
}

/// Server-related failures (API errors)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.error,
  });
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.error,
  });
}

/// Local storage failures
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.error,
  });
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.error,
  });
}

/// File operation failures
class FileFailure extends Failure {
  const FileFailure({
    required super.message,
    super.code,
    super.error,
  });
}

/// Unknown/unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.error,
  });
}

/// Extension for converting exceptions to failures
extension ExceptionToFailure on Exception {
  Failure toFailure() {
    if (this is NetworkFailure) return this as NetworkFailure;
    if (this is ServerFailure) return this as ServerFailure;
    if (this is AuthFailure) return this as AuthFailure;

    return UnknownFailure(
      message: toString(),
      error: this,
    );
  }
}