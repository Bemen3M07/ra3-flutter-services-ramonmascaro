import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hello_world/main.dart';
import 'package:flutter_hello_world/providers/car_provider.dart';

void main() {
  testWidgets('Cars list screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CarProvider(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Car Data API'), findsOneWidget);
  });
}
