// Widget قابل لإعادة الاستخدام داخل نفس الميزة.
import 'package:flutter/material.dart';

class IngredientChip extends StatelessWidget { // هذا ال Widget يستخدم لعرض مكون بسيط يمثل مكون من مكونات الوجبة، مثل "بصل" أو "ثوم" أو "طماطم". يتم عرضه في شكل Chip مع أيقونة صغيرة.
  const IngredientChip({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Chip(
      avatar: Icon(
        Icons.restaurant_menu_rounded,
        size: 18,
        color: scheme.primary,
      ),
      label: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.68),
      side: BorderSide(color: scheme.outlineVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );
  }
}
