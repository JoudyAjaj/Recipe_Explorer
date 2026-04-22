// View تمثل واجهة المستخدم المرتبطة مباشرة بالـ Controller.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../app/routes/app_router.dart';
import '../../../data/models/category_model.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/network_banner.dart';
import '../controllers/home_controller.dart';
import '../widgets/category_card.dart';
import '../widgets/home_skeleton.dart';

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

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
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
      }

      if (widget.initialMealId != null && widget.initialMealId!.isNotEmpty) {
        controller.selectedMealId.value = widget.initialMealId!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Explorer')),
      body: Obx(
        // Obx يعيد بناء الواجهة عندما تتغير حالة الـ Controller.
        () {
          if (controller.isLoading.value) {
            return const Skeletonizer(
              enabled: true,
              child: HomeSkeleton(),
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

          return RefreshIndicator(
            onRefresh: controller.retryLoadCategories,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Obx(
                    () => NetworkBanner(isOnline: controller.isOnline.value),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Recipe Explorer',
                        //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        //         fontWeight: FontWeight.w700,
                        //       ),
                        // ),
                        // const SizedBox(height: 10),
                        Text(
                          'What would you like to cook?',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      mainAxisSpacing: 16,// المسافة الرأسية بين الصفوف.
                      crossAxisSpacing: 16,// المسافة الأفقية بين العناصر.
                      childAspectRatio: 0.94,// نسبة العرض إلى الارتفاع لكل بطاقة (تجعل البطاقات أقصر قليلاً).
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final CategoryModel category = controller.categories[index];

                        return CategoryCard(
                          category: category,
                          onTap: () {
                            // في الخطوة القادمة سنفتح شاشة قائمة الوجبات الخاصة بهذا التصنيف.
                            context.go(
                              '${AppRoutes.home}/category/${Uri.encodeComponent(category.name)}',
                            );
                          },
                        );
                      },
                      childCount: controller.categories.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
