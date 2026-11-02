import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:yun_music/api/playlist.dart';
import 'package:yun_music/components/CustomLoading.dart';
import 'package:yun_music/components/playlistdetail.dart';
import 'package:yun_music/pages/album/components/headerControllPart.dart';
import 'package:yun_music/pages/album/components/headerPart.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/viewmodel/index.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final double minExtentHeight = 85;
  late final PlayMusicListConfig config;

  late final String id; 
  late final AlbumDetail albumInfo;
  Future<void> _fetchAlbum() async {
    AlbumDetail detail = await getAlbumDetailInfo(id);
    albumInfo = detail;
  }

  final deciveInfo = Get.find<DeviceInfoService>();
  bool _initialized = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Map<String, dynamic> params = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (_initialized) return; // 只执行一次
    id = params['id'] ?? '';
    await _fetchAlbum();

    config = PlayMusicListConfig(
      title: albumInfo.album.name, 
      headerPart: Headerpart(
        albumInfo: albumInfo, 
        statusBarHeight: deciveInfo.statusBarHeight,
        minExtentHeight: minExtentHeight,
        deviceHeight: deciveInfo.height,
        devicewidth: deciveInfo.width,
      ), 
      headerControllerPart: Headercontrollpart(
        minExtentHeight: minExtentHeight - 18,
        musicList: albumInfo.songs, 
      ), 
      musicList: albumInfo.songs,
      showMusicImg: false,
      showRank: true
    );
    _initialized = true;
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