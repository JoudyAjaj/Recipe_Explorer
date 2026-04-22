// Widget قابل لإعادة الاستخدام داخل نفس الميزة.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/models/meal_summary_model.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.meal,
    required this.isFavourite,
    this.onTap,
    this.onToggleFavourite,
  });

  final MealSummaryModel meal;
  final bool isFavourite;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavourite;

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
                child: meal.thumb == null
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
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: onToggleFavourite,
                    icon: Icon(
                      isFavourite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavourite
                          ? const Color(0xFFFF5A30)
                          : scheme.onSurfaceVariant,
                    ),
                    tooltip: isFavourite
                        ? 'Remove from favourites'
                        : 'Add to favourites',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
