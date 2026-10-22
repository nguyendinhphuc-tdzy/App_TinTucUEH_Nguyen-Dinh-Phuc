import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/ueh_models.dart';
import 'package:flutter_application_1/widgets/home_screen.dart';
import 'package:flutter_application_1/widgets/news_screens.dart';

void main() {
  testWidgets('Home starts API loading and refreshes without setState Future errors',
      (tester) async {
    var calls = 0;
    Future<List<NewsArticle>> loadFeatured() async {
      calls++;
      return <NewsArticle>[];
    }

    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(loadFeatured: loadFeatured),
    ));
    await tester.pump();

    expect(find.text('API chưa có tin nổi bật.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Làm mới'));
    await tester.pump();

    expect(calls, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('News detail loads HTML without setState Future errors',
      (tester) async {
    final item = NewsArticle.fromJson({
      'uid': 7,
      'cat_uid': 219,
      'category_name': 'Tin UEH',
      'title': 'Tin kiểm thử',
      'short_desc': 'Mô tả',
      'sdgs': <int>[],
      'is_featured': false,
      'content': '<p>Nội dung kiểm thử</p>',
    });

    await tester.pumpWidget(MaterialApp(
      home: NewsDetailScreen(
        uid: 7,
        loadDetail: (uid) async {
          expect(uid, 7);
          return item;
        },
      ),
    ));
    await tester.pump();

    expect(find.text('Tin kiểm thử'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
