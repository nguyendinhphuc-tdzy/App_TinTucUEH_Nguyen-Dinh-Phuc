import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const uehTeal=Color(0xFF00636B);
const uehOrange=Color(0xFFE67728);

class UehBottomNav extends StatelessWidget {
  const UehBottomNav({super.key,required this.index});
  final int index;
  @override Widget build(BuildContext context) => NavigationBar(
    selectedIndex:index,indicatorColor:const Color(0xFFFFE6D3),
    height:76,
    onDestinationSelected:(value){
      final routes=['/home','/notifications','/attendance','/account'];
      if(value!=index) context.go(routes[value]);
    },
    destinations:const [
      NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Trang chủ'),
      NavigationDestination(icon:Icon(Icons.notifications_outlined),selectedIcon:Icon(Icons.notifications),label:'Thông báo'),
      NavigationDestination(icon:Icon(Icons.qr_code_scanner),label:'Điểm danh'),
      NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Tài khoản'),
    ],
  );
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key,required this.message,required this.retry});
  final String message;
  final VoidCallback retry;
  @override Widget build(BuildContext context) => Center(child: Padding(
    padding:const EdgeInsets.all(28),child:Column(mainAxisSize:MainAxisSize.min,children:[
      const Icon(Icons.cloud_off,size:54,color:uehOrange),
      const SizedBox(height:12),Text(message,textAlign:TextAlign.center),
      const SizedBox(height:12),TextButton.icon(onPressed:retry,icon:const Icon(Icons.refresh),label:const Text('Thử lại')),
    ])));
}

class NetworkPicture extends StatelessWidget {
  const NetworkPicture({super.key,required this.url,this.height=180});
  final String? url;
  final double height;
  @override Widget build(BuildContext context) => SizedBox(height:height,width:double.infinity,
    child:url==null ? const ColoredBox(color:Color(0xFFEDF4F4),child:Center(child:Icon(Icons.image_not_supported_outlined))) :
    Image.network(url!,fit:BoxFit.cover,loadingBuilder:(context,child,progress)=>progress==null ? child :
      const ColoredBox(color:Color(0xFFEDF4F4),child:Center(child:CircularProgressIndicator())),
      errorBuilder:(_,_,_)=>const ColoredBox(color:Color(0xFFEDF4F4),child:Center(child:Icon(Icons.broken_image_outlined)))));
}