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
    // نعرض هيكل Grid نفسه حتى يستطيع Skeletonizer رسمه بشكل جميل.
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), // نفس الحشو الذي نستخدمه في شبكة التصنيفات الحقيقية، مما يجعل الهيكل العظمي يتطابق تمامًا مع التصميم النهائي.
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( // نحدد عدد الأعمدة والمسافات بين العناصر في الشبكة.
        crossAxisCount: 2, // عدد الأعمدة في الشبكة (2 بطاقة في كل صف).
        mainAxisSpacing: 16, // المسافة الرأسية بين الصفوف.
        crossAxisSpacing: 16, // المسافة الأفقية بين العناصر.
        childAspectRatio: 0.82, // نسبة العرض إلى الارتفاع لكل بطاقة (تجعل البطاقات أطول قليلاً).
      ),
      itemBuilder: (context, index) {
        return CategoryCard(
          category: const CategoryModel(id: '', name: '', thumb: ''),
        );
      },
    );
  }
}
