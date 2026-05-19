import 'package:flutter_test/flutter_test.dart';
import 'package:msdv_system/main.dart';

void main() {
  testWidgets('Login screen renders SIGN IN button', (WidgetTester tester) async {
    await tester.pumpWidget(const MsdvApp());

    expect(find.text('SIGN IN'), findsOneWidget);
    expect(find.text('USERNAME'), findsOneWidget);
    expect(find.text('PASSWORD'), findsOneWidget);
  });
}
