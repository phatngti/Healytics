import 'dart:async';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:employee_openapi/api.dart';

part 'app_exception.freezed.dart';

/// Normalised application-level exception that
/// unifies all API, network, and unexpected errors
/// into a single sealed hierarchy.
@freezed
sealed class AppException with _$AppException implements Exception {
  const AppException._();

  /// HTTP error returned by the backend.
  const factory AppException.server({
    required int statusCode,
    required String message,
  }) = ServerException;

  /// Network connectivity failure.
  const factory AppException.network({required String message}) =
      NetworkException;

  /// Catch-all for unexpected / unknown errors.
  const factory AppException.unexpected({required String message}) =
      UnexpectedException;

  /// Converts any raw error into an [AppException].
  factory AppException.fromError(Object error) {
    if (error is AppException) return error;

    if (error is ApiException) {
      return AppException.server(
        statusCode: error.code,
        message: _parseApiMessage(error),
      );
    }

    if (error is SocketException) {
      return const AppException.network(
        message:
            'Unable to reach the server. '
            'Please check your connection.',
      );
    }

    if (error is TimeoutException) {
      return const AppException.network(
        message:
            'The request timed out. '
            'Please try again.',
      );
    }

    return AppException.unexpected(message: error.toString());
  }

  /// Human-readable message suitable for UI display.
  String get userMessage => switch (this) {
    ServerException(:final statusCode, :final message) => _serverUserMessage(
      statusCode,
      message,
    ),
    NetworkException(:final message) => message,
    UnexpectedException(:final message) => message,
  };

  static String _serverUserMessage(int statusCode, String message) {
    return switch (statusCode) {
      400 => 'Bad request. Please check your input.',
      401 => 'Session expired. Please sign in again.',
      403 =>
        'You do not have permission '
            'for this action.',
      404 => 'The requested resource was not found.',
      409 =>
        message.isNotEmpty
            ? message
            : 'A conflict occurred. '
                  'Please try again.',
      422 =>
        message.isNotEmpty
            ? message
            : 'Validation error. '
                  'Please review your data.',
      >= 500 => 'Server error. Please try again later.',
      _ => message.isNotEmpty ? message : 'An unknown error occurred.',
    };
  }

  static String _parseApiMessage(ApiException e) {
    final body = e.message;
    if (body != null && body.isNotEmpty) return body;
    return 'Server error (${e.code})';
  }
}
