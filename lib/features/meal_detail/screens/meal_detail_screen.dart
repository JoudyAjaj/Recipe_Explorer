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

  void _openImagePreview(MealDetailModel meal) {
    final String? imageUrl = meal.image;
    if (imageUrl == null || imageUrl.isEmpty) {
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => _FullScreenMealImage(
          tag: 'meal-image-${meal.id}',
          imageUrl: imageUrl,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

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
    final double imageHeight =
        (MediaQuery.sizeOf(context).width * 0.45).clamp(150.0, 190.0);

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
                            expandedHeight: imageHeight,
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
                              background: Hero(
                                tag: 'meal-image-${meal.id}',
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: meal.image == null
                                        ? null
                                        : () => _openImagePreview(meal),
                                    child: meal.image == null
                                        ? Container(
                                            color: const Color(0xFFF4F4F4),
                                            child: const Icon(
                                              Icons.fastfood_rounded,
                                              size: 56,
                                            ),
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: meal.image!,
                                          fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                Container(
                                                  color: const Color(0xFFF4F4F4),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color: const Color(
                                                        0xFFF4F4F4,
                                                      ),
                                                      child: const Icon(
                                                        Icons.fastfood_rounded,
                                                        size: 56,
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
                                  const _SectionBadge(title: 'Ingredients'),
                                  const SizedBox(height: 14),
                                  ..._buildIngredientItems(meal.ingredients),
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

List<Widget> _buildIngredientItems(List<String> ingredients) {
  if (ingredients.isEmpty) {
    return const <Widget>[
      Text(
        '• Ingredients are unavailable for this meal.',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF303030),
        ),
      ),
    ];
  }

  return ingredients.take(8).map((String ingredient) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '•  $ingredient',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2F2F2F),
        ),
      ),
    );
  }).toList();
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

class _FullScreenMealImage extends StatelessWidget {
  const _FullScreenMealImage({required this.tag, required this.imageUrl});

  static const Color _accentColor = Color(0xFFFF5A30);

  final String tag;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Hero(
                tag: tag,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF5E5E5E),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: Color(0xFF8A8A8A),
                      size: 42,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return _accentColor;
                  }
                  return Colors.white;
                }),
                backgroundColor: WidgetStateProperty.all(
                  Colors.black.withValues(alpha: 0.35),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
