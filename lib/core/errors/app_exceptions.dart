// تعريفات الأخطاء الموحّدة للتعامل مع الفشل داخل التطبيق.
class AppException implements Exception {
  AppException(this.message);

  final String message;

  @override
  String toString() => message;
}
