import 'package:flutter_test/flutter_test.dart';
import 'package:portal8/main.dart';
import 'package:shimmer/main.dart'; // Make sure this path is correct

void main() {
  testWidgets('App launches and shows Enter Portal 8 button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Look for the Enter Portal 8 button
    expect(find.text('🚀 Enter Portal 8'), findsOneWidget);
  });
}
