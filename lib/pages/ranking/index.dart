// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/api/playlist.dart';
import 'package:yun_music/components/CustomLoading.dart';
import 'package:yun_music/components/playlistdetail.dart';
import 'package:yun_music/pages/ranking/components/controllerPart.dart';
import 'package:yun_music/pages/ranking/components/headerPart.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/viewmodel/index.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  Map<String, dynamic>? args;
  late final int id;
  bool _initialized = false;
  late final RankingDetail rankingDetail;
  late final PlayMusicListConfig config;
  final double minExtentHeight = 85;
  
  final deciveInfo = Get.find<DeviceInfoService>();


  Future<void> _getRankingMusicList() async {
    // 获取排行榜音乐列表
    rankingDetail = await getRankingListDetail(id.toString());
  }

  void showImgFunc(bool show) {
    setState(() {
      config.showMusicImg = show;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if(_initialized) return;
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    id = args!['id'];
    await _getRankingMusicList();
    _initialized = true;
    config = PlayMusicListConfig(
      title: rankingDetail.info.name, 
      headerPart: HeaderPart(
        minExtentHeight: minExtentHeight,
        rankingDetail: rankingDetail,
        statusBarHeight: deciveInfo.statusBarHeight,
        deviceHeight: deciveInfo.height,
        devicewidth: deciveInfo.width,
        showImgFunc: showImgFunc
      ), 
      headerControllerPart: Controllerpart(
        minExtentHeight: minExtentHeight,
        musicList: rankingDetail.songs,
        title: rankingDetail.info.name
      ), 
      musicList: rankingDetail.songs,
      showMusicImg: true,
      // showImgFunc: showImgFunc,
      showRank: true,
      showRankChange: true,
      musicListStyle: MusicListStyle(showRankStyle: true)
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return CustomLoading(backgroundColor: Colors.grey);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: PlayListDetail(config: config),
      ),
    );
  }
}