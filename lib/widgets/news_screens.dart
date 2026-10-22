import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/ueh_models.dart';
import '../services/ueh_api.dart';
import 'common_ui.dart';

class CategoryNewsScreen extends StatefulWidget {
  const CategoryNewsScreen({super.key,required this.categoryId,required this.title});
  final int categoryId;
  final String title;
  @override State<CategoryNewsScreen> createState()=>_CategoryNewsScreenState();
}
class _CategoryNewsScreenState extends State<CategoryNewsScreen>{
  final _scroll=ScrollController();
  final _items=<NewsArticle>[];
  bool _loading=false,_exhausted=false;
  String? _error;
  int _offset=0,_total=0;
  static const _limit=20;
  @override void initState(){super.initState();_scroll.addListener(_onScroll);_fetch();}
  @override void dispose(){_scroll.dispose();super.dispose();}
  void _onScroll(){if(_scroll.hasClients && _scroll.position.extentAfter < 350) _fetch();}
  Future<void> _fetch()async{
    if(_loading||_exhausted)return;
    setState((){_loading=true;_error=null;});
    try {
      final page=await UehApi.instance.categoryNews(widget.categoryId,limit:_limit,offset:_offset);
      if(!mounted)return;
      setState((){
        _items.addAll(page.items);
        _offset+=page.items.length;
        _total=page.total;
        _exhausted=page.items.isEmpty || _offset>=_total;
      });
    }catch(e){if(mounted)setState(()=>_error='$e');}
    finally{if(mounted)setState(()=>_loading=false);}
  }
  Future<void> _refresh()async{
    setState((){_items.clear();_offset=0;_total=0;_exhausted=false;_error=null;});
    await _fetch();
  }
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:Text(widget.title),backgroundColor:uehTeal,foregroundColor:Colors.white),
    body:RefreshIndicator(onRefresh:_refresh,child:ListView.builder(
      controller:_scroll,physics:const AlwaysScrollableScrollPhysics(),
      itemCount:_items.length+1,itemBuilder:(context,i){
        if(i==_items.length){
          if(_loading)return const Padding(padding:EdgeInsets.all(24),child:Center(child:CircularProgressIndicator()));
          if(_error!=null)return ErrorMessage(message:_error!,retry:_fetch);
          if(_items.isEmpty)return const Padding(padding:EdgeInsets.all(35),child:Center(child:Text('Danh mục hiện chưa có tin.')));
          return Padding(padding:const EdgeInsets.all(24),child:Center(child:Text('Đã tải ${_items.length}/$_total tin')));
        }
        final article=_items[i];
        return Card(margin:const EdgeInsets.symmetric(horizontal:14,vertical:8),child:ListTile(
          leading:SizedBox(width:78,child:NetworkPicture(url:article.thumbnailImage,height:72)),
          title:Text(article.title,maxLines:3,overflow:TextOverflow.ellipsis),
          subtitle:Text(article.summary,maxLines:2,overflow:TextOverflow.ellipsis),
          onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>NewsDetailScreen(uid:article.uid))),
        ));
      })),
  );
}

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key,required this.uid});
  final int uid;
  @override State<NewsDetailScreen> createState()=>_NewsDetailScreenState();
}
class _NewsDetailScreenState extends State<NewsDetailScreen>{
  late Future<NewsArticle> _future;
  @override void initState(){super.initState();_reload();}
  void _reload()=>setState(()=>_future=UehApi.instance.newsDetail(widget.uid));
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Chi tiết tin tức'),backgroundColor:uehTeal,foregroundColor:Colors.white),
    body:FutureBuilder<NewsArticle>(future:_future,builder:(ctx,snap){
      if(snap.connectionState!=ConnectionState.done)return const Center(child:CircularProgressIndicator());
      if(snap.hasError)return ErrorMessage(message:'${snap.error}',retry:_reload);
      final n=snap.data!;
      return ListView(padding:const EdgeInsets.all(17),children:[
        Text(n.category.toUpperCase(),style:const TextStyle(color:uehOrange,fontWeight:FontWeight.bold)),
        const SizedBox(height:8),Text(n.title,style:const TextStyle(fontSize:23,fontWeight:FontWeight.w800)),
        const SizedBox(height:12),NetworkPicture(url:n.backgroundImage??n.thumbnailImage,height:220),
        const SizedBox(height:18),Text(n.summary,style:const TextStyle(fontWeight:FontWeight.w500,fontSize:16)),
        const SizedBox(height:12),Html(data:n.content??'<p>Chưa có nội dung bài viết.</p>'),
      ]);
    }),
  );
}