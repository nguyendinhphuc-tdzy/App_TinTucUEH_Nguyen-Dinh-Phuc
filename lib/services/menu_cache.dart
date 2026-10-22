import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../models/ueh_models.dart';
import 'ueh_api.dart';

class MenuCache {
  MenuCache._();
  static final MenuCache instance=MenuCache._();
  Database? _database;
  Future<Database> get database async {
    if (_database!=null) return _database!;
    final root=await getDatabasesPath();
    _database=await openDatabase(p.join(root,'ueh_student_cache.db'),version:1,
      onCreate:(db,_)async {
        await db.execute('CREATE TABLE menu_items (id INTEGER PRIMARY KEY, ordering INTEGER NOT NULL, payload TEXT NOT NULL)');
      });
    return _database!;
  }
  Future<List<MenuNavItem>> read() async {
    final db=await database;
    final rows=await db.query('menu_items',orderBy:'ordering ASC');
    return rows.map((r)=>MenuNavItem.fromMap(jsonDecode(r['payload']! as String) as Map<String,dynamic>)).toList();
  }
  Future<void> save(List<MenuNavItem> items) async {
    final db=await database;
    await db.transaction((txn)async {
      await txn.delete('menu_items');
      for (final item in items){await txn.insert('menu_items',{
        'id':item.id,'ordering':item.ordering,'payload':item.encode()});}
    });
  }
  /// Hiển thị cache ngay khi mở; luôn thử đồng bộ từ API sau đó.
  Future<List<MenuNavItem>> refresh() async {
    final items=await UehApi.instance.getMenu();
    await save(items);
    return items;
  }
}