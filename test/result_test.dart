import 'dart:math';

import 'package:result_type/result_type.dart';
import 'package:test/test.dart';

import 'utils/mock_error.dart';

void main() {
  group('Result:', () {
    Random? random;

    setUp(() {
      random = Random();
    });

    tearDown(() {
      random = null;
    });

    test('Returns Success', () {
      Result<String, MockError> getUser() =>
          (true) ? Success('John Doe') : Failure(const MockError(404));

      final result = getUser();
      if (result.isSuccess) {
        print('Success: ${result.success}');
      } else {
        print('Error: ${result.failure}');
      }

      expect(result.success, 'John Doe');
    });

    test('Returns Failure', () {
      Result<String, MockError> getUser() =>
          (false) ? Success('John Doe') : Failure(const MockError(404));

      final result = getUser();
      if (result.isSuccess) {
        print('Success: ${result.success}');
      } else {
        print('Error: ${result.failure}');
      }

      expect(result.failure, const MockError(404));
    });

    test('Returns Success From Callbacks', () {
      Result<String, MockError> getUser() =>
          (true) ? Success('John Doe') : Failure(const MockError(404));

      getUser()
        ..result((success) {
          expect(success, 'John Doe');
        }, (_) {});
    });

    test('Returns Failure From Callbacks', () {
      Result<String, MockError> getUser() =>
          (false) ? Success('John Doe') : Failure(const MockError(404));

      getUser()
        ..result((_) {}, (error) {
          expect(error, const MockError(404));
        });
    });

    test(
        '''Throw Exception when accessing success value without checking if isSuccess''',
        () {
      Result<String, MockError> getUser() =>
          (false) ? Success('John Doe') : Failure(const MockError(404));

      final result = getUser();

      expect(() => result.success, throwsException);
    });

    test(
        '''Throw Exception when accessing failure value without checking if isFailure''',
        () {
      Result<String, MockError> getUser() =>
          (true) ? Success('John Doe') : Failure(const MockError(404));

      final result = getUser();

      expect(() => result.failure, throwsException);
    });

    test('Apply map transformation to successful operation results', () {
      Result<String, MockError> getUser() =>
          (true) ? Success('John Doe') : Failure(const MockError(404));

      final result = getUser();
      final user = result.map((i) => i.toUpperCase()).success;

      expect(user, 'JOHN DOE');
    });

    test(
        '''Throw an error from map transformation without applying transformation to error type''',
        () {
      Result<String, MockError> getUser() =>
          (false) ? Success('John Doe') : Failure(const MockError(404));

      final result = getUser();
      final error = result.map((i) => i.toUpperCase()).failure;

      expect(error, const MockError(404));
    });

    test('Apply mapError transformation to failure type', () {
      Result<String, MockError> getUser() =>
          (false) ? Success('John Doe') : Failure(const MockError(404));

      final error = getUser().mapError((i) => MockError(i.code - 4)).failure;

      expect(error.code, const MockError(400).code);
    });

    test(
        '''Returns successful result without applying mapError transformation''',
        () {
      Result<String, MockError> getUser() =>
          (true) ? Success('John Doe') : Failure(const MockError(404));

      final maybeError = getUser().mapError((i) => MockError(i.code - 4));

      if (maybeError.isFailure) {
      } else {
        expect(maybeError.success, 'John Doe');
      }
    });

    test('Apply flatMap transformation to successful operation results', () {
      Result<int, MockError> getNextInteger() => Success(random!.nextInt(4));
      Result<int, MockError> getNextAfterInteger(int n) =>
          Success(random!.nextInt(n + 1));

      final nextIntegerUnboxedResults =
          getNextInteger().flatMap(getNextAfterInteger);

      expect(
        nextIntegerUnboxedResults,
        const TypeMatcher<Success<int, MockError>>(),
      );
    });

    test('flatMap does not apply transformation to Failure', () {
      Result<int, MockError> getNextInteger() => Failure(const MockError(451));
      Result<int, MockError> getNextAfterInteger(int n) =>
          Failure(const MockError(404));

      final nextIntegerUnboxedResults =
          getNextInteger().flatMap(getNextAfterInteger);

      expect(
        nextIntegerUnboxedResults,
        const TypeMatcher<Failure<int, MockError>>(),
      );
    });

    test('Apply flatMapError transformation to failure operation results', () {
      Result<int, MockError> getNextInteger() => Failure(const MockError(451));
      Result<int, MockError> getNextAfterInteger(MockError error) =>
          Failure(MockError(error.code));

      final nextIntegerUnboxedResults =
          getNextInteger().flatMapError(getNextAfterInteger);

      expect(
        nextIntegerUnboxedResults,
        const TypeMatcher<Failure<int, MockError>>(),
      );
    });

    test(
        '''flatMapError does not apply transformation to success operation results''',
        () {
      Result<int, MockError> getNextInteger() => Success(random!.nextInt(4));
      Result<int, MockError> getNextAfterInteger(MockError error) =>
          Failure(MockError(error.code));

      final nextIntegerUnboxedResults =
          getNextInteger().flatMapError(getNextAfterInteger);

      expect(
        nextIntegerUnboxedResults,
        const TypeMatcher<Success<int, MockError>>(),
      );
    });
  });
}
