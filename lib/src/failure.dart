import 'package:meta/meta.dart';

import 'result.dart';

/// A failure, storing a [Failure] value.
@immutable
class Failure<S, F> extends Result<S, F> {
  final F value;

  Failure(this.value);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Failure<S, F> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Failure: $value';
}
