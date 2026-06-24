// View تمثل واجهة المستخدم المرتبطة مباشرة بالـ Controller.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/routes/app_router.dart';
import '../../../data/models/meal_detail_model.dart';
import '../../../data/models/meal_summary_model.dart';
import '../../favourites/controllers/favourites_controller.dart';
import '../controllers/surprise_controller.dart';
import '../widgets/surprise_card.dart';

class SurpriseView extends StatefulWidget {
  const SurpriseView({super.key});

  @override
  State<SurpriseView> createState() => _SurpriseViewState();
}

class _SurpriseViewState extends State<SurpriseView>
    with SingleTickerProviderStateMixin {
  late final SurpriseController _controller;
  late final FavouritesController _favouritesController;
  late final AnimationController _revealController;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SurpriseController>();
    _favouritesController = Get.find<FavouritesController>();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = CurvedAnimation(
      parent: _revealController,
      curve: Curves.elasticOut,
    );
    _rotation = Tween<double>(begin: -0.08, end: 0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeOutCubic),
    );
    _fade = CurvedAnimation(parent: _revealController, curve: Curves.easeIn);

    ever(_controller.randomMeal, (_) {
      if (_controller.randomMeal.value != null) {
        _revealController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? titleStyle = GoogleFonts.poppins(
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 26,
        height: 1.12,
        letterSpacing: -0.25,
        color: const Color(0xFF1F283B),
      ),
    );
    final TextStyle? subtitleStyle = GoogleFonts.poppins(
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
        fontSize: 13,
        height: 1.25,
        letterSpacing: -0.05,
      ),
    );
    final TextStyle? ctaStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: 18,
      height: 1,
      color: Colors.white,
    );

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
          child: Obx(() {
            final MealDetailModel? meal = _controller.randomMeal.value;
            final String error = _controller.errorMessage.value;
            final String buttonLabel = meal == null
                ? 'Surprise Me!'
                : 'Try Another';

            return Column(
              children: <Widget>[
                Text(
                  "What's for dinner?",
                  textAlign: TextAlign.center,
                  style: titleStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  'Let fate decide your next delicious meal!',
                  textAlign: TextAlign.center,
                  style: subtitleStyle,
                ),
                const SizedBox(height: 36),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: FadeTransition(
                      opacity: _fade,
                      child: ScaleTransition(
                        scale: _scale,
                        child: AnimatedBuilder(
                          animation: _rotation,
                          builder: (_, Widget? child) {
                            return Transform.rotate(
                              angle: _rotation.value,
                              child: child,
                            );
                          },
                          child: SurpriseCard(
                            meal: meal,
                            isLoading: _controller.isLoading.value,
                            isFavourite: meal == null
                                ? false
                                : _favouritesController.isFavourite(meal.id),
                            onTap: meal == null
                                ? null
                                : () {
                                    context.go(
                                      '${AppRoutes.home}/meal/${meal.id}',
                                    );
                                  },
                            onToggleFavourite: meal == null
                                ? null
                                : () {
                                    _favouritesController.toggleFavouriteMeal(
                                      MealSummaryModel(
                                        id: meal.id,
                                        name: meal.name,
                                        thumb: meal.image,
                                      ),
                                    );
                                  },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (error.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                SizedBox(
                  width: 224,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _controller.retry,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.shuffle_rounded, size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            buttonLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ctaStyle,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF56D70),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: const Color(0x30F56D70),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
