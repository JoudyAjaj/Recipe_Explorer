// أدوات مساعدة عامة (Utilities) لتبسيط منطق التطبيق.
class Debouncer {
  Debouncer({required this.delay});

  final Duration delay;
  void call(void Function() action) {
    action();
  }
}
