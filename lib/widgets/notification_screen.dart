import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'common_ui.dart';

/// Cần cấu hình Firebase project thật qua `flutterfire configure` trước khi
/// tích hợp FCM. Màn hình này không giả lập thông báo từ server.
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Thông báo'),backgroundColor:uehTeal,foregroundColor:Colors.white),
    drawer:const AppDrawer(),
    body:const Center(child:Padding(padding:EdgeInsets.all(24),child:Column(
      mainAxisSize:MainAxisSize.min,children:[
        Icon(Icons.notifications_none,size:65,color:uehTeal),SizedBox(height:15),
        Text('Chưa cấu hình Firebase Cloud Messaging',style:TextStyle(fontWeight:FontWeight.w700,fontSize:17)),
        SizedBox(height:7),Text('Sau khi liên kết Firebase project và bật quyền thông báo, lịch sử thông báo sẽ được xây dựng tại đây.',textAlign:TextAlign.center),
      ]))),
    bottomNavigationBar:const UehBottomNav(index:1),
  );
}