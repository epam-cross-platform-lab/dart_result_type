// ignore_for_file: lines_longer_than_80_chars, avoid_shadowing_type_parameters
import 'failure.dart';
import 'success.dart';

/// Callbacks that return [Success] or [Failure].
typedef Completion<T> = void Function(T value);

/// A value that represents either a success or a failure, including an
/// associated value in each case.
abstract class Result<S, F> {
  /// Returns true if [Result] is [Failure].
  bool get isFailure => this is Failure<S, F>;

  /// Returns true if [Result] is [Success].
  bool get isSuccess => this is Success<S, F>;

  /// Returns a new value of [Failure] result.
  ///
  /// Handle an error or do something with successful operation results:
  ///
  /// ```dart
  /// final result = await getPhotos();
  ///
  /// if (result.isFailure) {
  ///   print('Error: ${result.failure}');
  /// } else {
  ///   print('Photos Items: ${result.success}');
  /// }
  /// ```
  ///
  F get failure {
    if (this is Failure<S, F>) {
      return (this as Failure<S, F>).value;
    }

    throw Exception(
      'Make sure that result [isFailure] before accessing [failure]',
    );
  }

  /// Returns a new value of [Success] result.
  ///
  /// Do something with successful operation results or handle an error:
  ///
  /// ```dart
  /// final result = await getPhotos();
  ///
  /// if (result.isSuccess) {
  ///   print('Photos Items: ${result.success}');
  /// } else {
  ///   print('Error: ${result.failure}');
  /// }
  /// ```
  ///
  S get success {
    if (this is Success<S, F>) {
      return (this as Success<S, F>).value;
    }

    throw Exception(
      'Make sure that result [isSuccess] before accessing [success]',
    );
  }

  /// Returns a new value of [Result] from closure
  /// either a success or a failure.
  ///
  /// This example shows how to use completion handler.
  ///
  /// ```dart
  /// final result = await getPhotos();
  ///
  /// await getPhotos(client)
  /// ..result((photos) {
  ///   print('Photos: $photos');
  /// }, (error) {
  ///   print('Error: $error');
  /// });
  /// ```
  ///
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

  /// Maps a [Result<S, F>] to [Result<U, F>] by applying a function
  /// to a contained [Success] value, leaving an [Failure] value untouched.
  /// This function can be used to compose the results of two functions.
  ///
  /// Apply transformation to successful operation results or handle an error:
  ///
  /// ```dart
  /// final result = await getPhotos();
  ///
  /// if (result.isSuccess) {
  ///   final items = result.map((i) => i.where((j) => j.title.length > 60)).success;
  ///   print('Number of Long Titles: ${items.length}');
  /// } else {
  ///   print('Error: ${result.failure}');
  /// }
  /// ```
  ///
  Result<U, F> map<U, F>(U Function(S) transform) {
    if (isSuccess) {
      final left = this as Success<S, F>;
      return Success(transform(left.value));
    } else {
      final right = this as Failure<S, F>;
      return Failure(right.value);
    }
  }

  /// Maps a [Result<S, F>] to [Result<S, E>] by applying a function
  /// to a contained [Failure] value, leaving an [Success] value untouched.
  ///
  /// This function can be used to pass through a successful result
  /// while applying transformation to [Failure].
  ///
  Result<S, E> mapError<S, E>(E Function(F) transform) {
    if (isSuccess) {
      final left = this as Success<S, F>;
      return Success(left.value);
    } else {
      final right = this as Failure<S, F>;
      return Failure(transform(right.value));
    }
  }

  /// Maps a [Result<S, F>] to [Result<U, F>] by applying a function
  /// to a contained [Success] value and unwrapping the produced result,
  /// leaving an [Failure] value untouched.
  ///
  /// Use this method to avoid a nested result when your transformation
  /// produces another [Result] type.
  ///
  /// In this example, note the difference in the result of using `map` and
  /// `flatMap` with a transformation that returns an result type.
  ///
  /// ```dart
  /// Result<int, Error> getNextInteger() => Success(random.nextInt(4));
  /// Result<int, Error> getNextAfterInteger(int n) => Success(random.nextInt(n + 1));
  ///
  /// final nextIntegerNestedResults = getNextInteger().map(getNextAfterInteger);
  /// print(nextIntegerNestedResults.runtimeType);
  /// `Prints: Success<Result<int, Error>, dynamic>`
  ///
  /// final nextIntegerUnboxedResults = getNextInteger().flatMap(getNextAfterInteger);
  /// print(nextIntegerUnboxedResults.runtimeType);
  /// `Prints: Success<int, Error>`
  ///  ```
  Result<U, F> flatMap<U, F>(Result<U, F> Function(S) transform) {
    if (isSuccess) {
      final left = this as Success<S, F>;
      return transform(left.value);
    } else {
      final right = this as Failure<S, F>;
      return Failure(right.value);
    }
  }

  /// Maps a [Result<S, F>] to [Result<S, E>] by applying a function
  /// to a contained [Failure] value, leaving an [Success] value untouched.
  ///
  /// This function can be used to pass through a successful result
  /// while unboxing [Failure] and applying transformation to it.
  ///
  Result<S, E> flatMapError<S, E>(Result<S, E> Function(F) transform) {
    if (isSuccess) {
      final left = this as Success<S, F>;
      return Success(left.value);
    } else {
      final right = this as Failure<S, F>;
      return transform(right.value);
    }
  }
}
