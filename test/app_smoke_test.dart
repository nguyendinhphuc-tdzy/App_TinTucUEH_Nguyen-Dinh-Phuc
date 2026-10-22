import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/widgets/splash_screen.dart';

void main(){
  testWidgets('App shows splash screen', (tester)async{
    await tester.pumpWidget(const MyApp());
    expect(find.byType(SplashScreen),findsOneWidget);
  });
}