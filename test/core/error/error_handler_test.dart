import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecoguard/core/error/error_handler.dart';

void main() {
  group('ErrorHandler', () {
    setUp(() {
      ErrorHandler.initialize();
    });

    group('handleApiError', () {
      test('should handle timeout exception', () {
        final String result = ErrorHandler.handleApiError(
          TimeoutException('Request timeout'),
        );
        expect(
          result,
          contains('Request timed out'),
        );
      });

      test('should handle 401 unauthorized error', () {
        final String result = ErrorHandler.handleApiError(
          Exception('401 Unauthorized'),
        );
        expect(result, contains('Session expired'));
      });

      test('should handle 403 forbidden error', () {
        final String result = ErrorHandler.handleApiError(
          Exception('403 Forbidden'),
        );
        expect(result, contains('Access denied'));
      });

      test('should handle 404 not found error', () {
        final String result = ErrorHandler.handleApiError(
          Exception('404 Not Found'),
        );
        expect(result, contains('Resource not found'));
      });

      test('should handle 500 server error', () {
        final String result = ErrorHandler.handleApiError(
          Exception('500 Internal Server Error'),
        );
        expect(result, contains('Server error'));
      });

      test('should handle socket exception', () {
        final String result = ErrorHandler.handleApiError(
          Exception('SocketException: No internet'),
        );
        expect(result, contains('No internet connection'));
      });

      test('should handle generic error', () {
        final String result = ErrorHandler.handleApiError(
          Exception('Unknown error'),
        );
        expect(result, contains('unexpected error'));
      });
    });

    group('withErrorHandling', () {
      test('should return result on success', () async {
        final int? result = await ErrorHandler.withErrorHandling<int>(
          operation: () async => 42,
          operationName: 'Test Operation',
        );
        expect(result, equals(42));
      });

      test('should retry on failure and eventually succeed', () async {
        int attempts = 0;
        final int? result = await ErrorHandler.withErrorHandling<int>(
          operation: () async {
            attempts++;
            if (attempts < 2) {
              throw Exception('Temporary failure');
            }
            return 42;
          },
          operationName: 'Retry Test',
          maxRetries: 3,
          retryDelay: const Duration(milliseconds: 10),
        );
        expect(result, equals(42));
        expect(attempts, equals(2));
      });

      test('should throw after max retries', () async {
        int attempts = 0;
        expect(
          () async {
            await ErrorHandler.withErrorHandling<int>(
              operation: () async {
                attempts++;
                throw Exception('Persistent failure');
              },
              operationName: 'Failure Test',
              maxRetries: 3,
              retryDelay: const Duration(milliseconds: 10),
            );
          },
          throwsException,
        );
        expect(attempts, equals(3));
      });

      test('should respect shouldRetry predicate', () async {
        int attempts = 0;
        expect(
          () async {
            await ErrorHandler.withErrorHandling<int>(
              operation: () async {
                attempts++;
                throw Exception('Should not retry');
              },
              operationName: 'No Retry Test',
              maxRetries: 3,
              shouldRetry: (dynamic error) => false,
            );
          },
          throwsException,
        );
        expect(attempts, equals(1)); // Should only try once
      });
    });
  });
}
