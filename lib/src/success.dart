import 'package:meta/meta.dart';

import 'result.dart';

/// A success, storing a [Success] value.
@immutable
class Success<S, F> extends Result<S, F> {
  final S value;

  Success(this.value);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Success<S, F> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success: $value';
}
