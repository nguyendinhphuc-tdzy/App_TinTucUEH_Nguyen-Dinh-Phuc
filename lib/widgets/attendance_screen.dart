import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/ueh_models.dart';
import '../services/ueh_api.dart';
import 'app_drawer.dart';
import 'common_ui.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override State<AttendanceScreen> createState()=>_AttendanceScreenState();
}
class _AttendanceScreenState extends State<AttendanceScreen>{
  final _code=TextEditingController();
  bool _working=false;
  @override void dispose(){_code.dispose();super.dispose();}
  Future<void> _scan() async {
    final result=await Navigator.of(context).push<String>(MaterialPageRoute(builder:(_)=>const _CodeScanner()));
    if(result!=null && mounted){_code.text=result.trim().toUpperCase();}
  }
  Future<Position> _location() async {
    if(!await Geolocator.isLocationServiceEnabled()){
      throw UehApiException('Bật GPS/Dịch vụ vị trí để điểm danh.',status:400);
    }
    var permission=await Geolocator.checkPermission();
    if(permission==LocationPermission.denied)permission=await Geolocator.requestPermission();
    if(permission==LocationPermission.deniedForever || permission==LocationPermission.denied){
      throw UehApiException('Cần cấp quyền Vị trí cho ứng dụng.',status:403);
    }
    return Geolocator.getCurrentPosition(locationSettings:const LocationSettings(
      accuracy:LocationAccuracy.high,timeLimit:Duration(seconds:18)));
  }
  Future<void> _submit() async {
    final code=_code.text.trim().toUpperCase();
    if(!RegExp(r'^[A-Z0-9]{6}$').hasMatch(code)){
      _message('Mã điểm danh phải gồm đúng 6 chữ/số.');return;
    }
    if(_working)return;
    setState(()=>_working=true);
    try {
      late AttendanceResult result;
      try {result=await UehApi.instance.attendance(code);}
      on UehApiException catch(e){
        if(e.status!=400 || !e.message.toLowerCase().contains('yêu cầu vị trí'))rethrow;
        final p=await _location();
        result=await UehApi.instance.attendance(code,latitude:p.latitude,longitude:p.longitude);
      }
      if (mounted) {
        await showDialog<void>(context:context,builder:(ctx)=>AlertDialog(
        title:const Row(children:[Icon(Icons.check_circle,color:Colors.green),SizedBox(width:8),Text('Điểm danh thành công')]),
        content:Text('${result.message}\n${result.sessionName}\n${result.name} (${result.mssv})\nLần điểm danh: ${result.checkInNumber}'
          '${result.distanceMeters==null?'':'\nKhoảng cách: ${result.distanceMeters!.toStringAsFixed(1)} m'}'),
        actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('Đóng'))]));
      }
    } on SessionExpiredException catch(e){if(mounted){_message('$e');context.go('/login');}}
      catch(e){if(mounted)_message('$e');}
    finally{if(mounted)setState(()=>_working=false);}
  }
  void _message(String message)=>ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content:Text(message)));
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Điểm danh'),backgroundColor:uehOrange,foregroundColor:Colors.white),
    drawer:const AppDrawer(),
    body:SingleChildScrollView(padding:const EdgeInsets.all(26),child:Column(children:[
      const SizedBox(height:24),const Text('Vui lòng nhập hoặc quét mã để điểm danh',
        textAlign:TextAlign.center,style:TextStyle(fontSize:21,color:uehOrange,fontWeight:FontWeight.bold)),
      const SizedBox(height:64),const Text('Nhập mã điểm danh'),
      TextField(controller:_code,maxLength:6,textAlign:TextAlign.center,textCapitalization:TextCapitalization.characters,
        inputFormatters:[FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))],
        decoration:const InputDecoration(hintText:'Mã 6 ký tự',counterText:'')),
      const SizedBox(height:24),const Text('Hoặc'),const SizedBox(height:20),
      OutlinedButton.icon(onPressed:_scan,icon:const Icon(Icons.qr_code_scanner),label:const Text('Quét mã QR Code')),
      const SizedBox(height:8),OutlinedButton.icon(onPressed:_scan,icon:const Icon(Icons.document_scanner_outlined),label:const Text('Quét mã Barcode')),
      const SizedBox(height:8),OutlinedButton.icon(onPressed:()=>_message('API GUIDE chưa cung cấp API xác thực khuôn mặt.'),
        icon:const Icon(Icons.face),label:const Text('Xác thực khuôn mặt')),
      const SizedBox(height:35),SizedBox(width:double.infinity,height:52,child:FilledButton(
        style:FilledButton.styleFrom(backgroundColor:uehOrange),onPressed:_working?null:_submit,
        child:_working?const CircularProgressIndicator(color:Colors.white):const Text('ĐIỂM DANH'))),
    ])),bottomNavigationBar:const UehBottomNav(index:2),
  );
}

class _CodeScanner extends StatefulWidget {
  const _CodeScanner();
  @override State<_CodeScanner> createState()=>_CodeScannerState();
}
class _CodeScannerState extends State<_CodeScanner>{
  bool _done=false;
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Quét mã điểm danh'),backgroundColor:uehOrange,foregroundColor:Colors.white),
    body:MobileScanner(onDetect:(capture){
      if(_done||capture.barcodes.isEmpty)return;
      final raw=capture.barcodes.first.rawValue?.trim();
      if(raw==null||raw.isEmpty)return;
      _done=true;
      Navigator.pop(context,raw);
    }),
  );
}