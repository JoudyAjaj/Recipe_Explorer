// هذا الملف يبني MaterialApp ويصل الثيم مع نظام التنقل Router.
import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'routes/app_router.dart';

class RecipeExplorerApp extends StatelessWidget {
  const RecipeExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم MaterialApp.router لأن التنقل يعتمد على GoRouter.
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Explorer',
      theme: buildAppTheme(),
      // هذا هو تعريف شجرة المسارات بالكامل.
      routerConfig: appRouter,
    );
  }
}
