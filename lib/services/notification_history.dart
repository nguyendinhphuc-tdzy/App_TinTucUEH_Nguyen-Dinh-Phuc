import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

/// One FCM delivery, persisted locally. No credentials or FCM tokens are stored.
class UehNotification {
  const UehNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.data = const {},
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final Map<String, dynamic> data;
  final bool isRead;

  factory UehNotification.fromMap(Map<String, Object?> row) {
    Map<String, dynamic> payload = {};
    try {
      final decoded = jsonDecode((row['payload'] ?? '{}') as String);
      if (decoded is Map<String, dynamic>) payload = decoded;
    } catch (_) {
      // Old or malformed payloads should not prevent loading history.
    }
    return UehNotification(
      id: (row['id'] ?? '').toString(),
      title: (row['title'] ?? '').toString(),
      body: (row['body'] ?? '').toString(),
      receivedAt: DateTime.fromMillisecondsSinceEpoch(
        (row['received_at'] as num).toInt(),
      ),
      data: payload,
      isRead: row['is_read'] == 1,
    );
  }
}

class NotificationHistory {
  NotificationHistory._();
  static final NotificationHistory instance = NotificationHistory._();

  final ValueNotifier<int> revision = ValueNotifier<int>(0);
  Future<Database>? _opening;

  Future<Database> get database => _opening ??= _open();

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    return openDatabase(
      path.join(dir, 'ueh_notifications.db'),
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE notifications (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            received_at INTEGER NOT NULL,
            payload TEXT NOT NULL,
            is_read INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<void> save(UehNotification notification) async {
    final db = await database;
    await db.insert(
      'notifications',
      {
        'id': notification.id,
        'title': notification.title,
        'body': notification.body,
        'received_at': notification.receivedAt.millisecondsSinceEpoch,
        'payload': jsonEncode(notification.data),
        'is_read': notification.isRead ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    revision.value++;
  }

  Future<List<UehNotification>> getAll() async {
    final db = await database;
    final rows = await db.query(
      'notifications',
      orderBy: 'received_at DESC',
      limit: 200,
    );
    return rows.map(UehNotification.fromMap).toList();
  }

  Future<void> markRead(String id) async {
    final db = await database;
    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
    revision.value++;
  }

  Future<void> clear() async {
    final db = await database;
    await db.delete('notifications');
    revision.value++;
  }
}
