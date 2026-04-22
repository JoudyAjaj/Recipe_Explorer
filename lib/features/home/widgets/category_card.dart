// Widget قابل لإعادة الاستخدام داخل نفس الميزة.
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../data/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, this.onTap});

  // بيانات التصنيف الذي نريد عرضه.
  final CategoryModel category;

  // نستخدمها عند الضغط على البطاقة.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Card(
          elevation: 1.2,
          shadowColor: Colors.black12,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder( // نستخدم شكل مستطيل بزاوية دائرية لبطاقة التصنيف.
            borderRadius: BorderRadius.circular(22),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.white,
                  child: category.thumb == null || category.thumb!.isEmpty
                      ? const Center(
                          child: Icon(
                            Icons.restaurant_rounded,
                            size: 40,
                            color: Color(0xFF8A8A8A),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: category.thumb!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                        ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
