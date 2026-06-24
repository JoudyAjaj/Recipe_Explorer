// Widget قابل لإعادة الاستخدام داخل نفس الميزة.
import 'package:flutter/material.dart';

import '../../../data/models/category_model.dart';
import 'category_card.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key, this.itemCount = 6});

  // عدد البطاقات الوهمية التي نعرضها أثناء التحميل.
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    // نعرض شريط أفقي مشابه للتصميم النهائي أثناء التحميل.
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(width: 16),
      itemBuilder: (context, index) {
        return CategoryCard(
          category: const CategoryModel(id: '', name: '', thumb: ''),
        );
      },
    );
  }
}
