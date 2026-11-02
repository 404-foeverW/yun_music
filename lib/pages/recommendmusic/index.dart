// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/playlistdetail.dart';
import 'package:yun_music/pages/recommendmusic/component/recommendmusiccontroller.dart';
import 'package:yun_music/pages/recommendmusic/component/recommendmusicheader.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/viewmodel/index.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class RecommendMusicPage extends StatefulWidget {
  const RecommendMusicPage({super.key});

  @override
  State<RecommendMusicPage> createState() => _RecommendMusicPageState();
}

class _RecommendMusicPageState extends State<RecommendMusicPage> {
  late final PlayMusicListConfig playMusicListConfig;
  final double contentHeight = 95;
  late String? id;
  late final List<singleMusic>? musicList;
  late Map<String, dynamic>? args;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (_initialized) return;   // ✅ 只执行一次
    _initialized = true;
    id = args?['id'];
    musicList = args?['musicList'];
    print('widget.musicList');
    print(musicList);
    final List<singleMusic> list = musicList ?? [];
    final deviceInfo = Get.find<DeviceInfoService>();
    playMusicListConfig = PlayMusicListConfig(
      title: '',
      headerPart: RecommendMusicHeader(
        statusBarHeight: deviceInfo.statusBarHeight,
        contentHeight: contentHeight,
        deviceHeight: deviceInfo.height,
        devicewidth: deviceInfo.width,
      ),
      headerControllerPart: RecommendMusicController(devicewidth: deviceInfo.width, musicList: list),
      tipPart: RecommendMusiTip(),
      musicList: list,
      isTransparent: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white),
        child: PlayListDetail(config: playMusicListConfig),
      ),
    );
  }
}


// 提示组件
class RecommendMusiTip extends StatefulWidget {
  const RecommendMusiTip({super.key});

  @override
  State<RecommendMusiTip> createState() =>
      _RecommendMusiTipState();
}

class _RecommendMusiTipState extends State<RecommendMusiTip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
      child: Flex(direction: Axis.horizontal, spacing: 5, children: [
        Icon(Icons.error_outline_outlined, color: Colors.grey, size: 18,),
        Text('根据你的音乐口味生成，每日6:00更新', style: TextStyle(color: Colors.grey, fontSize: 15),)
      ])
    );
  }
}
