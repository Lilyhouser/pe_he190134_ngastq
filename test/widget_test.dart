import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe_he190134/main.dart';

void main() {
  testWidgets('User Manager initial load test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the title 'User Manager' is displayed in the app bar.
    expect(find.text('User Manager'), findsOneWidget);
  });
}
