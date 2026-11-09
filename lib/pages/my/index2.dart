// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/tabbar.dart';
import 'package:yun_music/pages/home/components/userInfoDrawer.dart';
import 'package:yun_music/pages/my/components/cateContent.dart';
import 'package:yun_music/pages/my/components/header.dart';
import 'package:yun_music/pages/my/components/infocate2.dart';
import 'package:yun_music/pages/my/components/listview.dart';
import 'package:yun_music/pages/my/components/userinfo.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/store/musicplay.dart';

enum ListStructure {
  defaultWidget,
  listItem,
  operatorWidgets,
  recommendWidget,
  rencentlistWidget,
  noticWidget,
}

class Cate {
  String title;
  String? iconPath;
  bool? isShowNotic;
  int? noticNum;
  // 过滤器属性
  List<int> filterType;
  List<Cate>? children; // 子分类
  Widget Function(List<CateInfo>, Cate, {List<CateInfo> rencentlist, List<CateInfo> recommendlist})? listView;
  PageController? innerController;
  List<ListStructure> listStructure;

  Cate({
    required this.title,
    this.listView,
    this.iconPath,
    this.isShowNotic,
    this.noticNum,
    this.children,
    this.innerController,
    this.listStructure = const [ListStructure.listItem],
    this.filterType = const [0],
  });
}

class MyPageT extends StatefulWidget {
  const MyPageT({super.key});

  @override
  State<MyPageT> createState() => _MyPageTState();
}

class _MyPageTState extends State<MyPageT> {
  final player = Get.find<MusicPlayer>(); //获取播放器实例
  final deviceInfo = Get.find<DeviceInfoService>(); //获取设备信息

  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> _isPinnedNotifier = ValueNotifier(false);
  void scrollFunc() {
    final pinned =
        scrollController.offset >= minExtentHeight + deviceInfo.statusBarHeight;
    // print(pinned);
    if (pinned != _isPinnedNotifier.value) {
      setState(() => _isPinnedNotifier.value = pinned);
    }
  }

  final double minExtentHeight = 85;

  final GlobalKey key = GlobalKey();
  late final double topDistance; // 头部距离顶部的距离
  void _getTopDistance() {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset position = renderBox.localToGlobal(Offset.zero);
    topDistance = position.dy;
  }

  RxInt currentIndex = 0.obs;
  RxInt subCurrentIndex = 0.obs;
  void setCurrentIndex(int index) {
    if (index < 0 || index >= cateList.length) return;
    currentIndex.value = index;
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    // createNewPageController();
    // setState(() {
    //   currentIndex.value = index;
    // });
  }

  bool _isSubAnimatingPage = false;
  void setSubCurrentIndex(int index) {
    final children = cateList[currentIndex.value].children;
    if (children == null || index < 0 || index >= children.length) return;
    if (subCurrentIndex.value == index) return;
    subCurrentIndex.value = index;
    _isSubAnimatingPage = true;
    cateList[currentIndex.value].innerController!.animateToPage(index,duration: const Duration(milliseconds: 300),
      curve: Curves.linear,).then((_) {
        _isSubAnimatingPage = false;
      });
    // _innerController.jumpToPage(index);
    // setState(() {
    //   subCurrentIndex.value = index;
    //   print(1);
    // });
  }

  // void createNewPageController() {
  //   _innerController.dispose();
  //   _innerController = PageController(initialPage: subCurrentIndex.value);
  // }

  List<Cate> cateList = [
    Cate(
      title: '音乐',
      children: [
        Cate(
          title: '近期', 
          iconPath: 'lib/assets/icon/lock.svg', 
          filterType: [0, 1],
          listStructure: const [ListStructure.defaultWidget, ListStructure.listItem, ListStructure.operatorWidgets, ListStructure.recommendWidget, ListStructure.noticWidget]
        ),
        Cate(
          title: '创建', 
          noticNum: 3, 
          isShowNotic: true,
          filterType: [1],
          listStructure: const [ListStructure.defaultWidget, ListStructure.listItem, ListStructure.operatorWidgets]
        ),
        Cate(
          title: '收藏', 
          noticNum: 30, 
          isShowNotic: true,
          filterType: [0],
          listStructure: const [ListStructure.listItem]
        ),
      ],
      innerController: PageController(),
      listView: (
        List<CateInfo> list, 
        Cate item,
        {
          List<CateInfo> rencentlist = const [],
          List<CateInfo> recommendlist = const []
        }
      ) => CateInfoListView(
        listViewItem: ListViewItem(
          item: item,
          list: list,
          recentList: rencentlist,
          recommendList: recommendlist,
          requestApi: getRencentInfo,
          params: {'type': 0},
          cateType: 0,
          customButton: SvgPicture.asset(
            'lib/assets/icon/listdot.svg',
            width: 20,
            height: 20,
          ),
          onTap: () {},
          btnTap: () {},
          defaultWidget: DefaultWidget(
            picUrl: 'http://p2.music.126.net/ePvxkY3op1VeUoWWB2W_BQ==/109951172387753409.jpg?param=130y130',
            title: '我喜欢的音乐',
            overlay: SvgPicture.asset(
              'lib/assets/icon/aixin.svg',
              width: 35,
              height: 35,
              color: Colors.white,
            ),
            subTitle: Text(
              '161首 * 1216次播放',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            customButton: HeartBeat(),
          ),
          operatorWidgets: [
            OperatorWidget(
              icon: Icon(CupertinoIcons.chart_bar_square_fill, color: const Color.fromARGB(255, 158, 157, 157)),
              title: '听歌排行',
              subTitle: '累计听歌1123首歌',
              onTap: () {},
            ),
            OperatorWidget(
              icon: Icon(CupertinoIcons.plus, size: 20, color: const Color.fromARGB(255, 158, 157, 157)),
              title: '新建歌单',
              onTap: () {},
            ),
            OperatorWidget(
              icon: SvgPicture.asset('lib/assets/icon/daoru.svg', width: 20, height: 20, color: const Color.fromARGB(255, 158, 157, 157)),
              title: '导入外部歌单',
              subTitle: '轻松导入其他APP里的歌单',
              onTap: () {},
            ),
          ],
        ),
      ),
    ),
    Cate(
      title: '播客',
      children: [
        Cate(title: '全部', noticNum: 0, isShowNotic: true),
        Cate(title: '播客', noticNum: 3, isShowNotic: true),
        Cate(title: '有声书', noticNum: 30, isShowNotic: true),
      ],
      innerController: PageController(),
      listView: (
        List<CateInfo> list, 
        Cate item,
        {List<CateInfo> rencentlist = const [], List<CateInfo> recommendlist = const []}
      ) => CateInfoListView(
        listViewItem: ListViewItem(
          item: item,
          list: list,
          recentList: rencentlist,
          recommendList: recommendlist,
          requestApi: getRencentInfo,
          params: {'type': 0},
          cateType: 0,
          customButton: SvgPicture.asset(
            'lib/assets/icon/listdot.svg',
            width: 20,
            height: 20,
          ),
          onTap: () {},
          btnTap: () {},
          defaultWidget: DefaultWidget(
            picUrl: 'http://p2.music.126.net/ePvxkY3op1VeUoWWB2W_BQ==/109951172387753409.jpg?param=130y130',
            title: '我喜欢的音乐',
            overlay: SvgPicture.asset(
              'lib/assets/icon/aixin.svg',
              width: 35,
              height: 35,
              color: Colors.white,
            ),
            subTitle: Text(
              '161首 * 1216次播放',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            customButton: HeartBeat(),
          ),
          operatorWidgets: [
            OperatorWidget(
              icon: Icon(CupertinoIcons.chart_bar_square_fill, color: const Color.fromARGB(255, 158, 157, 157)),
              title: '听歌排行',
              subTitle: '累计听歌1123首歌',
              onTap: () {},
            ),
            OperatorWidget(
              icon: Icon(CupertinoIcons.plus, size: 20, color: const Color.fromARGB(255, 158, 157, 157)),
              title: '新建歌单',
              onTap: () {},
            ),
            OperatorWidget(
              icon: SvgPicture.asset('lib/assets/icon/daoru.svg', width: 20, height: 20, color: const Color.fromARGB(255, 158, 157, 157)),
              title: '导入外部歌单',
              subTitle: '轻松导入其他APP里的歌单',
              onTap: () {},
            ),
          ],
        ),
      ),
    ),
  ];

  final CarouselSliderController _controller = CarouselSliderController();
  PageController _innerController = PageController();

  @override
  void dispose() {
    scrollController.dispose();
    _isPinnedNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTopDistance();
    });

    scrollController.addListener(() => scrollFunc());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: Userinfodrawer()),
      body: Container(
        decoration: BoxDecoration(
          // color: Color.fromRGBO(50, 26, 26, 1)
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.6],
            colors: [
              Color.fromRGBO(50, 26, 26, 1),
              Color.fromRGBO(25, 27, 31, 1),
            ],
          ),
        ),
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                pinned: true,
                delegate: HeaderPart(
                  minExtentHeight: minExtentHeight,
                  statusBarHeight: deviceInfo.statusBarHeight,
                  isPinnedNotifier: _isPinnedNotifier,
                ),
              ),
              SliverToBoxAdapter(child: UserInfoBody()),
              SliverPersistentHeader(
                pinned: true,
                delegate: InfoCate(
                  currentIndex: currentIndex,
                  subCurrentIndex: subCurrentIndex,
                  onTabChange: setCurrentIndex,
                  onSubTabChange: setSubCurrentIndex,
                  minExtentHeight: minExtentHeight + 45,
                  isPinnedNotifier: _isPinnedNotifier,
                  headerKey: key,
                ),
              ),
            ];
          },
          body: Catecontent(
            carouselController: _controller,
            // innerController: _innerController,
            // minExtentHeight:
            //     deviceInfo.height -
            //     deviceInfo.statusBarHeight -
            //     (minExtentHeight + 45),
            minExtentHeight: deviceInfo.height,
            currentIndex: currentIndex,
            subCurrentIndex: subCurrentIndex,
            onTabChange: setCurrentIndex,
            onSubTabChange: setSubCurrentIndex,
            cateList: cateList,
            requestApi: getRencentInfo,
            requestRecommendApi: getRecommendInfo,
            recommendParams: {'type': 0},
            params: {'type': 0},
            isStopChange: () => !_isSubAnimatingPage,
          ),
        ),
      ),
      bottomNavigationBar: TabBarList(player: player),
    );
  }
}

Future getRencentInfo(Map<String, dynamic> params) async {
  final String jsonStr = await rootBundle.loadString(
    'lib/assets/json/cateInfoMusicList.json',
  );
  final Map<String, dynamic> json = jsonDecode(jsonStr) as Map<String, dynamic>;
  final dynamic rawData = json['data'];
  if (rawData == null || rawData is! List) {
    return []; // 或者抛异常
  }
  List<Map<String, dynamic>> list = rawData
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
  List<CateInfo> data = list.map((e) => CateInfo.fromJson(e)).toList();
  return data;
}
Future getRecommendInfo(Map<String, dynamic> params) async {
  final String jsonStr = await rootBundle.loadString(
    'lib/assets/json/cateInfoMusicList.json',
  );
  final Map<String, dynamic> json = jsonDecode(jsonStr) as Map<String, dynamic>;
  final dynamic rawData = json['data'];
  if (rawData == null || rawData is! List) {
    return []; // 或者抛异常
  }
  List<Map<String, dynamic>> list = rawData
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
  List<CateInfo> data = list.map((e) => CateInfo.fromJson(e)).toList();
  return data;
}

class HeartBeat extends StatefulWidget {
  const HeartBeat({super.key});

  @override
  State<HeartBeat> createState() => _HeartBeatState();
}

class _HeartBeatState extends State<HeartBeat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(245, 245, 245, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Flex(
        spacing: 5,
        direction: Axis.horizontal,
        children: [
          SvgPicture.asset(
            'lib/assets/icon/uniE085.svg',
            width: 15,
            height: 15,
          ),
          Text('心动模式', style: TextStyle(color: Colors.black, fontSize: 12)),
        ],
      ),
    );
  }
}
