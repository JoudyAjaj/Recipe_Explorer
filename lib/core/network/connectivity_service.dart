// طبقة الشبكة: تجهيزات الاتصال والعميل الشبكي.
import 'package:connectivity_plus/connectivity_plus.dart';
//   هاي المكتبة بتسمح لك تعرف نوع الاتصال:
// WiFi
// Mobile Data
// أو No Connection

//مهمته الوحيدة: يعطينا جواب “في إنترنت أو لا”
class ConnectivityService {
  // خدمة لفحص حالة الاتصال بالشبكة.
  // نتحقق من الاتصال حتى نعرض حالة offline بشكل صحيح.
  Future<bool> isOnline() async {
    final List<ConnectivityResult> results = await Connectivity()
        .checkConnectivity();

    //ترجع قائمة من القيم مثل:
    // ConnectivityResult.wifi
    // ConnectivityResult.mobile
    // ConnectivityResult.none

    return results.any((ConnectivityResult result) {  //👉 هل يوجد عنصر واحد على الأقل يحقق الشرط؟any 
      return result != ConnectivityResult.none; //👉 إذا في أي اتصال (مو none) → اعتبر الجهاز Online
    });
  }
}
