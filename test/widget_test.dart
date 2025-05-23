import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:bookstore/main.dart';
import 'package:bookstore/ui/splash/splash_screen.dart';
import 'package:bookstore/utils/setup_dependecies.dart';

GetIt getIt = GetIt.instance;

void main() {
  setUp(() {
    setupDependencies(getIt);
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('Must pump app', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(MyApp), findsOneWidget);
  });

  testWidgets("must show splash", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
