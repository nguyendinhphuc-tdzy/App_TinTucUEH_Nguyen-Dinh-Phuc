import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/ueh_api.dart';
import 'common_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState()=>_LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _form=GlobalKey<FormState>();
  final _mssv=TextEditingController(),_password=TextEditingController();
  bool _working=false,_obscure=true;
  @override void dispose(){_mssv.dispose();_password.dispose();super.dispose();}
  Future<void> _login() async {
    if(!_form.currentState!.validate()||_working)return;
    setState(()=>_working=true);
    try {
      await UehApi.instance.login(_mssv.text,_password.text);
      if(mounted) context.go('/home');
    }catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('$e')));}
    finally{if(mounted)setState(()=>_working=false);}
  }
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Đăng nhập UEH Student'),backgroundColor:uehTeal,foregroundColor:Colors.white),
    body:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(28),child:ConstrainedBox(
      constraints:const BoxConstraints(maxWidth:470),child:Form(key:_form,child:Column(children:[
        Image.asset('assets/img/logo-primary.png',height:110,errorBuilder:(_,__,___)=>const Icon(Icons.school,size:90,color:uehTeal)),
        const SizedBox(height:24),const Text('UEH Student',style:TextStyle(fontSize:29,fontWeight:FontWeight.bold,color:uehTeal)),
        const SizedBox(height:12),const Text('Đăng nhập để xem thẻ sinh viên, menu và điểm danh',textAlign:TextAlign.center),
        const SizedBox(height:34),TextFormField(controller:_mssv,keyboardType:TextInputType.number,
          autofillHints:const [AutofillHints.username],textInputAction:TextInputAction.next,
          decoration:const InputDecoration(border:OutlineInputBorder(),labelText:'Mã số sinh viên',prefixIcon:Icon(Icons.badge_outlined)),
          validator:(value)=>(value?.trim().isEmpty??true)?'Vui lòng nhập MSSV':null),
        const SizedBox(height:16),TextFormField(controller:_password,obscureText:_obscure,
          autofillHints:const [AutofillHints.password],onFieldSubmitted:(_)=>_login(),
          decoration:InputDecoration(border:const OutlineInputBorder(),labelText:'Mật khẩu',
            prefixIcon:const Icon(Icons.lock_outline),suffixIcon:IconButton(
              icon:Icon(_obscure?Icons.visibility:Icons.visibility_off),onPressed:()=>setState(()=>_obscure=!_obscure))),
          validator:(value)=>(value?.isEmpty??true)?'Vui lòng nhập mật khẩu':null),
        const SizedBox(height:25),SizedBox(width:double.infinity,height:54,child:FilledButton(
          style:FilledButton.styleFrom(backgroundColor:uehOrange),onPressed:_working?null:_login,
          child:_working?const CircularProgressIndicator(color:Colors.white):const Text('ĐĂNG NHẬP'))),
        const SizedBox(height:20),const Text('Mật khẩu không được lưu vào ứng dụng.',style:TextStyle(color:Colors.grey)),
      ]))))),
  );
}