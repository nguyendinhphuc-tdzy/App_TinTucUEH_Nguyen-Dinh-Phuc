import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.onItemSelected});

  final ValueChanged<DrawerMenuItem> onItemSelected;

  static const List<DrawerMenuItem> menuItems = [
    DrawerMenuItem('Tin tức UEH', Icons.newspaper_outlined, '/tintucmobile'),
    DrawerMenuItem('Sự kiện UEH', Icons.event_outlined, '/su-kien'),
    DrawerMenuItem('Xem điểm', Icons.receipt_long_outlined, '/xem-diem'),
    DrawerMenuItem(
      'Định danh khuôn mặt',
      Icons.face_retouching_natural_outlined,
      '/dinh-danh-khuon-mat',
    ),
    DrawerMenuItem(
      'Thời khóa biểu',
      Icons.calendar_month_outlined,
      '/thoi-khoa-bieu',
    ),
    DrawerMenuItem('Lịch thi', Icons.assignment_outlined, '/lich-thi'),
    DrawerMenuItem(
      'Chăm sóc sức khỏe',
      Icons.health_and_safety_outlined,
      '/cham-soc-suc-khoe',
    ),
    DrawerMenuItem(
      'UEH Go Green Station',
      Icons.eco_outlined,
      '/ueh-go-green-station',
    ),
    DrawerMenuItem(
      'Liên hệ trực tiếp UEH',
      Icons.support_agent_outlined,
      '/lien-he',
    ),
    DrawerMenuItem(
      'UEH Green Coin',
      Icons.monetization_on_outlined,
      '/ueh-green-coin',
    ),
    DrawerMenuItem(
      'Đã điểm danh',
      Icons.workspace_premium_outlined,
      '/da-diem-danh',
    ),
    DrawerMenuItem('Hoạt động ngoại khóa', Icons.receipt_long, '/ngoai-khoa'),
    DrawerMenuItem('Công việc làm UEH', Icons.groups_outlined, '/viec-lam'),
    DrawerMenuItem('UEH Wayfinding', Icons.map_outlined, '/wayfinding'),
    DrawerMenuItem('Photocopy', Icons.print_outlined, '/photocopy'),
    DrawerMenuItem(
      'Đặt lịch tư vấn',
      Icons.event_available_outlined,
      '/dat-lich-tu-van',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * .78,
      backgroundColor: const Color(0xFFF8F9F8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(14)),
      ),
      child: Column(
        children: [
          Container(
            height: 112 + MediaQuery.paddingOf(context).top,
            width: double.infinity,
            color: const Color(0xFF0D5156),
            padding: EdgeInsets.fromLTRB(
              38,
              MediaQuery.paddingOf(context).top + 16,
              38,
              12,
            ),
            child: Image.asset(
              'assets/img/logo-header.png',
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: menuItems.length,
                separatorBuilder: (_, index) =>
                    const Divider(height: 1, color: Color(0x220D5156)),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 34,
                      vertical: 7,
                    ),
                    leading: Icon(
                      item.icon,
                      color: const Color(0xFF0D5156),
                      size: 27,
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        color: Color(0xFF0D5156),
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      onItemSelected(item);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerMenuItem {
  const DrawerMenuItem(this.title, this.icon, this.path);

  final String title;
  final IconData icon;
  final String path;
}
