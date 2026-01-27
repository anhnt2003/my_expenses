/* Exception classes for try-catch blocks before converting to Failures */

class CacheException implements Exception {
  final String message;
  final String? code;

  const CacheException(this.message, {this.code});

  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  final String message;
  final String? field;

  const ValidationException(this.message, {this.field});

  @override
  String toString() =>
      'ValidationException: $message${field != null ? ' (field: $field)' : ''}';
}

class DatabaseException implements Exception {
  final String message;
  final dynamic originalError;

  const DatabaseException(this.message, {this.originalError});

  @override
  String toString() => 'DatabaseException: $message';
}
