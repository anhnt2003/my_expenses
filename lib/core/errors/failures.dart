/* Failure classes for functional error handling using Either type */

sealed class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() =>
      'Failure: $message${code != null ? ' (code: $code)' : ''}';
}

/* Database operation failures */
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.code});
}

/* Validation failures for form inputs */
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/* Cache operation failures */
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/* Unexpected failures */
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
