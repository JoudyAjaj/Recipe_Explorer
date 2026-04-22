// هذا Widget عام على مستوى التطبيق (Shell/Navigation/Layout).
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_router.dart';

class ShellScaffold extends StatelessWidget {
  const ShellScaffold({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  int get _currentIndex {
    // نحدد التبويب الحالي بناءً على المسار الحالي.
    if (location.startsWith(AppRoutes.search)) return 1;
    if (location.startsWith(AppRoutes.surprise)) return 2;
    if (location.startsWith(AppRoutes.favourites)) return 3;
    return 0;
  }

  void _goBranch(BuildContext context, int index) { // هاي الدالة بتتصل لما المستخدم يختار تبويب جديد من الـ NavigationBar، وبتنقل للمسار المناسب.
    // كل عنصر في الـ NavigationBar يقابله مسار واضح.
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        return;
      case 1:
        context.go(AppRoutes.search);
        return;
      case 2:
        context.go(AppRoutes.surprise);
        return;
      case 3:
        context.go(AppRoutes.favourites);
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // child هنا هو محتوى الشاشة النشط داخل الـ ShellRoute.
      body: child,
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) => _goBranch(context, index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search_rounded), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_rounded), label: 'Surprise'),
          NavigationDestination(icon: Icon(Icons.favorite_border_rounded), label: 'Favourites'),
        ],
      ),
    );
  }
}
