// أدوات مساعدة عامة (Utilities) لتبسيط منطق التطبيق.
import 'dart:async';

class Debouncer {
  Debouncer({required this.delay}); //بياخد قيمة اسمها delay (مدة زمنية).

  final Duration delay;
  Timer? _timer;

  void call(void Function() action) { //عندما يتم استدعاء الـ Debouncer، يتم تمرير دالة (action) ليتم تنفيذها بعد فترة التأخير المحددة.
    _timer?.cancel();//إذا كان هناك مؤقت (Timer) نشط بالفعل، يتم إلغاؤه لمنع تنفيذ الدالة السابقة.
    _timer = Timer(delay, action); //يتم إنشاء مؤقت جديد (Timer) يتم ضبطه على فترة التأخير المحددة، وعند انتهاء هذه الفترة، يتم تنفيذ الدالة (action).
  }

  void dispose() { //عندما لا نحتاج إلى الـ Debouncer بعد الآن، يمكننا استدعاء دالة dispose لإلغاء أي مؤقت نشط ومنع تسرب الذاكرة.
    _timer?.cancel();
  }
}
 //يُستخدم لتقليل عدد مرات تنفيذ دالة معيّنة عند تكرار حدث بسرعة (مثل الكتابة في البحث). Debouncer