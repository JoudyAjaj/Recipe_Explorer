// Widget قابل لإعادة الاستخدام داخل نفس الميزة.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/models/meal_summary_model.dart';

class FavouriteMealTile extends StatelessWidget {
  const FavouriteMealTile({
    super.key,
    required this.meal,
    this.onTap,
    this.onRemove,
  });

  final MealSummaryModel meal;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 94,
              height: 88,
              child: Hero(
                tag: 'meal-image-${meal.id}',
                child: meal.thumb == null || meal.thumb!.trim().isEmpty
                    ? Container(
                        color: scheme.surfaceContainer,
                        child: Icon(
                          Icons.fastfood_rounded,
                          color: scheme.outline,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: meal.thumb!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: scheme.surfaceContainer,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: scheme.surfaceContainer,
                          child: Icon(
                            Icons.fastfood_rounded,
                            color: scheme.outline,
                          ),
                        ),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      meal.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ID: ${meal.id}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFFF5A30),
              ),
              tooltip: 'Remove from favourites',
            ),
          ],
        ),
      ),
    );
  }
}
