import 'failure.dart';
import 'success.dart';

/// Callbacks that return [Failure] or [Success].
typedef Completion<T> = void Function(T value);

/// A value that represents either a success or a failure, including an
/// associated value in each case.
abstract class Result<S, F> {
  Result() {
    if (!isFailure && !isSuccess) {
      throw Exception('The Result must be a [Success] or a [Failure].');
    }
  }

  /// Returns true if [Result] is [Failure].
  bool get isFailure => this is Failure<S, F>;

  /// Returns true if [Result] is [Success].
  bool get isSuccess => this is Success<S, F>;

  /// Returns a new value of [Failure] result.
  F get failure {
    if (this is Failure<S, F>) {
      return (this as Failure<S, F>).value;
    }

    throw Exception(
        'Make sure that result [isFailure] before accessing [failure]');
  }

  /// Returns a new value of [Success] result.
  S get success {
    if (this is Success<S, F>) {
      return (this as Success<S, F>).value;
    }

    throw Exception(
        'Make sure that result [isSuccess] before accessing [success]');
  }

  /// Returns a new value of [Result] from closure.
  void result(Completion<S> success, Completion<F> failure) {
    if (isSuccess) {
      final left = this as Success<S, F>;
      success(left.value);
    }

    if (isFailure) {
      final right = this as Failure<S, F>;
      failure(right.value);
    }
  }
}
