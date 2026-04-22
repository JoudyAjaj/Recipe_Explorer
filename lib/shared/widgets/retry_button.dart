// Widget قابل لإعادة الاستخدام داخل نفس الميزة.
import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget { // هذا ال Widget يستخدم لعرض زر إعادة المحاولة في حالة حدوث خطأ أثناء جلب البيانات من API، مثل عندما تفشل عملية تحميل وجبات تصنيف معين أو عندما تفشل عملية البحث.
  const RetryButton({super.key, required this.onPressed, this.label = 'إعادة المحاولة'});

  // الدالة التي تُنفذ عند الضغط على الزر.
  final VoidCallback onPressed;

  // نص الزر، ويمكن تغييره حسب المكان.
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon( // نستخدم FilledButton مع أيقونة لتكون واضحة وجذابة.
      onPressed: onPressed,
      icon: const Icon(Icons.refresh_rounded),
      label: Text(label),
    );
  }
}
