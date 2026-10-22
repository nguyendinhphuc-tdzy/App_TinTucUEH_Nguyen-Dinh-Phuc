import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/ueh_models.dart';

class UehApiException implements Exception {
  UehApiException(this.message, {required this.status});
  final String message;
  final int status;
  @override String toString() => message;
}
class SessionExpiredException extends UehApiException {
  SessionExpiredException() : super('Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.',status:401);
}

class UehApi {
  UehApi._();
  static final UehApi instance = UehApi._();
  static const baseUrl = 'https://api.ngoisaoviet.info';
  static const _sessionKey = 'ueh_student_tokens_v1';
  final _storage = const FlutterSecureStorage();
  final _client = http.Client();
  String? _accessToken, _refreshToken;
  DateTime? _expiresAt;
  bool _loaded = false;
  Future<bool>? _refreshFuture;

  Future<bool> hasSession() async {
    await _restore();
    return _accessToken != null && _refreshToken != null;
  }

  Future<void> _restore() async {
    if (_loaded) return;
    _loaded = true;
    final raw = await _storage.read(key:_sessionKey);
    if (raw == null) return;
    try {
      final obj = jsonDecode(raw) as Map<String,dynamic>;
      _accessToken = obj['token'] as String?;
      _refreshToken = obj['refresh_token'] as String?;
      _expiresAt = DateTime.tryParse('${obj['expires_at'] ?? ''}');
    } catch (_) { await logout(); }
  }

  Future<void> _saveTokens(Map<String,dynamic> obj) async {
    final token = '${obj['token'] ?? ''}';
    final refresh = '${obj['refresh_token'] ?? ''}';
    if (token.isEmpty || refresh.isEmpty) {
      throw UehApiException('Server không trả về đủ token.',status:500);
    }
    final seconds = int.tryParse('${obj['expires_in'] ?? ''}') ?? 3600;
    final expiry = DateTime.now().add(Duration(seconds:seconds));
    // Lưu cả cặp trong một lần ghi, tránh thay thế riêng lẻ refresh token một lần.
    await _storage.write(key:_sessionKey,value:jsonEncode({
      'token':token,'refresh_token':refresh,'expires_at':expiry.toIso8601String()
    }));
    _accessToken=token;
    _refreshToken=refresh;
    _expiresAt=expiry;
    _loaded=true;
  }

  Future<void> login(String mssv, String password) async {
    final obj = await _requestJson('POST','/api/login',body:{
      'mssv':mssv.trim(),'mat_khau':password,
    },isPublic:true);
    await _saveTokens(_asMap(obj));
  }

  Future<void> logout() async {
    _accessToken=null; _refreshToken=null; _expiresAt=null; _loaded=true;
    await _storage.delete(key:_sessionKey);
  }

  Future<bool> _refreshOnce() async {
    if (_refreshFuture != null) return _refreshFuture!;
    final result = _doRefresh();
    _refreshFuture=result;
    try {return await result;} finally {_refreshFuture=null;}
  }

  Future<bool> _doRefresh() async {
    final refresh = _refreshToken;
    if (refresh == null || refresh.isEmpty) return false;
    try {
      final result = await _requestJson('POST','/api/refresh-token',
        body:{'refresh_token':refresh},isPublic:true);
      await _saveTokens(_asMap(result));
      return true;
    } on UehApiException catch (e) {
      if(e.status==401 || e.status==400) {await logout();return false;}
      rethrow;
    }
    // Không xoá token nếu lỗi mạng tạm thời, tránh mất phiên ngoài ý muốn.
  }

  Future<dynamic> _requestJson(String method,String path,{
    Map<String,dynamic>? body,bool isPublic=false,bool allowRetry=true,
  }) async {
    if (!isPublic) {
      await _restore();
      if (_accessToken == null || _refreshToken == null) throw SessionExpiredException();
      if (_expiresAt != null && DateTime.now().isAfter(_expiresAt!.subtract(const Duration(seconds:20)))) {
        if (!await _refreshOnce()) throw SessionExpiredException();
      }
    }
    final sentToken=_accessToken;
    final headers=<String,String>{'Accept':'application/json','Content-Type':'application/json'};
    if(!isPublic) headers['Authorization']='Bearer $sentToken';
    late http.Response res;
    try {
      res = await (method=='GET'
        ? _client.get(Uri.parse('$baseUrl$path'),headers:headers)
        : _client.post(Uri.parse('$baseUrl$path'),headers:headers,body:jsonEncode(body??{})))
        .timeout(const Duration(seconds:25));
    } on SocketException {throw UehApiException('Không có kết nối Internet.',status:0);}
      on http.ClientException {throw UehApiException('Không thể kết nối API.',status:0);}
    if(res.statusCode==401 && !isPublic) {
      // Nếu request khác đã refresh token, dùng cặp token mới ngay,
      // không gửi lại refresh token đã dùng một lần.
      if (allowRetry && _accessToken != sentToken && _accessToken != null) {
        return _requestJson(method,path,body:body,isPublic:false,allowRetry:false);
      }
      if (allowRetry && await _refreshOnce()) {
        return _requestJson(method,path,body:body,isPublic:false,allowRetry:false);
      }
      await logout();
      throw SessionExpiredException();
    }
    dynamic parsed;
    try { parsed=jsonDecode(utf8.decode(res.bodyBytes)); } catch (_) {parsed=null;}
    if(res.statusCode<200 || res.statusCode>=300) {
      var msg='API lỗi (HTTP ${res.statusCode}).';
      if(parsed is Map) {
        final serverMsg=parsed['message']?.toString().trim();
        if(serverMsg!=null && serverMsg.isNotEmpty) msg=serverMsg;
        else if(parsed['errors'] is Map) {
          final errors=parsed['errors'] as Map;
          final first=errors.isEmpty ? null : errors.values.first;
          if(first is List && first.isNotEmpty) msg=first.first.toString();
        }
      }
      throw UehApiException(msg,status:res.statusCode);
    }
    if(parsed==null) throw UehApiException('Dữ liệu JSON không hợp lệ.',status:res.statusCode);
    return parsed;
  }

  static Map<String,dynamic> _asMap(dynamic value) {
    if(value is Map<String,dynamic>) return value;
    throw UehApiException('Cấu trúc phản hồi API không hợp lệ.',status:500);
  }

  Future<StudentInfo> getStudent() async => StudentInfo.fromJson(
    _asMap(await _requestJson('GET','/api/student-info')));
  Future<List<MenuNavItem>> getMenu() async =>
    (await _requestJson('GET','/api/menu') as List).map((x)=>MenuNavItem.fromMap(_asMap(x))).toList();
  Future<List<NewsArticle>> featuredNews() async =>
    (await _requestJson('GET','/api/news/featured',isPublic:true) as List)
      .map((x)=>NewsArticle.fromJson(_asMap(x))).toList();
  Future<NewsPage> categoryNews(int category,{int limit=20,int offset=0}) async =>
    NewsPage.fromJson(_asMap(await _requestJson('GET',
      '/api/news?cat_uid=$category&limit=$limit&offset=$offset',isPublic:true)));
  Future<NewsArticle> newsDetail(int uid) async =>NewsArticle.fromJson(
    _asMap(await _requestJson('GET','/api/news/$uid',isPublic:true)));
  Future<AttendanceResult> attendance(String code,{double? latitude,double? longitude}) async {
    final data=<String,dynamic>{'code':code.trim()};
    if(latitude!=null&&longitude!=null){data['latitude']=latitude;data['longitude']=longitude;}
    return AttendanceResult.fromJson(_asMap(await _requestJson('POST','/api/attendance',body:data)));
  }
}