import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/ueh_models.dart';
import '../services/ueh_api.dart';
import 'app_drawer.dart';
import 'common_ui.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override State<AccountScreen> createState()=>_AccountScreenState();
}
class _AccountScreenState extends State<AccountScreen>{
  late Future<StudentInfo> _future;
  @override void initState(){super.initState();_reload();}
  void _reload(){setState(()=>_future=UehApi.instance.getStudent());}
  Future<void> _logout() async {await UehApi.instance.logout();if(mounted)context.go('/login');}
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Tài khoản'),backgroundColor:uehOrange,foregroundColor:Colors.white,
      actions:[IconButton(tooltip:'Đăng xuất',icon:const Icon(Icons.logout),onPressed:_logout)]),
    drawer:const AppDrawer(),
    body:FutureBuilder<StudentInfo>(future:_future,builder:(context,snapshot){
      if(snapshot.connectionState!=ConnectionState.done)return const Center(child:CircularProgressIndicator());
      if(snapshot.hasError){
        if(snapshot.error is SessionExpiredException){WidgetsBinding.instance.addPostFrameCallback((_){if(mounted)context.go('/login');});}
        return ErrorMessage(message:'${snapshot.error}',retry:_reload);
      }
      final s=snapshot.data!;
      return RefreshIndicator(onRefresh:()async{_reload();try{await _future;}catch(_){}},child:ListView(padding:const EdgeInsets.all(20),children:[
        const SizedBox(height:14),Center(child:CircleAvatar(radius:92,backgroundColor:const Color(0xFFFFE4CD),
          child:ClipOval(child:s.avatarUrl.isEmpty ? const Icon(Icons.person,size:80) :
          Image.network(s.avatarUrl,width:170,height:170,fit:BoxFit.cover,errorBuilder:(_,__,___)=>const Icon(Icons.person,size:80))))),
        const SizedBox(height:0),Card(color:uehOrange,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(17)),
          child:Padding(padding:const EdgeInsets.all(24),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            const Center(child:Text('SINH VIÊN',style:TextStyle(color:Colors.white,fontSize:16,letterSpacing:2))),
            const SizedBox(height:8),Center(child:Text(s.name,textAlign:TextAlign.center,style:const TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.bold))),
            Center(child:Text(s.mssv,style:const TextStyle(color:Colors.white,fontSize:16))),
            const SizedBox(height:25),_info('NGÀY SINH',s.birthDateText),_info('GIỚI TÍNH',s.isMale?'Nam':'Nữ'),
            _info('KHÓA',s.cohort),_info('NƠI SINH',s.birthPlace),
            _info('HỆ ĐÀO TẠO',s.program),_info('NIÊN HỌC',s.schoolYear),
            const SizedBox(height:20),Row(children:[const Expanded(child:Text('UEH\nUNIVERSITY',style:TextStyle(color:Colors.white,fontSize:26,fontWeight:FontWeight.w900))),
            Container(color:Colors.white,padding:const EdgeInsets.all(6),child:QrImageView(data:s.mssv,size:125))]),
          ]))),
      ]));
    }),bottomNavigationBar:const UehBottomNav(index:3),
  );
  Widget _info(String label,String value)=>Padding(padding:const EdgeInsets.only(bottom:14),child:Column(
    crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:const TextStyle(color:Color(0xFFFFDFD0),fontSize:12)),
      Text(value.isEmpty?'—':value,style:const TextStyle(color:Colors.white,fontSize:17,fontWeight:FontWeight.w600))]));
}