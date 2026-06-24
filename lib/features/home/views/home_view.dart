// View تمثل واجهة المستخدم المرتبطة مباشرة بالـ Controller.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../app/routes/app_router.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/meal_summary_model.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/network_banner.dart';
import '../../favourites/controllers/favourites_controller.dart';
import '../controllers/category_meals_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/category_card.dart';
import '../widgets/home_skeleton.dart';
import '../widgets/meal_tile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.initialCategoryName, this.initialMealId});

  // اسم التصنيف عند الدخول من مسار فرعي.
  final String? initialCategoryName;

  // رقم الوجبة عند الدخول من مسار فرعي.
  final String? initialMealId;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;
  late final CategoryMealsController _categoryMealsController;
  late final FavouritesController _favouritesController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    _categoryMealsController = Get.find<CategoryMealsController>();
    _favouritesController = Get.find<FavouritesController>();
    _syncRouteState();
  }

  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategoryName != widget.initialCategoryName ||
        oldWidget.initialMealId != widget.initialMealId) {
      _syncRouteState();
    }
  }

  void _syncRouteState() { // هذه الدالة تتأكد من أن حالة الـ Controller متزامنة مع المسار الحالي عند تحميل الشاشة أو تحديثها.
    WidgetsBinding.instance.addPostFrameCallback((_) { // نستخدم addPostFrameCallback لضمان أن هذا الكود يتم تنفيذه بعد بناء الواجهة، مما يمنع أي مشاكل في تحديث الحالة أثناء البناء.
      if (!mounted) {
        return;
      }

      if (widget.initialCategoryName != null && widget.initialCategoryName!.isNotEmpty) {
        controller.selectedCategory.value = widget.initialCategoryName!;
        _categoryMealsController.loadMealsByCategory(widget.initialCategoryName!);
      }

      if (widget.initialMealId != null && widget.initialMealId!.isNotEmpty) {
        controller.selectedMealId.value = widget.initialMealId!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E8),
      body: Obx(
        // Obx يعيد بناء الواجهة عندما تتغير حالة الـ Controller.
        () {
          if (controller.isLoading.value) {
            return const ColoredBox(
              color: Color(0xFFF7F1E8),
              child: Skeletonizer(
                enabled: true,
                child: HomeSkeleton(),
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return AppErrorState(
              message: controller.errorMessage.value,
              onRetry: controller.retryLoadCategories,
            );
          }

          if (controller.categories.isEmpty) {
            return const AppEmptyState(
              message: 'لا توجد تصنيفات لعرضها حاليًا.',
            );
          }

          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xFFF7F1E8),
                  Color(0xFFFFFCF8),
                  Color(0xFFF4EBDD),
                ],
              ),
            ),
            child: RefreshIndicator(
              color: const Color(0xFFF56D70),
              onRefresh: controller.retryLoadCategories,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Obx(
                      () => NetworkBanner(isOnline: controller.isOnline.value),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                      child: _SectionHeader(
                        title: 'Browse categories',
                        subtitle: 'Choose a flavor, then explore what fits the mood.',
                        actionLabel: '${controller.categories.length} available',
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 136,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (BuildContext context, int index) {
                          final CategoryModel category =
                              controller.categories[index];

                          return CategoryCard(
                            category: category,
                            isSelected:
                                controller.selectedCategory.value == category.name,
                            onTap: () {
                              controller.selectedCategory.value = category.name;
                              _categoryMealsController.loadMealsByCategory(category.name);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                      child: Obx(() {
                        final String selectedCategory =
                            controller.selectedCategory.value.trim();
                        final bool hasSelection = selectedCategory.isNotEmpty;

                        return _SectionHeader(
                          title: hasSelection
                              ? selectedCategory
                              : 'Select a category',
                          subtitle: hasSelection
                              ? 'Meals in this category, shown the same way as search results.'
                              : 'Tap a category above to show meals here.',
                          actionLabel: hasSelection
                              ? '${_categoryMealsController.meals.length} meals'
                              : 'Ready',
                        );
                      }),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Obx(() {
                      final String selectedCategory =
                          controller.selectedCategory.value.trim();
                      if (selectedCategory.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      if (_categoryMealsController.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 18),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (_categoryMealsController.errorMessage.value.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                          child: AppErrorState(
                            message: _categoryMealsController.errorMessage.value,
                            onRetry: _categoryMealsController.retry,
                          ),
                        );
                      }

                      if (_categoryMealsController.meals.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 18),
                          child: AppEmptyState(
                            title: 'No meals yet',
                            message: 'Select another category to explore.',
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _categoryMealsController.meals.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (BuildContext context, int index) {
                          final MealSummaryModel meal =
                              _categoryMealsController.meals[index];

                          return Obx(() {
                            final bool isFavourite = _favouritesController.isFavourite(meal.id);

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
                            );
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
  });

  final String title;
  final String subtitle;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
                color: scheme.surface.withOpacity(0.8),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
                  color: scheme.outlineVariant.withOpacity(0.6),
            ),
          ),
          child: Text(
            actionLabel,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
