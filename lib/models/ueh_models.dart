import 'dart:convert';

class StudentInfo {
  const StudentInfo({required this.mssv, required this.name, required this.birthDate,
    required this.isMale, required this.cohort, required this.birthPlace,
    required this.program, required this.schoolYear, required this.avatarUrl});

  final String mssv, name, cohort, birthPlace, program, schoolYear, avatarUrl;
  final DateTime? birthDate;
  final bool isMale;

  factory StudentInfo.fromJson(Map<String, dynamic> json) => StudentInfo(
    mssv: '${json['mssv'] ?? ''}', name: '${json['hoVaTen'] ?? ''}',
    birthDate: DateTime.tryParse('${json['ngaySinh'] ?? ''}'),
    isMale: json['gioiTinh'] == true,
    cohort: '${json['nienKhoa'] ?? ''}', birthPlace: '${json['noiSinh'] ?? ''}',
    program: '${json['heDaoTao'] ?? ''}', schoolYear: '${json['nienHoc'] ?? ''}',
    avatarUrl: '${json['hinhDaiDien'] ?? ''}',
  );

  String get birthDateText => birthDate == null ? '—' :
    '${birthDate!.day.toString().padLeft(2,'0')}/${birthDate!.month.toString().padLeft(2,'0')}/${birthDate!.year}';
}

class MenuNavItem {
  const MenuNavItem({required this.id, required this.iconName, required this.name,
    required this.url, required this.ordering});
  final int id, ordering;
  final String iconName, name, url;
  factory MenuNavItem.fromMap(Map<String, dynamic> json) => MenuNavItem(
    id: (json['id'] as num?)?.toInt() ?? 0,
    iconName: '${json['icon_name'] ?? ''}',
    name: '${json['menu_name'] ?? ''}',
    url: '${json['menu_url'] ?? ''}',
    ordering: (json['ordering'] as num?)?.toInt() ?? 0,
  );
  Map<String, dynamic> toMap() => {'id':id, 'icon_name':iconName,
    'menu_name':name, 'menu_url':url, 'ordering':ordering};
  String encode() => jsonEncode(toMap());
}

class NewsArticle {
  const NewsArticle({required this.uid, required this.categoryId, required this.category,
    required this.title, required this.summary, required this.postedAt,
    required this.sdgs, required this.isFeatured, this.backgroundImage,
    this.thumbnailImage, this.content});
  final int uid, categoryId;
  final String category, title, summary;
  final DateTime? postedAt;
  final List<int> sdgs;
  final bool isFeatured;
  final String? backgroundImage, thumbnailImage, content;

  factory NewsArticle.fromJson(Map<String, dynamic> json) => NewsArticle(
    uid: (json['uid'] as num?)?.toInt() ?? 0,
    categoryId: (json['cat_uid'] as num?)?.toInt() ?? 0,
    category: '${json['category_name'] ?? ''}',
    title: '${json['title'] ?? ''}',
    summary: '${json['short_desc'] ?? ''}',
    postedAt: DateTime.tryParse('${json['post_date'] ?? ''}'),
    sdgs: (json['sdgs'] as List<dynamic>? ?? const []).map((v) =>
      v is num ? v.toInt() : (int.tryParse('$v') ?? 0)).where((n) => n >= 1 && n <= 17).toList(),
    isFeatured: json['is_featured'] == true,
    backgroundImage: _nullableUrl(json['background_img']),
    thumbnailImage: _nullableUrl(json['thumbnail_img']),
    content: json['content']?.toString(),
  );
  static String? _nullableUrl(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }
}

class NewsPage {
  const NewsPage({required this.total, required this.limit, required this.offset,
    required this.items});
  final int total, limit, offset;
  final List<NewsArticle> items;
  factory NewsPage.fromJson(Map<String, dynamic> json) => NewsPage(
    total: (json['total'] as num?)?.toInt() ?? 0,
    limit: (json['limit'] as num?)?.toInt() ?? 20,
    offset: (json['offset'] as num?)?.toInt() ?? 0,
    items: (json['items'] as List<dynamic>? ?? const [])
      .whereType<Map<String,dynamic>>().map(NewsArticle.fromJson).toList(),
  );
}

class AttendanceResult {
  const AttendanceResult({required this.message, required this.sessionName,
    required this.checkInNumber, required this.name, required this.mssv,
    this.checkedInAt, this.distanceMeters});
  final String message, sessionName, name, mssv;
  final int checkInNumber;
  final DateTime? checkedInAt;
  final double? distanceMeters;
  factory AttendanceResult.fromJson(Map<String,dynamic> j) => AttendanceResult(
    message:'${j['message'] ?? ''}', sessionName:'${j['sessionName'] ?? ''}',
    name:'${j['hoVaTen'] ?? ''}', mssv:'${j['mssv'] ?? ''}',
    checkInNumber:(j['checkInNumber'] as num?)?.toInt() ?? 1,
    checkedInAt:DateTime.tryParse('${j['checkedInAt'] ?? ''}'),
    distanceMeters: (j['distanceMeters'] as num?)?.toDouble(),
  );
}