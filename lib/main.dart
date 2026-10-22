import 'package:flutter/material.dart';
import 'routers/router.dart';

void main(){WidgetsFlutterBinding.ensureInitialized();runApp(const MyApp());}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override Widget build(BuildContext context)=>MaterialApp.router(
    title:'UEH Student',debugShowCheckedModeBanner:false,
    theme:ThemeData(colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF00636B)),
      useMaterial3:true,scaffoldBackgroundColor:Colors.white),
    routerConfig:appRouter,
  );
}