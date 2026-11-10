import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/tabbar.dart';
import 'package:yun_music/pages/home/components/userInfoDrawer.dart';
import 'package:yun_music/pages/searchpage/components/header.dart';
import 'package:yun_music/pages/searchpage/components/searchcate.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/store/musicplay.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final player = Get.find<MusicPlayer>(); //获取播放器实例
  final _key = GlobalKey<ScaffoldState>();
  final deviceInfo = Get.find<DeviceInfoService>();
  double contentHeight = 100;
  Duration fristDuration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Drawer(child: Userinfodrawer()),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(color: Color.fromRGBO(248, 248, 255, 1)),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: Header(
                contentHeight: contentHeight,
                paddingTop: deviceInfo.statusBarHeight,
                scaffoldkey: _key
              ),
            ),
            SliverToBoxAdapter(
              child: SearchCate(),
            )
          ],
        ),
      ),
      bottomNavigationBar: TabBarList(
        player: player,
        fristDuration: fristDuration,
      ),
    );
  }
}
