import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class HeaderControllerPart extends SliverPersistentHeaderDelegate {
  double contentHeight = 50;
  final double devicewidth;
  final List<singleMusic> musicList;
  final Color bgColor;
  final ValueNotifier<bool> isPinnedNotifier;
  HeaderControllerPart({
    required this.devicewidth,
    required this.musicList,
    required this.bgColor,
    required this.isPinnedNotifier,
  });

  final player = Get.find<MusicPlayer>();

  SvgPicture refreshicon = SvgPicture.asset(
    'lib/assets/icon/xiazai2.svg',
    width: 25,
    height: 25,
    color: Colors.white,
  );

  SvgPicture selectlisticon = SvgPicture.asset(
    'lib/assets/icon/select_list.svg',
    width: 25,
    height: 25,
    color: Colors.white,
  );

  @override
  double get maxExtent => contentHeight;

  @override
  double get minExtent => contentHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ValueListenableBuilder(valueListenable: isPinnedNotifier, builder: (context, isPinned, _) {
      return Container(
      width: devicewidth,
      height: contentHeight,
      // color: Color.lerp(Colors.transparent, bgColor, reverseprogress),
      color: isPinned ? bgColor : Colors.transparent,
      padding: EdgeInsets.only(left: 10, right: 10),
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
                  final String jsonStr = await rootBundle.loadString(
                    'lib/assets/localmusic/music.json',
                  );
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
                      final Map<String, dynamic> json =
                          jsonDecode(jsonStr) as Map<String, dynamic>;
                      String url;
                      if (index >= json['musicArr'].length) {
                        num targetIndex = index % json['musicArr'].length;
                        url = json['musicArr'][targetIndex - 1];
                      } else {
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
                child: Stack(
                  children: [
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.arrowtriangle_right_circle_fill,
                      color: Colors.red,
                      size: 48,
                    ),
                  ],
                ),
              ),
              Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '播放全部',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '共${musicList.length}首',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 198, 197, 197),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            spacing: 20,
            children: [refreshicon, selectlisticon],
          ),
        ],
      ),
    );
    });
  }
}
