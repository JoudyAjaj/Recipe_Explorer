// أدوات مساعدة عامة (Utilities) لتبسيط منطق التطبيق.
import 'dart:async';

class Debouncer {
  Debouncer({required this.delay}); //بياخد قيمة اسمها delay (مدة زمنية).

  final Duration delay;
  Timer? _timer;

  void call(void Function() action) { //
    _timer?.cancel();//
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
 //يُستخدم لتقليل عدد مرات تنفيذ دالة معيّنة عند تكرار حدث بسرعة (مثل الكتابة في البحث). Debouncer