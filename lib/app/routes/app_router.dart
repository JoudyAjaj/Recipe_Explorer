// هذا الملف يعرّف مسارات التطبيق والتنقل بين الشاشات.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/favourites/views/favourites_view.dart';
import '../../features/home/views/home_view.dart';
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

  const AppRoutes._();
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: <RouteBase>[
    // ShellRoute يسمح بثبات الـ Bottom Navigation بين التبويبات.
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ShellScaffold(location: state.matchedLocation, child: child);
      },
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
                final String categoryName = state.pathParameters['categoryName'] ?? '';
                return HomeView(initialCategoryName: categoryName);
              },
            ),
            GoRoute(
              path: 'meal/:mealId',
              builder: (BuildContext context, GoRouterState state) {
                // نقرأ رقم الوجبة من رابط الصفحة.
                final String mealId = state.pathParameters['mealId'] ?? '';
                return HomeView(initialMealId: mealId);
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
