// Widget قابل لإعادة الاستخدام داخل نفس الميزة.
import 'package:flutter/material.dart';

class CategoryMealsSkeleton extends StatelessWidget {
  const CategoryMealsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated( // نستخدم ListView.separated لعرض قائمة من العناصر الوهمية مع فواصل بينها.
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 8,
      separatorBuilder: (_, __) => const Divider(height: 1), // فاصل بسيط بين العناصر.
      itemBuilder: (BuildContext context, int index) { // نعرض عنصرًا وهميًا لكل وجبة أثناء التحميل.
        return const ListTile(
          leading: CircleAvatar(radius: 22),// دائرة فارغة تمثل الصورة المصغرة للوجبة.
          title: SizedBox(height: 14, child: ColoredBox(color: Colors.white)),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 8),
            child: SizedBox(height: 12, child: ColoredBox(color: Colors.white)),
          ),
        );
      },
    );
  }
}
