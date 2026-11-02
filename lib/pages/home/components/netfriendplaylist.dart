// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yun_music/api/playlist.dart';
import 'package:yun_music/pages/home/components/verifywebviewpage.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/viewmodel/error.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class netFriendPlaylist extends StatefulWidget {
  final Function(List<SongBrief> musics, {String title}) getmusic;
  const netFriendPlaylist({super.key, required this.getmusic});

  @override
  State<netFriendPlaylist> createState() => _netFriendPlaylistState();
}

class _netFriendPlaylistState extends State<netFriendPlaylist> {
  List<RecommendPlayList> recommendHightPlayList = [];
  int limit = 5;
  int offset = 0;

  Future<void> _getNetFriend(int page, {String order = 'hot'}) async {
    try {
      List<RecommendPlayList> list = await getNetFriendPlayList(
        page: page,
        order: order,
      );
      recommendHightPlayList = list;
    } catch (e) {
      final dynamic res = (e as DioException).response?.data;
      handleVerifyResponse(res['data']);
    }
  }

  Future<void> playmucis(String id) async {
    try {
      print(id);
      List<singleMusic> list = await getAlbumDetail(id);
      print(list);
      List<SongBrief> playlist = [];
      for (var i = 0; i < list.length; i++) {
        playlist.add(
          SongBrief(
            id: list[i].id.toString(),
            title: list[i].name,
            artistid: list[i].artists.id.toString(),
            artist: list[i].artists.name,
            coverUrl: list[i].picUrl,
            fee: list[i].fee,
            pop: list[i].pop,
            mvid: list[i].mvid,
            duration: Duration(milliseconds: list[i].dt),
          ),
        );
      }
      widget.getmusic(playlist);
    } catch (e) {
      print(e);
      final String? msg = (e as DioException).message;
      print(msg);
    }
  }

  Future<void> handleVerifyResponse(Map<String, dynamic> res) async {
    print('验证操作');
    Verify verify = Verify.fromJson(res);
    final success = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => VerifyWebViewPage(verifyinfo: verify)),
    );
    if (success == true) {
      // 验证成功，继续后续操作，比如重新请求原接口
      print('验证成功');
    } else {
      print('用户取消或验证失败');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _getNetFriend(limit);
      print('重写绘制');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '云村推荐专辑',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Icon(CupertinoIcons.chevron_forward),
            ],
          ),
          Container(
            // width: 160,
            height: 305,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              shrinkWrap: true,  
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(recommendHightPlayList.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/ablum',
                        arguments: {'id': recommendHightPlayList[index].id},
                      );
                    },
                    child: PlayListBox(
                      playitem: recommendHightPlayList[index],
                      index: index,
                      playmucis: playmucis,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlayListBox extends StatefulWidget {
  final RecommendPlayList playitem;
  final int index;
  final Function(String id) playmucis;
  const PlayListBox({
    super.key,
    required this.playitem,
    required this.index,
    required this.playmucis,
  });

  @override
  State<PlayListBox> createState() => _PlayListBoxState();
}

class _PlayListBoxState extends State<PlayListBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 160,
          height: 240,
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
              Positioned(
                right: 0,
                bottom: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.playmucis(widget.playitem.id);
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
        ),
        Container(
          width: 160,
          child: Text(
            widget.playitem.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
