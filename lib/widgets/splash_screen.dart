import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/ueh_api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState()=>_SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>{
  @override void initState(){super.initState();_go();}
  Future<void> _go() async {
    try {
      final session=await UehApi.instance.hasSession();
      await Future<void>.delayed(const Duration(milliseconds:1100));
      if(mounted)context.go(session?'/home':'/login');
    }catch(_){if(mounted)context.go('/login');}
  }
  @override Widget build(BuildContext context)=>Scaffold(body:SizedBox.expand(
    child:Image.asset('assets/img/ueh_splash.png',fit:BoxFit.cover,
      errorBuilder:(_,__,___)=>const ColoredBox(color:Color(0xFF00636B),
        child:Center(child:Text('UEH STUDENT',style:TextStyle(color:Colors.white,fontSize:28)))))));
}