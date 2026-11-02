// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:yun_music/api/playlist.dart';
import 'package:yun_music/components/tabbar.dart' hide MusicPlayer;
import 'package:yun_music/pages/home/components/comprehensive.dart';
import 'package:yun_music/pages/home/components/header.dart';
import 'package:yun_music/pages/home/components/netfriendplaylist.dart';
import 'package:yun_music/pages/home/components/rankinglist.dart';
import 'package:yun_music/pages/home/components/recommenmusic.dart';
import 'package:yun_music/pages/home/components/userInfoDrawer.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/utils/index.dart';
import 'package:yun_music/viewmodel/index.dart';
import 'package:yun_music/viewmodel/playlist.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<HotPlayListCate> hotPlayListCates = [];
  Future<void> _getHotPlayListCates() async {
    hotPlayListCates = await getHotPlayList();
  }

  List<HotPlayListCate> tags = [];
  int maxTagsNum = 5;
  void setTages() {
    Random random = Random();
    Set<int> uniqueNumbers = {};
    int min = 1;
    while(uniqueNumbers.length < maxTagsNum) {
      uniqueNumbers.add(min + random.nextInt(maxTagsNum - min + 1));
    }
    List<int> result = uniqueNumbers.toList();
    for (var i = 0; i < result.length; i++) {
      tags.add(hotPlayListCates[result[i]]);
    }
  }
  List<String> getTags(int startIndex, {int num = 3}) {
    if(tags.isNotEmpty) {
      return tags.sublist(startIndex, startIndex + num).map((e) => e.name).toList();
    }
    return [];
  }

  final player = Get.find<MusicPlayer>();//获取播放器实例
  Duration fristDuration = Duration.zero;
  Future<void> getmusic(List<SongBrief> musics, {String title = ''}) async {
    player.setMusicOrigin(title);
    final String jsonStr = await rootBundle.loadString('lib/assets/localmusic/music.json');
    // print(jsonStr);
    fristDuration = await player.setPlaylist(
      playlist: musics,
      sourceType: AudioSourceType.local,
      resolver: (song, {int index = 0}) async {
        // print(song);
        final Map<String, dynamic> json = jsonDecode(jsonStr) as Map<String, dynamic>;
        // print(json);
        // print(song.id.toString());
        String url;
        if(index >= json['musicArr'].length) {
          num targetIndex = index % json['musicArr'].length;
          url = json['musicArr'][targetIndex - 1];
        }else {
          url = json['musicArr'][index];
        }
        // url = json[song.id.toString()];

        print(url);

        // String url = await getSongDetail(song.id);

        // final outerUrl = 'https://music.163.com/song/media/outer/url?id=${song.id}.mp3';
        // final url = await resolveDirectAudioUrl(outerUrl);
        
        // if (url == null || url.isEmpty) {
        //   throw Exception('无法解析歌曲 ${song.id} 的播放地址');
        // }
        return Song(
          id: song.id,
          title: song.title,
          artistid: song.artistid,
          artist: song.artist,
          url: url,
          coverUrl: song.coverUrl,
          duration: song.duration,
        );
      },
      autoPlay: true,
    );
    setState(() {});
  }

  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _getHotPlayListCates();
      setTages();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    DeviceInfo deviceInfo = getDeviceInfo(context);
    final double statusBarHeight = deviceInfo.statusBarHeight; // 状态栏高度
    final double contentHeight = 110; // 内容区高度
    final Color backgroundColor = Colors.white;
    return Scaffold(
      key: _key,
      drawer: Drawer(
        child: Userinfodrawer()
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: RefreshIndicator(
          onRefresh: () async {},
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            child: CustomScrollView(slivers: [
              SliverPersistentHeader(
                delegate: HeaderMenu(
                  statusBarHeight: statusBarHeight, 
                  contentHeight: contentHeight, 
                  backgroundColor: backgroundColor,
                  scaffoldkey: _key
                ),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: ComprehensivePlayList(tags: getTags(0, num: 3), getmusic: getmusic)
              ),
              // ============================================================
              // 接口需要验证登录，需要修改
              // ============================================================
              SliverToBoxAdapter(
                child: netFriendPlaylist(getmusic: getmusic)
              ),
              SliverToBoxAdapter(
                child: Recommenmusic()
              ),
              SliverToBoxAdapter(
                child: RankingList()
              )
            ]),
          ),
        ),
      ),
      bottomNavigationBar: TabBarList(player: player, fristDuration: fristDuration),
    );
  }
}
