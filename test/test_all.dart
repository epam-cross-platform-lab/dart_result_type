import 'package:test/test.dart';

import 'failure_test.dart' as failure;
import 'result_test.dart' as result;
import 'success_test.dart' as success;

void main() {
  group('success', success.main);
  group('failure', failure.main);
  group('result', result.main);
}
