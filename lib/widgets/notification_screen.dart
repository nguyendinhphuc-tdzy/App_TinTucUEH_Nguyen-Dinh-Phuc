import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/notification_history.dart';
import '../services/notification_service.dart';
import 'app_drawer.dart';
import 'common_ui.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  late Future<List<UehNotification>> _notifications;
  AuthorizationStatus? _permission;
  String? _status;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notifications = NotificationHistory.instance.getAll();
    NotificationHistory.instance.revision.addListener(_reload);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NotificationHistory.instance.revision.removeListener(_reload);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _reload();
  }

  void _reload() {
    if (!mounted) return;
    setState(() {
      _notifications = NotificationHistory.instance.getAll();
    });
  }

  Future<void> _requestPermission() async {
    try {
      final permission = await NotificationService.instance.requestPermission();
      if (mounted) {
        setState(() {
          _permission = permission;
          _status = permission == AuthorizationStatus.authorized
              ? 'Đã cấp quyền thông báo.'
              : 'Chưa cấp quyền thông báo. Hãy kiểm tra Cài đặt Android.';
        });
      }
    } catch (error) {
      if (mounted) setState(() => _status = error.toString());
    }
  }

  Future<void> _copyToken() async {
    try {
      final token = await NotificationService.instance.getToken();
      if (token == null || token.isEmpty) {
        throw StateError('FCM token chưa sẵn sàng.');
      }
      await Clipboard.setData(ClipboardData(text: token));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'Đã sao chép FCM token để kiểm thử trong Firebase Console.',
          )),
        );
      }
    } catch (error) {
      if (mounted) setState(() => _status = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = NotificationService.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        backgroundColor: uehTeal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Làm mới lịch sử',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: const UehBottomNav(index: 1),
      body: Column(
        children: [
          if (!service.isReady)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                service.setupError ?? 'Firebase chưa được cấu hình.',
                style: const TextStyle(color: uehOrange),
                textAlign: TextAlign.center,
              ),
            ),
          if (service.isReady)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: [
                  OutlinedButton.icon(
                    onPressed: _requestPermission,
                    icon: const Icon(Icons.notifications_active_outlined),
                    label: const Text('Cho phép thông báo'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _copyToken,
                    icon: const Icon(Icons.copy_outlined),
                    label: const Text('Sao chép FCM token'),
                  ),
                ],
              ),
            ),
          if (_permission != null || _status != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_status ?? '', textAlign: TextAlign.center),
            ),
          Expanded(
            child: FutureBuilder<List<UehNotification>>(
              future: _notifications,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return ErrorMessage(
                    message: 'Không đọc được SQLite: ${snapshot.error}',
                    retry: _reload,
                  );
                }
                final items = snapshot.data ?? [];
                return RefreshIndicator(
                  onRefresh: () async {
                    _reload();
                    await _notifications;
                  },
                  child: items.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 115),
                            Icon(Icons.notifications_none_outlined,
                                size: 70, color: uehTeal),
                            SizedBox(height: 14),
                            Center(child: Text('Chưa có thông báo nào.')),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return ListTile(
                              leading: Icon(
                                item.isRead
                                    ? Icons.notifications_none
                                    : Icons.notifications_active,
                                color: uehTeal,
                              ),
                              title: Text(
                                item.title,
                                style: TextStyle(
                                  fontWeight: item.isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(item.body),
                              trailing: Text(
                                '${item.receivedAt.day}/${item.receivedAt.month}',
                                style: const TextStyle(fontSize: 11),
                              ),
                              onTap: () async {
                                await NotificationHistory.instance.markRead(item.id);
                              },
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
