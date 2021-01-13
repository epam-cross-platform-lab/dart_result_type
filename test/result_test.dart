import 'package:result_type/result_type.dart';
import 'package:test/test.dart';

import 'utils/mock_error.dart';

void main() {
  group('Result', () {
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
  });
}
