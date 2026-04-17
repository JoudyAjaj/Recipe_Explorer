// Widget قابل لإعادة الاستخدام داخل نفس الميزة.
import 'package:flutter/material.dart';

class SearchSkeleton extends StatelessWidget {
  const SearchSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
