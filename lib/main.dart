import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/bindings/app_bindings.dart';

void main() {
  // نجهز جميع Controllers العامة مرة واحدة قبل تشغيل التطبيق.
  AppBindings.init();

  // نقطة دخول واجهة التطبيق.
  runApp(const RecipeExplorerApp());
}
