// هذا الملف يعرّف مسارات التطبيق والتنقل بين الشاشات.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/favourites/views/favourites_view.dart';
import '../../features/home/screens/category_meals_screen.dart';
import '../../features/home/views/home_view.dart';
import '../../features/meal_detail/screens/meal_detail_screen.dart';
import '../../features/search/views/search_view.dart';
import '../../features/surprise/views/surprise_view.dart';
import '../widgets/shell_scaffold.dart';

class AppRoutes {
  // مسارات التبويبات الرئيسية.
  static const String home = '/home';
  static const String search = '/search';
  static const String surprise = '/surprise';
  static const String favourites = '/favourites';

  // مسارات داخل Home (Nested Navigation).
  static const String categoryMeals = 'category/:categoryName';
  static const String mealDetail = 'meal/:mealId';

  //مهم جداً:
  // :categoryName → متغير داخل الرابط
  // :mealId → متغير
  // مثال:
  // /home/category/Seafood
  // /home/meal/123
  //   //
  const AppRoutes._(); //
}

final GoRouter appRouter = GoRouter( //
  // نحدد المسار الابتدائي عند تشغيل التطبيق.
  initialLocation:
      AppRoutes.home, // نستخدم ShellRoute لاحتواء التبويبات الرئيسية.
  routes: <RouteBase>[
    // ShellRoute يسمح بثبات الـ Bottom Navigation بين التبويبات.
    ShellRoute( 
      //لإطار الثابت (فيه Bottom Nav مثلاً) بيتغير بس محتوى الصفحة
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ShellScaffold(location: state.matchedLocation, child: child);
      },

      //ShellScaffold (ثابت)
      //  ├── HomeView
      //  ├── SearchView
      //  ├── FavouritesView
      //تشبيه: ShellRoute هو ال
      //     بيت (ShellRoute)
      //     غرف (Routes)
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.home,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeView();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'category/:categoryName',
              builder: (BuildContext context, GoRouterState state) {
                // نقرأ اسم التصنيف من رابط الصفحة.
                final String categoryName =
                    state.pathParameters['categoryName'] ?? '';
                return CategoryMealsScreen(
                  categoryName: categoryName,
                ); // نمرر اسم التصنيف إلى شاشة عرض وجبات التصنيف.
              },
            ),
            GoRoute(
              path: 'meal/:mealId',
              builder: (BuildContext context, GoRouterState state) {
                final String mealId = state.pathParameters['mealId'] ?? '';
                return MealDetailScreen(mealId: mealId);
              },
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.search,
          builder: (BuildContext context, GoRouterState state) {
            return const SearchView();
          },
        ),
        GoRoute(
          path: AppRoutes.surprise,
          builder: (BuildContext context, GoRouterState state) {
            return const SurpriseView();
          },
        ),
        GoRoute(
          path: AppRoutes.favourites,
          builder: (BuildContext context, GoRouterState state) {
            return const FavouritesView();
          },
        ),
      ],
    ),
  ],
);
// شو هو GoRoute؟

// GoRoute هو:
// 👉 تعريف "طريق" (Route) لصفحة معينة في التطبيق

// يعني بكل بساطة:

// إذا المستخدم راح لهالرابط → افتح هاي الصفحة
  //الفرق بسرعة
// الأمر	شو يعمل
// go	يبدل الصفحة
// push	يضيف صفحة فوق