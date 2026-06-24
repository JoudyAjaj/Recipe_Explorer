// Widget قابل لإعادة الاستخدام داخل نفس الميزة.
import 'package:flutter/material.dart';

import 'retry_button.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.title = 'Something went wrong',
  });

  // عنوان مختصر يشرح نوع الحالة.
  final String title;

  // رسالة الخطأ القادمة من الـ Controller أو الـ Service.
  final String message;

  // إعادة المحاولة عند الضغط على الزر.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
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
            const SizedBox(height: 20),
            RetryButton(onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
