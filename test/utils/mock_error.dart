class MockError implements Exception {
  final int code;

  const MockError(this.code);

  @override
  String toString() => 'MockError(code: $code)';
}
