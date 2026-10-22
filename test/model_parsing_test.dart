import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/ueh_models.dart';

void main(){
  test('News API parses SDGs and missing image URLs',(){
    final item=NewsArticle.fromJson({'uid':12,'cat_uid':219,'category_name':'Tin UEH',
      'title':'Tin mẫu','short_desc':'Mô tả','sdgs':[4,13],
      'background_img':null,'thumbnail_img':''});
    expect(item.uid,12);
    expect(item.sdgs,[4,13]);
    expect(item.thumbnailImage,isNull);
  });
  test('Pagination has total and offset',(){
    final p=NewsPage.fromJson({'total':125,'limit':20,'offset':20,'items':[]});
    expect(p.total,125);
    expect(p.offset,20);
  });
  test('Menu fields use snake_case',(){
    final menu=MenuNavItem.fromMap({'id':1,'icon_name':'newspaper',
      'menu_name':'Tin tức UEH','menu_url':'','ordering':0});
    expect(menu.name,'Tin tức UEH');
    expect(menu.ordering,0);
  });
}