// Widget قابل لإعادة الاستخدام داخل نفس الميزة.
import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget { // هذا ال Widget يستخدم لعرض حالة فارغة عندما لا توجد بيانات لعرضها، مثل عندما لا توجد وجبات في تصنيف معين أو عندما لا توجد نتائج بحث.
  const AppEmptyState({
    super.key,
    required this.message,
    this.title = 'لا توجد بيانات',
    this.icon = Icons.inbox_outlined,
  });

  // عنوان الحالة الفارغة.
  final String title;

  // الرسالة التي نشرح بها سبب عدم وجود عناصر.
  final String message;

  // الأيقونة المعروضة في المنتصف.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
