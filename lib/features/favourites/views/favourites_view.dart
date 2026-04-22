// View تمثل واجهة المستخدم المرتبطة مباشرة بالـ Controller.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_router.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../controllers/favourites_controller.dart';
import '../widgets/favourite_meal_tile.dart';

class FavouritesView extends StatelessWidget {
  const FavouritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final FavouritesController controller = Get.find<FavouritesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favouriteMeals.isEmpty) {
          return const AppEmptyState(
            title: 'No favourites yet',
            message: 'Save meals from Home, Search, or Detail to see them here.',
            icon: Icons.favorite_border_rounded,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          itemCount: controller.favouriteMeals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (BuildContext context, int index) {
            final meal = controller.favouriteMeals[index];

            return FavouriteMealTile(
              meal: meal,
              onTap: () {
                context.go(
                  '${AppRoutes.home}/meal/${Uri.encodeComponent(meal.id)}',
                );
              },
              onRemove: () {
                controller.removeFavourite(meal.id);
              },
            );
          },
        );
      }),
    );
  }
}
