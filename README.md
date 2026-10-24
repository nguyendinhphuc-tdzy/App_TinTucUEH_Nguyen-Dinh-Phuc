# UEH Student - API Integration (source từ ZIP mới nhất)

Nguồn: **App_SinhVienUEH_Nguyen Dinh Phuc.zip** do người dùng cung cấp (thư mục `lib/`).
Đặc tả: **API_GUIDE.pdf ngày 2026-10-13**.

## Trạng thái triển khai

Đã viết lớp tích hợp API theo tài liệu và giao diện để kết nối dữ liệu **động**:

| Tính năng | Trạng thái code | Kiểm thử server thực tế |
|---|---|---|
| Login + secure storage | Có | Chưa kiểm chứng live |
| Refresh token 1 lần / chống song song / retry 1 lần | Có | Chưa kiểm chứng live |
| Thẻ sinh viên động | Có | Chưa kiểm chứng live |
| QR/Barcode + attendance + GPS khi cần | Có | Chưa kiểm chứng live |
| Menu API + SQLite cache offline | Có | Chưa kiểm chứng live |
| 1 tin nổi bật + 4 tin theo API | Có | Chưa kiểm chứng live |
| Category news lazy loading, limit/offset/total | Có | Chưa kiểm chứng live |
| Detail news với HTML renderer (`flutter_widget_from_html_core`) | Có | Chưa kiểm chứng live |
| Firebase FCM/notification history | **Chưa tích hợp** | Cần Firebase project + `flutterfire configure` |
| Face recognition | **API GUIDE không có endpoint** | Không thể xác thực thật nếu không có backend |

**Không tuyên bố 100% hoạt động:** Chưa thể chạy `flutter analyze`, `flutter run`, hoặc Postman gọi endpoint từ môi trường tạo file. Cần kiểm tra ở PC và điện thoại thật.

## 1. Ghép mã vào project trên Windows

ZIP này chứa `lib/`, `pubspec.yaml`, `test/`, tài liệu và Postman Collection. Do ZIP gốc chỉ có `lib/`, nó **không chứa** Android platform và các ảnh `assets/img/`. Trên máy của bạn đã có một project Flutter đầy đủ từ GitHub (có `android/` và `assets/img/`).

1. Sao lưu project hiện tại hoặc tạo branch Git trước khi sửa.
2. **Ghi đè thư mục `lib/`** trong project đầy đủ bằng thư mục `lib/` trong ZIP này.
3. Cập nhật `pubspec.yaml`: dùng file đính kèm hoặc merge dependencies với pubspec hiện tại.
4. Giữ nguyên `android/`, `assets/img/`, ký ứng dụng, cấu hình Gradle từ project đầy đủ. Không thay Android project bằng ZIP `lib`.
5. Nếu project còn file `test/widget_test.dart` được Flutter sinh tự động cho counter demo, hãy xóa file test cũ đó (hoặc thay test theo app hiện tại) trước khi chạy `flutter test`.
6. Chạy:

```powershell
flutter pub get
flutter analyze
flutter test
flutter devices
flutter run -d "<ANDROID_DEVICE_ID>"
```

**Lưu ý:** `flutter pub get` chỉ xác nhận dependencies, không xác minh API hoạt động.

## 2. Android Manifest

Mở `android/app/src/main/AndroidManifest.xml`. Đặt các dòng dưới đây **ngay trong `<manifest>` nhưng ngoài `<application>`**:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Nếu package `mobile_scanner` báo yêu cầu `minSdk` cụ thể, làm theo message build Android thực tế, không tự chỉnh version Gradle đoán mò.

## 3. Postman (cần làm để xác minh backend)

Import hai file từ thư mục `postman/` trong Postman:

- `UEH_Student_API.postman_collection.json`
- `UEH_Student.postman_environment.json`

Chọn Environment **UEH Student - Local Testing**, mở Variables:

- `base_url`: giữ nguyên `https://api.ngoisaoviet.info`
- `mssv`: đã điền theo bạn cung cấp
- `password`: nhập mật khẩu thật trong máy cá nhân; **không gửi cho AI hoặc commit vào Git**
- `attendance_code`: nhập mã đợt do giáo viên cấp đang có hiệu lực
- `latitude`, `longitude`: nhập tọa độ GPS **thực tế** nếu test đợt yêu cầu GPS; phải là số
- `news_uid`: điền `uid` từ response Featured hoặc Category

Chạy từng request theo thứ tự:

1. `POST Login`: 200, script tự lưu `access_token` và `refresh_token` vào Environment (dạng secret).
2. `GET Student Info`: 200, kiểm tra MSSV từ server.
3. `GET Menu`: 200, JSON array có `icon_name`, `menu_name`, `menu_url`, `ordering`.
4. `GET Featured News`: không cần token; tối đa 5 tin.
5. `GET Category News`: đổi `offset` từ 0 -> 20 -> 40 cho tới khi `offset + items.length >= total`.
6. `GET News Detail`: dùng `news_uid` thật; nhận `content` dạng HTML.
7. `POST Attendance`: dùng mã hợp lệ, không GPS nếu đợt không yêu cầu; hoặc tọa độ GPS thật nếu có kiểm tra vị trí.
8. `POST Refresh Token`: Test script phải lưu ngay cặp token mới. **Không bấm Send 2 lần liên tiếp trên cùng refresh token**.

Nếu trả `401` trong Postman, refresh một lần rồi request lại. 400/403/404/409 hiển thị `message` từ server.

## 4. Flow Flutter

```text
Splash -> Login (nếu chưa có session) -> Home
                                    |-> Tài khoản: /api/student-info
                                    |-> Điểm danh: /api/attendance
                                    |-> Menu: SQLite -> /api/menu -> SQLite
                                    |-> Tin nổi bật: /api/news/featured
                                    |-> Danh mục: /api/news?cat_uid=&limit=&offset=
                                    |-> Chi tiết: /api/news/{uid}
```

Token được lưu trong `flutter_secure_storage`. Password không lưu trong code. Menu lưu SQLite để hiển thị lần sau khi mạng yếu.

### Về Firebase

`API_GUIDE.pdf` không có endpoint Firebase. Tài liệu lớp riêng yêu cầu Firebase Cloud Messaging, nhưng cần tạo/chọn project Firebase của bạn, chạy `flutterfire configure` trên chính project này để sinh `firebase_options.dart`. **Chưa thể gọi FCM là hoàn tất** nếu thiếu kết nối đó; màn hình Thông báo hiện hiển thị trạng thái chưa cấu hình, không giả lập push.

### Về UI giống UEH Student

Bản này là bước tích hợp dữ liệu thật theo API Guide, UI cơ bản bám màu UEH; chưa thể khẳng định giống **100%** app UEH Student thương mại nếu không có bộ ảnh tham chiếu đầy đủ tất cả màn hình.

## Sửa lỗi tương thích Flutter 3.47.x

- FontAwesome v11 trả `FaIconData` thay vì `IconData`: Drawer sử dụng `FaIcon` cho icon Font Awesome và `Icon` cho icon Material.
- Thay `flutter_html: ^3.0.0` (lỗi `qs.matches` ở cấu hình gói đang dùng) bằng `flutter_widget_from_html_core: ^0.17.4` và `HtmlWidget` để render nội dung HTML.
- Sau khi pull commit này: chạy `flutter pub get`, `flutter analyze`, `flutter test` trước khi `flutter run`. Các phiên bản trong `pubspec.lock` sẽ được Flutter cập nhật trên máy bạn.

## Firebase Messaging

Cấu hình Firebase Cloud Messaging và lịch sử SQLite: xem [FIREBASE_SETUP.md](FIREBASE_SETUP.md).
