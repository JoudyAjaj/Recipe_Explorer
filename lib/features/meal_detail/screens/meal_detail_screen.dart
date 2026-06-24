// Screen تعرض تفاصيل الوجبة مع حالات تحميل وخطأ ونجاح.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/models/meal_detail_model.dart';
import '../../../data/models/meal_summary_model.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../favourites/controllers/favourites_controller.dart';
import '../controllers/meal_detail_controller.dart';

class MealDetailScreen extends StatefulWidget {
  const MealDetailScreen({super.key, required this.mealId});

  final String mealId;

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late final MealDetailController _controller;
  late final FavouritesController _favouritesController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MealDetailController>();
    _favouritesController = Get.find<FavouritesController>();
    _controller.loadMealDetail(widget.mealId);
  }

  @override
  void didUpdateWidget(covariant MealDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mealId != widget.mealId) {
      _controller.loadMealDetail(widget.mealId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double imageDiameter = (MediaQuery.sizeOf(context).width * 0.42)
        .clamp(150.0, 200.0);

    return Scaffold(
      backgroundColor: const Color(0xFFE9EAEE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Material(
              color: Colors.white,
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_controller.errorMessage.value.isNotEmpty) {
                  return AppErrorState(
                    title: 'تعذر تحميل التفاصيل',
                    message: _controller.errorMessage.value,
                    onRetry: _controller.retry,
                  );
                }

                final MealDetailModel? meal = _controller.meal.value;
                if (meal == null) {
                  return const AppEmptyState(
                    title: 'لا توجد تفاصيل',
                    message: 'لم نستطع إيجاد معلومات لهذه الوجبة.',
                  );
                }

                return Column(
                  children: <Widget>[
                    Expanded(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            expandedHeight: imageDiameter + 54,
                            pinned: true,
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.transparent,
                            leading: _RoundIconButton(
                              icon: Icons.chevron_left_rounded,
                              onPressed: () => Navigator.of(context).maybePop(),
                            ),
                            actions: <Widget>[
                              Obx(() {
                                final bool isFavourite = _favouritesController
                                    .isFavourite(meal.id);
                                return _RoundIconButton(
                                  icon: isFavourite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  iconColor: isFavourite
                                      ? const Color(0xFFFF5A30)
                                      : Colors.white,
                                  onPressed: () {
                                    _favouritesController.toggleFavouriteMeal(
                                      MealSummaryModel(
                                        id: meal.id,
                                        name: meal.name,
                                        thumb: meal.image,
                                      ),
                                    );
                                  },
                                );
                              }),
                            ],
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Color(0xFFF7F8FB),
                                      Color(0xFFFFFFFF),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Hero(
                                    tag: 'meal-image-${meal.id}',
                                    child: Container(
                                      width: imageDiameter,
                                      height: imageDiameter,
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.10,
                                            ),
                                            blurRadius: 24,
                                            offset: const Offset(0, 12),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Material(
                                          color: const Color(0xFFF4F4F4),
                                          child: meal.image == null
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.fastfood_rounded,
                                                    size: 56,
                                                  ),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: meal.image!,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2.2,
                                                            ),
                                                      ),
                                                  errorWidget:
                                                      (
                                                        context,
                                                        url,
                                                        error,
                                                      ) => const Center(
                                                        child: Icon(
                                                          Icons
                                                              .fastfood_rounded,
                                                          size: 56,
                                                        ),
                                                      ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                14,
                                18,
                                18,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    meal.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${meal.area ?? 'Unknown'}  •  ${meal.category ?? 'Unknown'}',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFF666666),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  const Divider(height: 1),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: <Widget>[
                                      const _SectionBadge(title: 'Ingredients'),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          color: const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  _buildIngredientRows(meal.ingredients),
                                  const SizedBox(height: 18),
                                  const Divider(height: 1),
                                  const SizedBox(height: 16),
                                  const _SectionBadge(title: 'Instructions'),
                                  const SizedBox(height: 14),
                                  ..._buildInstructionItems(meal.instructions),
                                  const SizedBox(height: 14),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final String message = _buildShareText(meal);
                              SharePlus.instance.share(
                                ShareParams(text: message),
                              );
                            },
                            icon: const Icon(Icons.ios_share_rounded, size: 22),
                            label: const Text(
                              'Share Recipe',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF5A30),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

String _buildShareText(MealDetailModel meal) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln(meal.name);

  if ((meal.category ?? '').trim().isNotEmpty ||
      (meal.area ?? '').trim().isNotEmpty) {
    buffer.writeln(
      'Category: ${meal.category ?? 'Unknown'} | Cuisine: ${meal.area ?? 'Unknown'}',
    );
  }

  if ((meal.instructions ?? '').trim().isNotEmpty) {
    final String snippet = meal.instructions!.trim();
    final String shortSnippet = snippet.length > 220
        ? '${snippet.substring(0, 220)}...'
        : snippet;
    buffer.writeln();
    buffer.writeln(shortSnippet);
  }

  buffer.writeln();
  buffer.writeln('From Recipe Explorer');
  return buffer.toString();
}

Widget _buildIngredientRows(List<String> ingredients) {
  if (ingredients.isEmpty) {
    return const Text(
      'Ingredients are unavailable for this meal.',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF303030),
      ),
    );
  }

  final List<String> visibleIngredients = ingredients.take(8).toList();

  return SizedBox(
    height: 92,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: visibleIngredients.length,
      separatorBuilder: (context, index) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final String ingredient = visibleIngredients[index];
        final _IngredientVisual visual = _ingredientVisualFor(ingredient);

        return Container(
          width: 178,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: visual.background,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: visual.border, width: 1),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: visual.iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(visual.icon, color: visual.iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ingredient,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F3138),
                    height: 1.15,
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

_IngredientVisual _ingredientVisualFor(String ingredient) {
  final String lower = ingredient.toLowerCase();

  if (lower.contains('salt')) {
    return const _IngredientVisual(
      icon: Icons.soup_kitchen_rounded,
      iconColor: Color(0xFF4E8FBF),
      iconBackground: Color(0xFFDDEDF8),
      background: Color(0xFFF8FBFE),
      border: Color(0xFFE3EEF8),
    );
  }
  if (lower.contains('sugar')) {
    return const _IngredientVisual(
      icon: Icons.cake_rounded,
      iconColor: Color(0xFFE38A2B),
      iconBackground: Color(0xFFFFE7CC),
      background: Color(0xFFFFFBF5),
      border: Color(0xFFFFE8CE),
    );
  }
  if (lower.contains('flour')) {
    return const _IngredientVisual(
      icon: Icons.bakery_dining_rounded,
      iconColor: Color(0xFF7D5B3E),
      iconBackground: Color(0xFFF2E5D9),
      background: Color(0xFFFCF8F4),
      border: Color(0xFFF0E2D6),
    );
  }
  if (lower.contains('water')) {
    return const _IngredientVisual(
      icon: Icons.water_drop_rounded,
      iconColor: Color(0xFF2F9AD6),
      iconBackground: Color(0xFFDDF3FF),
      background: Color(0xFFF8FDFF),
      border: Color(0xFFDDEFF9),
    );
  }
  if (lower.contains('oil')) {
    return const _IngredientVisual(
      icon: Icons.opacity_rounded,
      iconColor: Color(0xFF52A35B),
      iconBackground: Color(0xFFE2F5E3),
      background: Color(0xFFF8FCF8),
      border: Color(0xFFE1F1E2),
    );
  }
  if (lower.contains('pepper')) {
    return const _IngredientVisual(
      icon: Icons.local_fire_department_rounded,
      iconColor: Color(0xFFE45C3C),
      iconBackground: Color(0xFFFFE1D8),
      background: Color(0xFFFFFAF8),
      border: Color(0xFFFFE2DA),
    );
  }
  if (lower.contains('onion')) {
    return const _IngredientVisual(
      icon: Icons.ramen_dining_rounded,
      iconColor: Color(0xFFB16A3C),
      iconBackground: Color(0xFFF4E0D0),
      background: Color(0xFFFEF9F5),
      border: Color(0xFFF2E2D6),
    );
  }
  if (lower.contains('garlic')) {
    return const _IngredientVisual(
      icon: Icons.kitchen_rounded,
      iconColor: Color(0xFF8E6B3C),
      iconBackground: Color(0xFFF0E3CC),
      background: Color(0xFFFCF9F1),
      border: Color(0xFFF0E4C8),
    );
  }

  return const _IngredientVisual(
    icon: Icons.restaurant_menu_rounded,
    iconColor: Color(0xFFFF5A30),
    iconBackground: Color(0xFFFFE4DB),
    background: Color(0xFFFFFAF8),
    border: Color(0xFFFBE0D7),
  );
}

class _IngredientVisual {
  const _IngredientVisual({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.background,
    required this.border,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color background;
  final Color border;
}

List<Widget> _buildInstructionItems(String? instructions) {
  final List<String> steps = _extractSteps(instructions);
  if (steps.isEmpty) {
    return const <Widget>[
      Text(
        '• Instructions are unavailable for this meal.',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF303030),
        ),
      ),
    ];
  }

  return steps.take(4).toList().asMap().entries.map((entry) {
    final int index = entry.key + 1;
    final String step = entry.value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        '•  $index. $step',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2F2F2F),
        ),
      ),
    );
  }).toList();
}

List<String> _extractSteps(String? instructions) {
  final String text = (instructions ?? '').trim();
  if (text.isEmpty) {
    return <String>[];
  }

  final List<String> lines = text
      .split(RegExp(r'\r?\n'))
      .map((String line) => line.trim())
      .where((String line) => line.isNotEmpty)
      .toList();

  if (lines.length > 1) {
    return lines;
  }

  return text
      .split(RegExp(r'\.\s+'))
      .map((String sentence) => sentence.trim())
      .where((String sentence) => sentence.isNotEmpty)
      .toList();
}

class _SectionBadge extends StatelessWidget {
  const _SectionBadge({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFF5A30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onPressed,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.black.withValues(alpha: 0.30),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(icon, color: iconColor, size: 22),
          ),
        ),
      ),
    );
  }
}
