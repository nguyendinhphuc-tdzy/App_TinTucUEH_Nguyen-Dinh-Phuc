import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/services/notification_history.dart';

void main() {
  test('notification history maps persisted SQLite rows', () {
    final item = UehNotification.fromMap({
      'id': 'm1',
      'title': 'Thông báo UEH',
      'body': 'Xin chào',
      'received_at': 1792886400000,
      'payload': '{"category":"general"}',
      'is_read': 1,
    });
    expect(item.id, 'm1');
    expect(item.body, 'Xin chào');
    expect(item.data['category'], 'general');
    expect(item.isRead, isTrue);
  });
}
