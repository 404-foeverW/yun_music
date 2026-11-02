import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/tabbar.dart';
import 'package:yun_music/pages/home/components/userInfoDrawer.dart';
import 'package:yun_music/pages/my/components/header.dart';
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

  final double minExtentHeight = 85;

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
            stops: [0.1, 0.4],
            colors: [
              Color.fromRGBO(50, 26, 26, 1),
              Color.fromRGBO(25, 27, 31, 1),
            ],
          ),
        ),
        child: CustomScrollView(slivers: [
          SliverPersistentHeader(delegate: HeaderPart(
            minExtentHeight: minExtentHeight,
            statusBarHeight: deviceInfo.statusBarHeight,
          )),
          SliverToBoxAdapter(
            child: UserInfoBody()
          )
        ]),
      ),
      bottomNavigationBar: TabBarList(player: player),
    );
  }
}
