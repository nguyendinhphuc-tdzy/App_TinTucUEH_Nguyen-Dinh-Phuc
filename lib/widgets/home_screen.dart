import 'package:flutter/material.dart';
import '../models/ueh_models.dart';
import '../services/ueh_api.dart';
import 'app_drawer.dart';
import 'common_ui.dart';
import 'news_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState()=>_HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  late Future<List<NewsArticle>> _featured;
  @override void initState(){super.initState();_reload();}
  void _reload()=>setState(()=>_featured=UehApi.instance.featuredNews());
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(backgroundColor:uehTeal,foregroundColor:Colors.white,
      title:const Text('UEH Student'),centerTitle:true,
      actions:[IconButton(tooltip:'Làm mới',icon:const Icon(Icons.refresh),onPressed:_reload)]),
    drawer:const AppDrawer(),
    body:RefreshIndicator(onRefresh:()async{_reload();try{await _featured;}catch(_){}},
      child:FutureBuilder<List<NewsArticle>>(future:_featured,builder:(ctx,snap){
        if(snap.connectionState!=ConnectionState.done) return const Center(child:CircularProgressIndicator());
        if(snap.hasError)return ErrorMessage(message:'Không tải được tin tức: ${snap.error}',retry:_reload);
        final items=snap.data??[];
        if(items.isEmpty)return const Center(child:Text('API chưa có tin nổi bật.'));
        final featured=items.firstWhere((n)=>n.isFeatured,orElse:()=>items.first);
        final smaller=items.where((n)=>n.uid!=featured.uid).take(4).toList();
        return ListView(padding:const EdgeInsets.all(18),children:[
          const Text('TIN TỨC UEH',style:TextStyle(fontSize:23,fontWeight:FontWeight.bold,color:uehTeal)),
          const SizedBox(height:13),InkWell(onTap:()=>_open(context,featured),child:Card(clipBehavior:Clip.antiAlias,
            child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Stack(alignment:Alignment.bottomLeft,children:[
                NetworkPicture(url:featured.backgroundImage??featured.thumbnailImage,height:230),
                Container(width:double.infinity,padding:const EdgeInsets.all(12),color:Colors.black54,
                  child:Text(featured.title,style:const TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:18))),
              ]),_sdgs(featured.sdgs),
            ]))),
          const SizedBox(height:20),const Text('TIN TỨC NỔI BẬT',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold)),
          for(final n in smaller) _NewsCard(article:n,onTap:()=>_open(context,n)),
          const SizedBox(height:20),const Text('DANH MỤC TIN TỨC',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold)),
          const SizedBox(height:8),
          for(final category in const [219,220,221,222])
            ListTile(leading:const Icon(Icons.article_outlined,color:uehTeal),
              title:Text(_categoryName(category,items)),trailing:const Icon(Icons.chevron_right),
              onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CategoryNewsScreen(
                categoryId:category,title:_categoryName(category,items))))),
        ]);
      })),bottomNavigationBar:const UehBottomNav(index:0),
  );
  void _open(BuildContext context,NewsArticle item)=>Navigator.push(context,
    MaterialPageRoute(builder:(_)=>NewsDetailScreen(uid:item.uid)));
  String _categoryName(int category,List<NewsArticle> items) {
    for (final n in items){if(n.categoryId==category && n.category.isNotEmpty) return n.category;}
    return 'Danh mục $category';
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.article,required this.onTap});
  final NewsArticle article;
  final VoidCallback onTap;
  @override Widget build(BuildContext context)=>Card(margin:const EdgeInsets.only(top:12),clipBehavior:Clip.antiAlias,
    child:InkWell(onTap:onTap,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      NetworkPicture(url:article.thumbnailImage??article.backgroundImage,height:154),
      Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(article.category.toUpperCase(),style:const TextStyle(color:uehOrange,fontWeight:FontWeight.bold)),
        const SizedBox(height:6),Text(article.title,style:const TextStyle(fontSize:17,fontWeight:FontWeight.bold)),
        const SizedBox(height:7),Text(article.summary,maxLines:3,overflow:TextOverflow.ellipsis),
        _sdgs(article.sdgs),
      ])),
    ])));
}

Widget _sdgs(List<int> values) => values.isEmpty?const SizedBox.shrink():Padding(
  padding:const EdgeInsets.only(top:10,bottom:4),child:Wrap(spacing:7,children:[
    for(final id in values) Image.asset('lib/sgds/sdg-$id.png',height:31,width:31,
      errorBuilder:(_,_,_)=>const SizedBox.shrink()),
  ]));