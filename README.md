<h1 align="center">Result Type for Dart</h1>

<p align="center">
    <a href="https://github.com/epam-cross-platform-lab/dart_result_type/actions">
    <img src="https://github.com/epam-cross-platform-lab/dart_result_type/workflows/Dart/badge.svg" alt="CI Status" />
  </a>

  <a href="https://codecov.io/gh/epam-cross-platform-lab/dart_result_type">
    <img src="https://codecov.io/gh/epam-cross-platform-lab/dart_result_type/branch/main/graph/badge.svg?token=8HOYKOPG31"/>
  </a>

  <a href="https://github.com/epam-cross-platform-lab/dart_result_type/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-Apache-blue.svg" alt="Result Type is released under the Apache license." />
  </a>

  <a href="https://github.com/tenhobi/effective_dart">
    <img src="https://img.shields.io/badge/style-effective_dart-40c4ff.svg" alt="Effective Dart" />
  </a>

  <a href="https://github.com/epam-cross-platform-lab/dart_result_type/blob/main/CODE_OF_CONDUCT.md">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs welcome!" />
  </a>
</p>

# Content

- [Features](#features)
- [Requirements](#requirements)
- [Install](#install)
- [Example](#example)
- [Support](#support)
- [License](#license)

## Features

Result is a type that represents either [Success](https://github.com/epam-cross-platform-lab/dart_result_type/blob/main/lib/src/success.dart) or [Failure](https://github.com/epam-cross-platform-lab/dart_result_type/blob/main/lib/src/failure.dart).

Inspired by [functional programming](http://hackage.haskell.org/package/base-4.12.0.0/docs/Data-Either.html), [Rust](https://doc.rust-lang.org/std/result/enum.Result.html) and [Swift](https://developer.apple.com/documentation/swift/result).

## Requirements

- Dart: 2.12.0+

## Install

```yaml
dependencies:
  result_type: ^0.1.0
```

## Example

The detailed example can be found at [result_type/example/example.dart](https://github.com/epam-cross-platform-lab/dart_result_type/blob/main/example/example.dart).

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:result_type/result_type.dart';

void main() async {
  final random = Random();
  final client = http.Client();
  final result = await getPhotos(client);

  /// Do something with successful operation results or handle an error.
  if (result.isSuccess) {
    print('Photos Items: ${result.success}');
  } else {
    print('Error: ${result.failure}');
  }

  /// Apply transformation to successful operation results or handle an error.
  if (result.isSuccess) {
    final items = result.map((i) => i.where((j) => j.title.length > 60)).success;
    print('Number of Long Titles: ${items.length}');
  } else {
    print('Error: ${result.failure}');
  }

  /// In this example, note the difference in the result of using `map` and
  /// `flatMap` with a transformation that returns an result type.
  Result<int, Error> getNextInteger() => Success(random.nextInt(4));
  Result<int, Error> getNextAfterInteger(int n) => Success(random.nextInt(n + 1));

  final nextIntegerNestedResults = getNextInteger().map(getNextAfterInteger);
  print(nextIntegerNestedResults.runtimeType);
  /// `Prints`: Success<Result<int, Error>, dynamic>

  final nextIntegerUnboxedResults =  getNextInteger().flatMap(getNextAfterInteger);
  print(nextIntegerUnboxedResults.runtimeType);
  /// `Prints`: Success<int, Error>

  /// Use completion handler / callback style API if you want to.
  await getPhotos(client)
    ..result((photos) {
      print('Photos: $photos');
    }, (error) {
      print('Error: $error');
    });
}
```

To see examples of the following package in action:

```sh
cd example && dart run
```

## Support

Post issues and feature requests on the GitHub [issue tracker](https://github.com/epam-cross-platform-lab/dart_result_type/issues).

## License

The source code of Result Type project is available under the Apache license.
See the [LICENSE](https://github.com/epam-cross-platform-lab/dart_result_type/blob/main/LICENSE) file for more info.
