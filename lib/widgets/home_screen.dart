import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_drawer.dart';

const Color _uehOrange = Color(0xFFD47D3F);
const Color _uehTeal = Color(0xFF00636B);
const Color _navigationPurpleGrey = Color(0xFF675D78);
const Color _navigationBackground = Color(0xFFFFF8FF);
const Color _featureBlueGrey = Color(0xFF586F80);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _articles = <_NewsArticle>[
    _NewsArticle(
      category: 'CUỘC SỐNG UEH',
      title: '[UEH Alumni - Ngày trở về] UEH Alumni Co-Creation Showcase 2026: Điểm hẹn giao thương, công nghệ và sáng kiến bền vững',
      imageUrl: 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=900&q=85',
      content: 'Hơn 20 gian hàng doanh nghiệp, 8 dự án khởi nghiệp, các sản phẩm công nghệ - nghệ thuật, hơn 500 đầu sách cùng không gian kết nối các câu lạc bộ, đội, nhóm sẽ hội tụ tại Triển lãm “UEH Alumni Co-Creation Showcase 2026: Business, Technology & Sustainable Future”. Diễn ra chiều 03/10 trong khuôn khổ Ngày trở về UEH Alumni Homecoming Day 2026, triển lãm mở ra điểm gặp gỡ giữa cựu sinh viên, doanh nghiệp, startup và đối tác của UEH. Không gian triển lãm giới thiệu những ý tưởng, sản phẩm và câu chuyện được hình thành từ quá trình học tập, nghiên cứu và khởi nghiệp. Người tham dự có dịp trao đổi kinh nghiệm, tìm kiếm mối quan tâm chung và kết nối với các cộng đồng đang hoạt động tại UEH. Qua đó, chương trình góp phần duy trì liên hệ giữa các thế hệ cựu sinh viên và mở rộng cơ hội đồng hành cùng nhà trường trong những sáng kiến tiếp theo.',
    ),
    _NewsArticle(
      category: 'KHOA HỌC - GÓC NHÌN CHUYÊN GIA',
      title: '[UEH 50] UEH tổ chức Hội thảo khoa học: “Phát triển nguồn nhân lực chất lượng cao”',
      imageUrl: 'https://images.unsplash.com/photo-1524178272361-1fb2b075b655?w=900&q=85',
      content: 'Hội thảo khoa học quy tụ các nhà nghiên cứu, chuyên gia và nhà quản lý cùng trao đổi về phát triển nguồn nhân lực chất lượng cao. Những góc nhìn liên ngành và đề xuất thực tiễn góp phần mở ra định hướng phát triển bền vững cho khu vực Đồng bằng sông Cửu Long trong giai đoạn mới. Các tham luận tập trung làm rõ yêu cầu về kiến thức chuyên môn, kỹ năng thích ứng và khả năng học tập suốt đời trong bối cảnh kinh tế thay đổi. Người tham dự cùng phân tích vai trò của cơ sở đào tạo, cơ quan quản lý và doanh nghiệp trong việc phát hiện, bồi dưỡng và sử dụng nhân lực. Những trao đổi tại hội thảo tạo thêm cơ sở để tiếp tục nghiên cứu các giải pháp phù hợp với nhu cầu của địa phương và từng lĩnh vực.',
    ),
    _NewsArticle(
      category: 'BÁO CHÍ NÓI VỀ UEH',
      title: 'Phó Thủ tướng đánh giá cao định hướng đồng sáng tạo của UEH',
      imageUrl: 'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?w=900&q=85',
      content: 'Định hướng đồng sáng tạo của UEH kết nối nhà trường, người học, doanh nghiệp và cộng đồng để cùng kiến tạo tri thức và giải pháp cho xã hội. Đây cũng là nền tảng để đại học đóng góp thiết thực hơn vào sự phát triển của đất nước. Thay vì giới hạn việc trao đổi trong phạm vi giảng đường, mô hình này khuyến khích các bên cùng xác định vấn đề và chia sẻ nguồn lực. Hoạt động hợp tác có thể bắt đầu từ nghiên cứu, chương trình đào tạo, dự án sinh viên hoặc những sáng kiến phục vụ cộng đồng. Khi các góc nhìn khác nhau được lắng nghe, tri thức có thêm cơ hội chuyển hóa thành giải pháp gần với nhu cầu thực tế. UEH tiếp tục hướng đến môi trường học thuật cởi mở, nơi đối thoại và hợp tác là một phần của quá trình phát triển.',
    ),
    _NewsArticle(
      category: 'TUYỂN SINH & HƯỚNG NGHIỆP',
      title: '50+ lớp học Glo-cal truyền cảm hứng: Kết nối kiến thức tài chính và thực tiễn doanh nghiệp',
      imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=900&q=85',
      content: 'Các lớp học Glo-cal kết nối kiến thức quốc tế với bối cảnh địa phương, đưa tình huống thực tế từ doanh nghiệp vào giảng đường. Sinh viên có cơ hội trao đổi cùng chuyên gia, vận dụng kiến thức chuyên môn và phát triển góc nhìn nghề nghiệp. Mỗi chủ đề học tập khuyến khích người học quan sát vấn đề từ nhiều phía, đặt câu hỏi và đề xuất cách tiếp cận của riêng mình. Qua hoạt động thảo luận, làm việc nhóm và trình bày dự án, kiến thức được kết nối với những tình huống gần với môi trường nghề nghiệp. Giảng viên và khách mời đồng hành để gợi mở thêm góc nhìn, đồng thời giúp sinh viên nhận diện điểm mạnh cần phát huy. Trải nghiệm này góp phần làm rõ mối liên hệ giữa nội dung học tập và những lựa chọn nghề nghiệp trong tương lai.',
    ),
  ];

  static const _nextArticles = <_NewsArticle>[
    _NewsArticle(
      category: 'CUỘC SỐNG UEH',
      title: 'UEH lan tỏa tinh thần đổi mới sáng tạo qua các hoạt động kết nối cộng đồng',
      imageUrl: 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=900&q=85',
      content: 'Các hoạt động kết nối cộng đồng tại UEH tạo không gian để người học, cựu sinh viên và doanh nghiệp cùng chia sẻ ý tưởng, kinh nghiệm và giải pháp thiết thực. Mỗi chương trình mở ra cơ hội để các thành viên gặp gỡ, lắng nghe những câu chuyện khác nhau và tìm kiếm hướng hợp tác phù hợp. Từ hoạt động học thuật đến các sáng kiến xã hội, sự tham gia của nhiều nhóm giúp ý tưởng được nhìn nhận đa chiều hơn. Người học có thể tiếp cận kinh nghiệm thực tế, trong khi đối tác có dịp chia sẻ nhu cầu và góc nhìn của mình. Những kết nối được hình thành qua từng hoạt động góp phần xây dựng một cộng đồng UEH cởi mở, chủ động và gắn bó lâu dài.',
    ),
    _NewsArticle(
      category: 'KHOA HỌC - GÓC NHÌN CHUYÊN GIA',
      title: 'Diễn đàn học thuật thúc đẩy các sáng kiến phát triển bền vững',
      imageUrl: 'https://images.unsplash.com/photo-1524178272361-1fb2b075b655?w=900&q=85',
      content: 'Các chuyên gia cùng thảo luận về sáng kiến phát triển bền vững, chia sẻ kết quả nghiên cứu và đề xuất giải pháp có khả năng ứng dụng trong thực tiễn. Diễn đàn tạo điều kiện để người tham dự so sánh cách tiếp cận, nhận diện những điểm chung và trao đổi về khả năng triển khai ở các bối cảnh khác nhau. Các chủ đề được nhìn từ góc độ kinh tế, xã hội và môi trường nhằm làm rõ mối liên hệ giữa tăng trưởng và chất lượng cuộc sống. Những câu hỏi từ thực tiễn cũng gợi mở hướng nghiên cứu tiếp theo cho giảng viên, chuyên gia và người học. Qua đối thoại liên ngành, các sáng kiến có thêm cơ hội được hoàn thiện và kết nối với đối tác quan tâm.',
    ),
    _NewsArticle(
      category: 'BÁO CHÍ NÓI VỀ UEH',
      title: 'UEH thúc đẩy mô hình đại học gắn kết với doanh nghiệp và xã hội',
      imageUrl: 'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?w=900&q=85',
      content: 'Mô hình đại học gắn kết mở rộng cơ hội hợp tác đào tạo và nghiên cứu, đồng thời đưa tri thức đến gần hơn với nhu cầu của doanh nghiệp và cộng đồng. Quan hệ hợp tác được xây dựng thông qua trao đổi chuyên môn, dự án nghiên cứu và các hoạt động kết nối người học với môi trường làm việc. Doanh nghiệp có thể chia sẻ bài toán thực tế, còn đội ngũ giảng viên và sinh viên đóng góp góc nhìn học thuật cùng những đề xuất mới. Quá trình phối hợp giúp hai bên hiểu rõ hơn nhu cầu, thế mạnh và cách thức đồng hành lâu dài. Đây cũng là một hướng để tri thức được lan tỏa rộng hơn và tạo giá trị thiết thực cho xã hội.',
    ),
    _NewsArticle(
      category: 'TUYỂN SINH & HƯỚNG NGHIỆP',
      title: 'Sinh viên UEH trải nghiệm học tập gắn liền với thực tiễn nghề nghiệp',
      imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=900&q=85',
      content: 'Thông qua dự án và tình huống thực tế, sinh viên có cơ hội vận dụng kiến thức chuyên môn, làm việc nhóm và định hình năng lực nghề nghiệp tương lai. Trong quá trình học, người học được khuyến khích chủ động tìm thông tin, phân tích dữ liệu và trình bày phương án giải quyết vấn đề. Việc phối hợp với bạn học giúp rèn luyện khả năng lắng nghe, phân chia công việc và cùng chịu trách nhiệm về kết quả. Những trải nghiệm này giúp sinh viên nhận ra kiến thức nào cần tiếp tục củng cố và kỹ năng nào cần phát triển thêm. Từ đó, mỗi người có thể xây dựng định hướng nghề nghiệp phù hợp hơn với sở trường và mục tiêu của mình.',
    ),
  ];

  static const _allArticles = <_NewsArticle>[..._articles, ..._nextArticles];

  int _selectedTab = 0;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openArticle(_NewsArticle article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => _ArticleDetailScreen(article: article),
      ),
    );
  }

  void _openCategoryArticle(_NewsArticle article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => _CategoryArticleScreen(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        onItemSelected: (item) =>
            _showMessage('${item.title} đang được hoàn thiện'),
      ),
      appBar: AppBar(
        backgroundColor: _uehTeal,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Trang chủ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: _uehTeal,
        ),
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'Mở menu',
            icon: const Icon(Icons.menu, size: 27),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            onPressed: () => _showMessage('Tin tức đã được làm mới'),
            icon: const Icon(Icons.refresh, size: 27),
          ),
        ],
      ),
      body: ColoredBox(
        color: Colors.white,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const Text(
                      'Tin tức',
                      style: TextStyle(
                        color: _uehOrange,
                        fontSize: 31,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Thông tin mới nhất và kiến thức hữu ích từ UEH',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF9A9A9A), fontSize: 15),
                    ),
                    const SizedBox(height: 22),
                    _FeaturedNews(
                      onTap: () => _showMessage('Đang mở tin nổi bật'),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              sliver: SliverList.separated(
                itemCount: _articles.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemBuilder: (context, index) => _NewsTile(
                  article: _articles[index],
                  onOpenArticle: () => _openArticle(_articles[index]),
                  onOpenCategoryArticle: () =>
                      _openCategoryArticle(_articles[index]),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) {
          const labels = ['Trang chủ', 'Thông báo', 'Điểm danh', 'Tài khoản'];
          setState(() => _selectedTab = index);
          if (index != 0) _showMessage('${labels[index]} đang được hoàn thiện');
        },
      ),
    );
  }
}

class _NewsArticle {
  const _NewsArticle({
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.content,
  });

  final String category;
  final String title;
  final String imageUrl;
  final String content;
}

String _breadcrumbCategory(String category) {
  if (category == 'KHOA HỌC - GÓC NHÌN CHUYÊN GIA') return 'Khoa học';
  if (category == 'TUYỂN SINH & HƯỚNG NGHIỆP') return 'Tuyển sinh';
  if (category == 'BÁO CHÍ NÓI VỀ UEH') return 'Báo chí về UEH';
  return 'Cuộc sống UEH';
}

class _FeaturedNews extends StatelessWidget {
  const _FeaturedNews({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _featureBlueGrey,
      borderRadius: BorderRadius.circular(2),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 325,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=1200&q=90',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const ColoredBox(
                            color: Color(0xFFF1F2EF),
                            child: Center(
                              child: Icon(
                                Icons.account_balance,
                                color: _uehOrange,
                                size: 54,
                              ),
                            ),
                          ),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: ColoredBox(
                      color: _featureBlueGrey,
                      child: SizedBox.expand(),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 20,
                child: Column(
                  children: [
                    const Text(
                      'TIN TỨC NỔI BẬT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 17),
                    const Text(
                      '[UEH 50 năm] 8 giá trị được đánh thức – Nội lực UEH được tiếp nối',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsTile extends StatelessWidget {
  const _NewsTile({
    required this.article,
    required this.onOpenArticle,
    required this.onOpenCategoryArticle,
  });

  final _NewsArticle article;
  final VoidCallback onOpenArticle;
  final VoidCallback onOpenCategoryArticle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: const BorderSide(color: Color(0xFFB9B9B9), width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 178),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(19, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onOpenCategoryArticle,
                child: Text(
                  article.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _uehOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              GestureDetector(
                onTap: onOpenArticle,
                child: Text(
                  article.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 11),
              Text(
                article.content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF343434),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryArticleScreen extends StatefulWidget {
  const _CategoryArticleScreen({required this.article});

  final _NewsArticle article;

  @override
  State<_CategoryArticleScreen> createState() => _CategoryArticleScreenState();
}

class _CategoryArticleScreenState extends State<_CategoryArticleScreen> {
  bool _isLoadingMore = false;
  bool _userGestureActive = false;
  bool _draggedTowardBottom = false;
  late final List<_NewsArticle> _availableArticles = _HomeScreenState
      ._allArticles
      .where((article) => article.title != widget.article.title)
      .toList();
  late final List<_NewsArticle> _loadedArticles = [widget.article];
  int _nextArticleIndex = 0;

  void _refresh() {
    setState(() {
      _loadedArticles
        ..clear()
        ..add(widget.article);
      _nextArticleIndex = 0;
      _isLoadingMore = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Nội dung đã được làm mới')));
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _userGestureActive = true;
      _draggedTowardBottom = false;
      return false;
    }

    if (_userGestureActive &&
        notification is OverscrollNotification &&
        notification.overscroll > 0) {
      _draggedTowardBottom = true;
    }

    if (notification is! ScrollEndNotification) return false;

    final reachedBottom =
        (notification.metrics.pixels > 0 || _draggedTowardBottom) &&
        notification.metrics.extentAfter <= 40;
    final shouldLoad = _userGestureActive && reachedBottom && !_isLoadingMore;
    _userGestureActive = false;
    _draggedTowardBottom = false;

    if (shouldLoad) _loadMoreArticle();
    return false;
  }

  Future<void> _loadMoreArticle() async {
    setState(() => _isLoadingMore = true);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() {
      _isLoadingMore = false;
      _loadedArticles.add(
        _availableArticles[_nextArticleIndex % _availableArticles.length],
      );
      _nextArticleIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _uehTeal,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Trang chủ'),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: _uehTeal,
        ),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh, size: 27),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const _NoStretchScrollBehavior(),
        child: NotificationListener<ScrollNotification>(
          onNotification: _handleScroll,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(24, 17, 24, 28),
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Trang chủ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.chevron_right, color: Color(0xFFB6B6B6)),
                  ),
                  Expanded(
                    child: Text(
                      _breadcrumbCategory(widget.article.category),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF35646B),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              for (var index = 0; index < _loadedArticles.length; index++)
                _CategoryArticleFrame(
                  article: _loadedArticles[index],
                  index: index,
                ),
              if (_isLoadingMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: _UehLoadingIndicator(),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tính năng đang được hoàn thiện')),
            );
          }
        },
      ),
    );
  }
}

class _CategoryArticleFrame extends StatelessWidget {
  const _CategoryArticleFrame({required this.article, required this.index});

  final _NewsArticle article;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('category-article-frame-$index'),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD5D8D5)),
        borderRadius: BorderRadius.circular(2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title,
            style: const TextStyle(
              color: Color(0xFF35646B),
              fontSize: 25,
              fontWeight: FontWeight.w800,
              height: 1.22,
            ),
          ),
          const SizedBox(height: 19),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const ColoredBox(
                            color: Color(0xFFE8EFEB),
                            child: Icon(
                              Icons.photo_outlined,
                              color: _uehOrange,
                              size: 42,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Wrap(
                      spacing: 5,
                      children: [
                        _SdgLogo(number: 4, size: 44),
                        _SdgLogo(number: 8, size: 44),
                        _SdgLogo(number: 9, size: 44),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _articleIntroText(article.content),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            article.content,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleDetailScreen extends StatefulWidget {
  const _ArticleDetailScreen({required this.article});

  final _NewsArticle article;

  @override
  State<_ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<_ArticleDetailScreen> {
  bool _isLoadingMore = false;
  bool _userGestureActive = false;
  bool _draggedTowardBottom = false;
  late final List<String> _availableContinuations = _HomeScreenState
      ._allArticles
      .where((article) => article.title != widget.article.title)
      .map((article) => article.content)
      .toList();
  final List<String> _loadedContinuations = [];
  int _nextContinuationIndex = 0;

  void _refresh() {
    setState(() {
      _loadedContinuations.clear();
      _nextContinuationIndex = 0;
      _isLoadingMore = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Nội dung đã được làm mới')));
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _userGestureActive = true;
      _draggedTowardBottom = false;
      return false;
    }

    if (_userGestureActive &&
        notification is OverscrollNotification &&
        notification.overscroll > 0) {
      _draggedTowardBottom = true;
    }

    if (notification is! ScrollEndNotification) return false;

    final reachedBottom =
        (notification.metrics.pixels > 0 || _draggedTowardBottom) &&
        notification.metrics.extentAfter <= 40;
    final shouldLoad = _userGestureActive && reachedBottom && !_isLoadingMore;
    _userGestureActive = false;
    _draggedTowardBottom = false;

    if (!shouldLoad) {
      return false;
    }
    _loadRelatedContent();
    return false;
  }

  Future<void> _loadRelatedContent() async {
    setState(() => _isLoadingMore = true);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() {
      _isLoadingMore = false;
      final content =
          _availableContinuations[_nextContinuationIndex %
              _availableContinuations.length];
      _loadedContinuations.add(content);
      _nextContinuationIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _uehTeal,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Trang chủ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: _uehTeal,
        ),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh, size: 27),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const _NoStretchScrollBehavior(),
        child: NotificationListener<ScrollNotification>(
          onNotification: _handleScroll,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(24, 17, 24, 28),
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Trang chủ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.chevron_right, color: Color(0xFFB6B6B6)),
                  ),
                  Expanded(
                    child: Text(
                      _breadcrumbCategory(article.category),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF35646B),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _ArticleContentFrame(article: article),
              for (var index = 0; index < _loadedContinuations.length; index++)
                _ArticleContinuation(
                  content: _loadedContinuations[index],
                  index: index,
                ),
              if (_isLoadingMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: _UehLoadingIndicator(),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tính năng đang được hoàn thiện')),
            );
          }
        },
      ),
    );
  }

  String _breadcrumbCategory(String category) {
    if (category == 'KHOA HỌC - GÓC NHÌN CHUYÊN GIA') return 'Khoa học';
    if (category == 'TUYỂN SINH & HƯỚNG NGHIỆP') return 'Tuyển sinh';
    if (category == 'BÁO CHÍ NÓI VỀ UEH') return 'Báo chí về UEH';
    return 'Cuộc sống UEH';
  }
}

Widget _buildBottomNavigationBar({
  required int selectedIndex,
  required ValueChanged<int> onDestinationSelected,
}) {
  return NavigationBar(
    height: 82,
    backgroundColor: _navigationBackground,
    indicatorColor: Colors.transparent,
    surfaceTintColor: _navigationBackground,
    labelTextStyle: const WidgetStatePropertyAll(
      TextStyle(color: _navigationPurpleGrey, fontSize: 12),
    ),
    selectedIndex: selectedIndex,
    onDestinationSelected: onDestinationSelected,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined, color: _navigationPurpleGrey),
        selectedIcon: Icon(Icons.home, color: _navigationPurpleGrey),
        label: 'Trang chủ',
      ),
      NavigationDestination(
        icon: Icon(Icons.notifications_none, color: _navigationPurpleGrey),
        selectedIcon: Icon(Icons.notifications, color: _navigationPurpleGrey),
        label: 'Thông báo',
      ),
      NavigationDestination(
        icon: Icon(Icons.fact_check_outlined, color: _navigationPurpleGrey),
        selectedIcon: Icon(Icons.fact_check, color: _navigationPurpleGrey),
        label: 'Điểm danh',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline, color: _navigationPurpleGrey),
        selectedIcon: Icon(Icons.person, color: _navigationPurpleGrey),
        label: 'Tài khoản',
      ),
    ],
  );
}

class _SdgLogo extends StatelessWidget {
  const _SdgLogo({required this.number, required this.size});

  final int number;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/sgds/sdg-$number.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

class _ArticleContentFrame extends StatelessWidget {
  const _ArticleContentFrame({required this.article});

  final _NewsArticle article;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('article-content-frame-0'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title,
            style: const TextStyle(
              color: Color(0xFF35646B),
              fontSize: 27,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _formatArticleDate(DateTime.now()),
            style: const TextStyle(color: Color(0xFF858B8D), fontSize: 16),
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 6,
            children: [
              _SdgLogo(number: 3, size: 60),
              _SdgLogo(number: 17, size: 60),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            _articleIntroText(article.content),
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              height: 1.55,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (_articleBodyText(article.content).isNotEmpty) ...[
            const SizedBox(height: 22),
            Text(
              _articleBodyText(article.content),
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                height: 1.55,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ArticleContinuation extends StatelessWidget {
  const _ArticleContinuation({required this.content, required this.index});

  final String content;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('article-continuation-$index'),
      margin: const EdgeInsets.only(top: 22),
      child: Text(
        content,
        textAlign: TextAlign.justify,
        style: const TextStyle(color: Colors.black, fontSize: 18, height: 1.55),
      ),
    );
  }
}

class _UehLoadingIndicator extends StatefulWidget {
  const _UehLoadingIndicator();

  @override
  State<_UehLoadingIndicator> createState() => _UehLoadingIndicatorState();
}

class _UehLoadingIndicatorState extends State<_UehLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 900),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: Center(
        child: RotationTransition(
          turns: _controller,
          child: const CustomPaint(
            size: Size.square(44),
            painter: _LoadingSpinnerPainter(),
          ),
        ),
      ),
    );
  }
}

class _LoadingSpinnerPainter extends CustomPainter {
  const _LoadingSpinnerPainter();

  static const _colors = [
    Color(0xFF454545),
    Color(0xFF555555),
    Color(0xFF666666),
    Color(0xFF777777),
    Color(0xFF888888),
    Color(0xFF999999),
    Color(0xFFAAAAAA),
    Color(0xFFBBBBBB),
    Color(0xFFCCCCCC),
    Color(0xFFD5D5D5),
    Color(0xFFBBBBBB),
    Color(0xFF999999),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final dimension = size.shortestSide;
    final barWidth = dimension * 0.08;
    final barHeight = dimension * 0.15;
    final radius = dimension * 0.39;
    final center = Offset(size.width / 2, size.height / 2);

    for (var index = 0; index < _colors.length; index++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(index * 2 * math.pi / _colors.length);
      final bar = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(0, -radius),
          width: barWidth,
          height: barHeight,
        ),
        Radius.circular(barWidth / 2),
      );
      canvas.drawRRect(bar, Paint()..color = _colors[index]);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _LoadingSpinnerPainter oldDelegate) => false;
}

class _NoStretchScrollBehavior extends MaterialScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}

String _articleIntroText(String content) {
  final end = content.indexOf('. ');
  return end < 0 ? content : content.substring(0, end + 1);
}

String _articleBodyText(String content) {
  final end = content.indexOf('. ');
  return end < 0 ? '' : content.substring(end + 2).trim();
}

String _formatArticleDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day tháng $month năm ${date.year}';
}
