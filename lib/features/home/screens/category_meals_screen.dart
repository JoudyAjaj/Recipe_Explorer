// Screen تعرض وجبات تصنيف محدد مع جميع حالات الواجهة.
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../app/routes/app_router.dart';
import '../../../features/favourites/controllers/favourites_controller.dart';
import '../../../data/models/meal_summary_model.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../controllers/category_meals_controller.dart';
import '../widgets/category_meals_skeleton.dart';
import '../widgets/meal_tile.dart';

class CategoryMealsScreen extends StatefulWidget {
  const CategoryMealsScreen({super.key, required this.categoryName});

  final String categoryName;

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  late final CategoryMealsController _controller;
  late final FavouritesController _favouritesController;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CategoryMealsController>();
    _favouritesController = Get.find<FavouritesController>();
    _controller.loadMealsByCategory(widget.categoryName);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Colors.black;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 2,
        iconTheme: const IconThemeData(color: accentColor),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: accentColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Skeletonizer(
            // نستخدم Skeletonizer لعرض هيكل عظمي أثناء التحميل.
            enabled:
                true, // نفعّل الـ Skeletonizer لعرض الهيكل العظمي أثناء التحميل.
            child: CategoryMealsSkeleton(),
          );
        }

        if (_controller.errorMessage.value.isNotEmpty) {
          // إذا كانت هناك رسالة خطأ، نعرض شاشة الخطأ مع خيار إعادة المحاولة.
          return AppErrorState(
            message: _controller.errorMessage.value,
            onRetry: _controller.retry,
          );
        }

        if (_controller.meals.isEmpty) {
          // إذا لم يتم العثور على وجبات ضمن هذا التصنيف، نعرض شاشة فارغة مع رسالة مناسبة.
          return const AppEmptyState(
            title: 'لا توجد وجبات',
            message: 'لم يتم العثور على وجبات ضمن هذا التصنيف.',
          );
        }

        final List<MealSummaryModel> filteredMeals = _controller.meals.where((
          MealSummaryModel meal,
        ) {
          if (_query.trim().isEmpty) {
            return true;
          }

          final String q = _query.toLowerCase().trim();
          return meal.name.toLowerCase().contains(q) ||
              meal.id.toLowerCase().contains(q);
        }).toList();

        if (filteredMeals.isEmpty) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (String value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search meals in this category...',
                    prefixIcon: Icon(Icons.search_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const Expanded(
                child: AppEmptyState(
                  title: 'No matching meals',
                  message: 'Try another keyword.',
                ),
              ),
            ],
          );
        }

        return RefreshIndicator(
          // نستخدم RefreshIndicator لتمكين سحب الشاشة لتحديث البيانات.
          onRefresh: _controller.retry,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10),
            itemCount: filteredMeals.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (String value) {
                      setState(() {
                        _query = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search meals in this category...',
                      prefixIcon: Icon(Icons.search_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              }

              final MealSummaryModel meal = filteredMeals[index - 1];

              return Obx(() {
                final bool isFavourite = _favouritesController.isFavourite(
                  meal.id,
                );

                return MealTile(
                      meal: meal,
                      isFavourite: isFavourite,
                      onToggleFavourite: () {
                        _favouritesController.toggleFavouriteMeal(meal);
                      },
                      onTap: () {
                        context.go(
                          '${AppRoutes.home}/meal/${Uri.encodeComponent(meal.id)}',
                        );
                      },
                    )
                    .animate(delay: (35 * (index - 1)).ms)
                    .fadeIn(duration: 260.ms)
                    .slideY(begin: 0.08, end: 0, duration: 260.ms);
              });
            },
          ),
        );
      }),
    );
  }
}
