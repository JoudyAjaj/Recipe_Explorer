import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_explorer_app/app/app.dart';

void main() {
  testWidgets('App boots to home tab', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeExplorerApp());
    await tester.pumpAndSettle();

    expect(find.text('Recipe Explorer'), findsOneWidget);
    expect(find.text('Home tab ready'), findsOneWidget);
  });
}
