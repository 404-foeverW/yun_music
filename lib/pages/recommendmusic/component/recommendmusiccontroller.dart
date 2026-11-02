// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class RecommendMusicController extends SliverPersistentHeaderDelegate {
  double contentHeight = 50;
  final double devicewidth;
  final List<singleMusic> musicList;
  RecommendMusicController({
    required this.devicewidth,
    required this.musicList,
  });

  final player = Get.find<MusicPlayer>();

  SvgPicture refreshicon = SvgPicture.asset(
    'lib/assets/icon/refresh1.svg',
    width: 25,
    height: 25,
  );

  SvgPicture selectlisticon = SvgPicture.asset(
    'lib/assets/icon/select_list.svg',
    width: 25,
    height: 25,
  );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      width: devicewidth,
      height: contentHeight,
      color: Color.fromRGBO(255, 255, 255, 1),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flex(
            direction: Axis.horizontal,
            spacing: 10,
            children: [
              GestureDetector(
                onTap: () async {
                  player.setMusicOrigin('每日推荐');
                  final String jsonStr = await rootBundle.loadString('lib/assets/localmusic/music.json');
                  List<SongBrief> list = [];
                  for (var i = 0; i < musicList.length; i++) {
                    list.add(
                      SongBrief(
                        id: musicList[i].id,
                        title: musicList[i].name,
                        artistid: musicList[i].artists.id.toString(),
                        artist: musicList[i].artists.name,
                        coverUrl: musicList[i].picUrl,
                        fee: musicList[i].fee,
                        pop: musicList[i].pop,
                        mvid: musicList[i].mvid,
                        duration: Duration(milliseconds: musicList[i].dt),
                      ),
                    );
                  }
                  print(list);
                  await player.setPlaylist(
                    sourceType: AudioSourceType.local,
                    playlist: list,
                    resolver: (song, {int index = 0}) async {
                      final Map<String, dynamic> json = jsonDecode(jsonStr) as Map<String, dynamic>;
                      String url;
                      if(index >= json['musicArr'].length) {
                        num targetIndex = index % json['musicArr'].length;
                        url = json['musicArr'][targetIndex - 1];
                      }else {
                        url = json['musicArr'][index];
                      }
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
                },
                child: Icon(
                  CupertinoIcons.arrowtriangle_right_circle_fill,
                  color: Colors.red,
                  size: 30,
                )
              ),
              Text(
                '播放全部',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            spacing: 30,
            children: [
              refreshicon,
              selectlisticon,
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => contentHeight;

  @override
  double get minExtent => contentHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
