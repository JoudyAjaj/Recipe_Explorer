// أدوات مساعدة عامة (Utilities) لتبسيط منطق التطبيق.
sealed class Result<T> {
  const Result();
}

final class ResultSuccess<T> extends Result<T> {
  const ResultSuccess(this.data);

  final T data;
}

final class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.message);

  final String message;
}
