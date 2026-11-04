import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/tabbar.dart';
import 'package:yun_music/pages/home/components/userInfoDrawer.dart';
import 'package:yun_music/pages/my/components/header.dart';
import 'package:yun_music/pages/my/components/infocate.dart';
import 'package:yun_music/pages/my/components/userinfo.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/store/musicplay.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
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
                headerKey: key,
                isPinnedNotifier: _isPinnedNotifier,
                minExtentHeight:
                    deviceInfo.height -
                    deviceInfo.statusBarHeight -
                    minExtentHeight,
                // topDistance: topDistance,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TabBarList(player: player),
    );
  }
}
