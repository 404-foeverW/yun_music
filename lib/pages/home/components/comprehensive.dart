// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:yun_music/api/playlist.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class ComprehensivePlayList extends StatefulWidget {
  final List<String> tags;
  final Function(List<SongBrief> musics, {String title}) getmusic;
  const ComprehensivePlayList({
    super.key,
    this.tags = const [],
    required this.getmusic,
  });

  @override
  State<ComprehensivePlayList> createState() => _ComprehensivePlayListState();
}

class _ComprehensivePlayListState extends State<ComprehensivePlayList> {
  // List<Map<String, dynamic>> _list = [];
  // final List<String> tags = ['经典', '华语', '欧美'];
  // final List<String> tags = [];
  List<RecommendPlayList> recommendHightPlayList = [];
  Future<void> _getHightPlayList() async {
    // for (var i = 0; i < tags.length; i++) {
    //   await _getRecommendHightPlayList(1, tags[i]);
    // }
    for (var i = 0; i < widget.tags.length; i++) {
      await _getRecommendHightPlayList(1, widget.tags[i]);
    }
  }

  Future<void> _getRecommendHightPlayList(int page, String cat) async {
    List<RecommendPlayList> list = await getHightQualityPlayList(
      page: page,
      tag: cat,
    );
    recommendHightPlayList.add(list[0]);
  }

  final CommonData commonData = Get.put(CommonData());
  RecommendPlayList everyDayRecommendPlay = RecommendPlayList.fromJson({});
  List<RecommendMusicNL> recommendMusicNL = [];
  Future<void> _getRecommendMusic() async {
    recommendMusicNL = await getRecommendMusicNL();
    commonData.setRecommendMusicNL(recommendMusicNL);
    // print('实际数据');
    // print(recommendMusicNL[0].picUrl);
    if (recommendMusicNL.isNotEmpty) {
      everyDayRecommendPlay = RecommendPlayList.fromJson({
        "name": "每日推荐",
        "id": '-1',
        "coverImgUrl": recommendMusicNL[0].picUrl,
        "tags": [],
        "copywriter": "今日限定好歌推荐",
        "type": "0",
      });
    }
  }

  void playMusic() {
    List<SongBrief> list = [];
    for (var i = 0; i < recommendMusicNL.length; i++) {
      list.add(
        SongBrief(
          id: recommendMusicNL[i].id.toString(),
          title: recommendMusicNL[i].name,
          artistid: recommendMusicNL[i].artists.id.toString(),
          artist: recommendMusicNL[i].artists.name,
          coverUrl: recommendMusicNL[i].picUrl,
          fee: recommendMusicNL[i].fee,
          pop: recommendMusicNL[i].pop,
          mvid: recommendMusicNL[i].mvid,
          duration: Duration(milliseconds: recommendMusicNL[i].duration),
        ),
      );
    }
    widget.getmusic(list, title: '每日推荐');
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _getRecommendMusic();
      await _getHightPlayList();
      print('重写绘制');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 230,
      padding: EdgeInsets.all(10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (everyDayRecommendPlay.name.isNotEmpty)
            GestureDetector(
              onTap: () {
                List<singleMusic> list = [];
                for (var i = 0; i < recommendMusicNL.length; i++) {
                  list.add(
                    singleMusic(
                      id: recommendMusicNL[i].id.toString(),
                      name: recommendMusicNL[i].name,
                      artists: recommendMusicNL[i].artists,
                      album: recommendMusicNL[i].album,
                      fee: recommendMusicNL[i].fee,
                      pop: recommendMusicNL[i].pop,
                      mvid: recommendMusicNL[i].mvid,
                      dt: recommendMusicNL[i].duration,
                      picUrl: recommendMusicNL[i].picUrl,
                    ),
                  );
                }
                print('-----------list----------');
                print(list);
                Navigator.pushNamed(context, '/everdrecommendMusicPage', arguments: {
                  "musicList": list,
                });
              },
              child: PlayListBox(playitem: everyDayRecommendPlay, playMusic: playMusic)
            )
          else
            SizedBox(width: 160, height: 230),
          ...List.generate(recommendHightPlayList.length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/bgplaylist', arguments: {
                  'id': recommendHightPlayList[index].id
                });
              },
              child: PlayListBox(
                playitem: recommendHightPlayList[index],
                playMusic: playMusic,
              )
            );
          }),
        ],
      ),
    );
  }
}

class PlayListBox extends StatefulWidget {
  final RecommendPlayList playitem;
  final Function playMusic;
  const PlayListBox({
    super.key,
    required this.playitem,
    required this.playMusic,
  });

  @override
  State<PlayListBox> createState() => _PlayListBoxState();
}

class _PlayListBoxState extends State<PlayListBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 230,
      margin: EdgeInsets.only(right: 10),
      // padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
        image: widget.playitem.coverImgUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(
                  'https://images.weserv.nl/?url=${widget.playitem.coverImgUrl}',
                  headers: {
                    'Referer': 'https://music.163.com/',
                    'sec-ch-ua-platform': '"Windows"',
                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0',
                  },
                ),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          const SizedBox.expand(),
          if (widget.playitem.type == '0')
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  '免费听',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: -10,
            right: 0,
            top: 0,
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Colors.transparent, // 顶部：模糊版完全透明
                    Colors.white, // 底部：模糊版完全不透明
                  ],
                  stops: [0.35, 0.9], // 控制过渡区间
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 15),
                child: Image.network(
                  'https://images.weserv.nl/?url=${widget.playitem.coverImgUrl}',
                  fit: BoxFit.cover, // 关键：和底层用同样的 fit 和尺寸
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey[900]),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            left: 0,
            child: Container(
              // height: 80,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color.fromRGBO(255, 255, 255, 0),
                    Color.fromRGBO(212, 212, 212, .2),
                  ],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.playitem.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.playitem.copywriter,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (widget.playitem.type == '0')
                    GestureDetector(
                      onTap: () {
                        widget.playMusic();
                      },
                      child: SvgPicture.asset(
                        'lib/assets/icon/bofang2.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
