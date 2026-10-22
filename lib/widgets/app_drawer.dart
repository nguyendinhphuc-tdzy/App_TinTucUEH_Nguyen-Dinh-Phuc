import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/ueh_models.dart';
import '../services/menu_cache.dart';
import '../services/ueh_api.dart';
import 'common_ui.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});
  @override State<AppDrawer> createState()=>_AppDrawerState();
}
class _AppDrawerState extends State<AppDrawer>{
  List<MenuNavItem> _items=[];
  bool _loading=true;
  String? _error;
  @override void initState(){super.initState();_load();}
  Future<void> _load() async {
    // SQLite -> render immediately, network -> sync/update when available.
    try {
      final local=await MenuCache.instance.read();
      if(mounted)setState((){_items=local;_loading=false;});
    }catch(e){if(mounted)setState((){_error='Không mở được menu cache: $e';_loading=false;});}
    try {
      final remote=await MenuCache.instance.refresh();
      if(mounted)setState((){_items=remote;_error=null;_loading=false;});
    } on SessionExpiredException {
      if(mounted){Navigator.pop(context);context.go('/login');}
    }catch(e){if(mounted)setState((){_error='$e';_loading=false;});}
  }
  IconData _icon(String name)=>switch(name.toLowerCase()){
    'newspaper'=>FontAwesomeIcons.newspaper,
    'calendardays'||'calendar'=>FontAwesomeIcons.calendarDays,
    'chartline'=>FontAwesomeIcons.chartLine,
    'graduationcap'=>Icons.school_outlined,
    'user'=>Icons.person_outline,
    'qrcode'=>Icons.qr_code_scanner,
    'clipboardcheck'=>Icons.fact_check_outlined,
    'bell'=>Icons.notifications_outlined,
    'map'=>Icons.map_outlined,
    'leaf'=>Icons.eco_outlined,
    _=>Icons.chevron_right,
  };
  Future<void> _select(MenuNavItem item)async {
    Navigator.pop(context);
    if(item.name.toLowerCase().contains('tin tức')){context.go('/home');return;}
    final link=Uri.tryParse(item.url);
    if(link!=null && (link.scheme=='http'||link.scheme=='https')) {
      if(!await launchUrl(link,mode:LaunchMode.externalApplication) && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Không mở được liên kết này')));
      }
      return;
    }
    if(mounted)ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:Text('“${item.name}” chưa có liên kết/API trong tài liệu.')));
  }
  @override Widget build(BuildContext context)=>Drawer(child:SafeArea(child:Column(children:[
    Container(width:double.infinity,color:uehTeal,padding:const EdgeInsets.all(24),
      child:const Text('UEH STUDENT',style:TextStyle(color:Colors.white,fontSize:22,fontWeight:FontWeight.bold))),
    if(_loading)const LinearProgressIndicator(),
    if(_error!=null)Padding(padding:const EdgeInsets.all(12),child:Text(
      'Menu offline · ${_error!}',style:const TextStyle(fontSize:12,color:Colors.grey))),
    Expanded(child:_items.isEmpty?Center(child:Text(_loading?'Đang tải menu...':'Chưa có menu trong SQLite. Kết nối mạng và đăng nhập để tải menu.',textAlign:TextAlign.center))
      :ListView.builder(itemCount:_items.length,itemBuilder:(context,i){
      final item=_items[i];
      return ListTile(leading:Icon(_icon(item.iconName),color:uehTeal),
        title:Text(item.name),onTap:()=>_select(item));
    })),
    ListTile(leading:const Icon(Icons.logout),title:const Text('Đăng xuất'),onTap:()async{
      Navigator.pop(context);await UehApi.instance.logout();if(context.mounted)context.go('/login');
    }),
  ])));
}