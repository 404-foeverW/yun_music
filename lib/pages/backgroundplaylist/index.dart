// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/api/playlist.dart';
import 'package:yun_music/components/CustomLoading.dart';
import 'package:yun_music/components/playlistdetail.dart';
import 'package:yun_music/constant/index.dart';
import 'package:yun_music/pages/backgroundplaylist/components/HeaderControllerPart.dart';
import 'package:yun_music/pages/backgroundplaylist/components/headerPart.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/utils/index.dart';
import 'package:yun_music/viewmodel/index.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class BackgroundPlaylistPage extends StatefulWidget {
  const BackgroundPlaylistPage({super.key});

  @override
  State<BackgroundPlaylistPage> createState() => _BackgroundPlaylistPageState();
}

class _BackgroundPlaylistPageState extends State<BackgroundPlaylistPage> {
  late final PlayMusicListConfig playMusicListConfig;
  late Map<String, dynamic>? args;
  late String id;
  bool _initialized = false;
  final double contentHeight = 85;
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> _isPinnedNotifier = ValueNotifier(false);
  final deviceInfo = Get.find<DeviceInfoService>();
  void scrollFunc() {
    final pinned = scrollController.offset >= deviceInfo.height * 0.55 - 10;
    print(pinned);
    if (pinned != _isPinnedNotifier.value) {
      setState(() => _isPinnedNotifier.value = pinned);
    }
  }

  late PlayList playListInfo;
  Future<void> getPlayList(String id) async {
    playListInfo = await getPlayListDetailInfo(id);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // final deviceInfo = Get.find<DeviceInfoService>();
    print(deviceInfo.height * 0.55);
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (_initialized) return; // 只执行一次
    id = args!['id'];
    await getPlayList(id);

    print(playListInfo.tracks[0].picUrl);
    List<Color> colors = playListInfo.tags.map((item) {
      List<TermColor> list = getCateColors(cate: item);
      String hex = list[0].hex;
      return hexToColor(hex);
    }).toList();

    // Color distinguishingColor = generateSimilarColor(colors.last, index: 1);
    Color distinguishingColor = darken(colors.last, 0.2);

    playMusicListConfig = PlayMusicListConfig(
      title: playListInfo.name,
      headerPart: HeaderPart(
        statusBarHeight: deviceInfo.statusBarHeight,
        contentHeight: contentHeight,
        deviceHeight: deviceInfo.height,
        devicewidth: deviceInfo.width,
        loadingColor: Colors.grey,
        playListInfo: playListInfo,
        bgColor: colors.first,
      ),
      headerControllerPart: HeaderControllerPart(
        devicewidth: deviceInfo.width,
        musicList: playListInfo.tracks,
        bgColor: colors.first,
        isPinnedNotifier: _isPinnedNotifier,
      ),
      musicList: playListInfo.tracks,
      isTransparent: false,
      bgGradient: colors,
      playerStyle: PlayerStyle(
        musicNameColor: Colors.white,
        artistColor: Colors.grey,
        iconColor: Colors.white,
        // bgColor: colors[colors.length - 1].withBlue((colors[colors.length - 1].b + 5).toInt()),
        // shadowColor: colors[colors.length - 1],
        bgColor: distinguishingColor,
        shadowColor: distinguishingColor.withValues(alpha: 0.4),
        progressColor: Colors.black,
        progressBgColor: Colors.grey.shade300,
        listIconColor: 'white',
      ),
      musicListStyle: MusicListStyle(
        musicNameColor: Colors.white,
        artistColor: const Color.fromARGB(255, 198, 197, 197),
        splashColor: const Color.fromARGB(255, 202, 194, 194),
        highlightColor: const Color.fromARGB(255, 202, 194, 194),
      ),
      loadingColor: Colors.grey,
    );
    await Future.delayed(Duration(milliseconds: 3000), () {});
    _initialized = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // if(!_initialized) return CustomLoading(backgroundColor: playMusicListConfig.loadingColor);
    if (!_initialized) return CustomLoading(backgroundColor: Colors.grey);
    return Scaffold(
      body: Container(
        // padding: const EdgeInsets.all(10),
        // decoration: BoxDecoration(color: Colors.white),
        child: PlayListDetail(config: playMusicListConfig, scrollController: scrollController, scrollCallback: scrollFunc),
      ),
    );
  }
}
