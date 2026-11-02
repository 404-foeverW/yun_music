import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class Controllerpart extends SliverPersistentHeaderDelegate {
  final double minExtentHeight;
  final List<singleMusic> musicList;
  final String title;
  final player = Get.find<MusicPlayer>();

  Controllerpart({
    required this.minExtentHeight,
    required this.musicList,
    required this.title,
  });

  @override
  double get maxExtent => minExtentHeight;

  @override
  double get minExtent => minExtentHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

   @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: minExtentHeight,
      // color: Color.fromRGBO(255, 255, 255, 1),
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )
      ),
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
                  player.setMusicOrigin('网易云$title');
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
                '播放全部 (${musicList.length})首',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            spacing: 30,
            children: [
              SvgPicture.asset('lib/assets/icon/uniE085.svg', width: 20, height: 20),
              SvgPicture.asset('lib/assets/icon/xiazai2.svg', width: 20, height: 20),
              SvgPicture.asset('lib/assets/icon/select_list.svg', width: 20, height: 20),
            ],
          ),
        ],
      )
    );
  }
  
}