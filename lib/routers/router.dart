import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/account_screen.dart';
import '../widgets/attendance_screen.dart';
import '../widgets/home_screen.dart';
import '../widgets/login_screen.dart';
import '../widgets/notification_screen.dart';
import '../widgets/splash_screen.dart';

final GoRouter appRouter=GoRouter(initialLocation:'/splash',routes:[
  GoRoute(path:'/splash',builder:(_,__)=>const SplashScreen()),
  GoRoute(path:'/login',builder:(_,__)=>const LoginScreen()),
  GoRoute(path:'/home',builder:(_,__)=>const HomeScreen()),
  GoRoute(path:'/attendance',builder:(_,__)=>const AttendanceScreen()),
  GoRoute(path:'/account',builder:(_,__)=>const AccountScreen()),
  GoRoute(path:'/notifications',builder:(_,__)=>const NotificationScreen()),
],errorBuilder:(_,state)=>Scaffold(body:Center(child:Text('Không tìm thấy trang ${state.uri}'))));