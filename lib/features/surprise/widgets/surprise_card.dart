// Widget قابل لإعادة الاستخدام داخل نفس الميزة.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/models/meal_detail_model.dart';

class SurpriseCard extends StatelessWidget {
  const SurpriseCard({
    super.key,
    required this.meal,
    required this.isLoading,
    required this.isFavourite,
    this.onTap,
    this.onToggleFavourite, // تم إضافة هذا المتغير لتمرير وظيفة تبديل المفضلة من الواجهة الرئيسية.
  });

  final MealDetailModel? meal;
  final bool isLoading;
  final bool isFavourite;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavourite; // وظيفة لتبديل حالة المفضلة، يتم تمريرها من الواجهة الرئيسية.

  @override
  Widget build(BuildContext context) {
    final bool hasMeal = meal != null;
    final Widget content = hasMeal
        ? _MealContent(
            meal: meal!, // تم تمرير بيانات الوجبة إلى محتوى الوجبة.
            isFavourite: isFavourite, // تم تمرير حالة المفضلة إلى محتوى الوجبة لعرض الأيقونة المناسبة.
            onToggleFavourite: onToggleFavourite, // تم تمرير وظيفة تبديل المفضلة إلى محتوى الوجبة لتمكين المستخدم من إضافة أو إزالة الوجبة من المفضلة مباشرة من البطاقة.
          )
        : _EmptyContent(isLoading: isLoading);

    return GestureDetector(
      onTap: hasMeal ? onTap : null,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: SizedBox(
            key: ValueKey<String>(hasMeal ? meal!.id : 'placeholder'),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _MealContent extends StatelessWidget {
  const _MealContent({
    required this.meal,
    required this.isFavourite,
    this.onToggleFavourite,
  });

  final MealDetailModel meal;
  final bool isFavourite;
  final VoidCallback? onToggleFavourite;

  @override
  Widget build(BuildContext context) {
    final String category = (meal.category ?? '').trim();
    final String area = (meal.area ?? '').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                meal.image == null
                    ? Container(
                        color: const Color(0xFFF1F2F4),
                        child: const Icon(
                          Icons.restaurant_rounded,
                          size: 62,
                          color: Color(0xFFB6BBC5),
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: meal.image!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: const Color(0xFFF1F2F4)),
                        errorWidget: (_, __, ___) => Container(
                          color: const Color(0xFFF1F2F4),
                          child: const Icon(
                            Icons.broken_image_outlined,
                            size: 42,
                            color: Color(0xFFB6BBC5),
                          ),
                        ),
                      ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onToggleFavourite,
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          isFavourite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 22,
                          color: isFavourite
                              ? const Color(0xFFFF5A30)
                              : const Color(0xFFB0B7C2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                meal.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2A3140),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: <Widget>[
                  if (category.isNotEmpty)
                    _MetaChip(
                      label: category,
                      background: const Color(0xFFFFE2E3),
                      foreground: const Color(0xFFEA5B64),
                    ),
                  if (area.isNotEmpty)
                    _MetaChip(
                      label: area,
                      background: const Color(0xFFE9ECF1),
                      foreground: const Color(0xFF6F7886),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          isLoading
              ? const SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              : const Icon(
                  Icons.lunch_dining_outlined,
                  size: 60,
                  color: Color(0xFFD0D5DE),
                ),
          const SizedBox(height: 12),
          Text(
            isLoading ? 'Finding your next meal...' : 'Tap Try Another',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF9EA6B3),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
