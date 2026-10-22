import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/widgets/home_screen.dart';
import 'package:flutter_application_1/widgets/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ứng dụng hiển thị splash screen khi khởi động', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
