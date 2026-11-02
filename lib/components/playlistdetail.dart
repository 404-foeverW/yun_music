import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/musicplayer.dart';
import 'package:yun_music/components/singlemusicpop.dart';
import 'package:yun_music/components/tag.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/viewmodel/index.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class PlayListDetail extends StatefulWidget {
  final ScrollController? scrollController;
  final Function? scrollCallback;
  final PlayMusicListConfig config;
  const PlayListDetail({
    super.key,
    required this.config,
    this.scrollController,
    this.scrollCallback,
  });

  @override
  State<PlayListDetail> createState() => _PlayListDetailState();
}

class _PlayListDetailState extends State<PlayListDetail> {
  final player = Get.find<MusicPlayer>();
  final deviceInfo = Get.find<DeviceInfoService>();

  MusicListStyle get _liststyle =>
      widget.config.musicListStyle ?? MusicListStyle();

  @override
  void initState() {
    super.initState();
    if (widget.scrollCallback != null) {
      widget.scrollController?.addListener(() => widget.scrollCallback?.call());
    }
  }

  @override
  Widget build(BuildContext context) {
    final liststyle = _liststyle;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // stops: [0.3, 0.3],
          colors:
              widget.config.bgGradient ??
              [Colors.transparent, Colors.transparent],
        ),
      ),
      child: Stack(
        children: [
          CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              SliverPersistentHeader(
                delegate: widget.config.headerPart,
                pinned: true,
              ),
              SliverPersistentHeader(
                delegate: widget.config.headerControllerPart,
                pinned: true,
              ),
              if (widget.config.tipPart != null)
                SliverToBoxAdapter(child: widget.config.tipPart),
              SliverList(
                delegate: MusicListDelegate(
                  widget.config.musicList,
                  player,
                  height: deviceInfo.height,
                  width: deviceInfo.width,
                  liststyle: liststyle,
                  showMusicImg: widget.config.showMusicImg ?? true,
                  showRank: widget.config.showRank ?? false,
                  showRankChange: widget.config.showRankChange ?? false,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: deviceInfo.width,
              padding: EdgeInsets.only(bottom: deviceInfo.bottomSafeAreaHeight),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.3, 0.3],
                  colors: [
                    Colors.transparent,
                    // widget.config.playerStyle?.bgColor ?? Colors.white,
                    widget.config.bgGradient?.last ?? Colors.white,
                  ],
                ),
              ),
              child: MusicPlayController(
                player: player,
                playerStyle: widget.config.playerStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 歌曲列表内容
class MusicListDelegate extends SliverChildBuilderDelegate {
  final List<singleMusic> items;
  final MusicPlayer player;
  final double height;
  final double width;
  final bool showMusicImg;
  final bool showRank;
  final bool showRankChange;
  final MusicListStyle liststyle;

  MusicListDelegate(
    this.items,
    this.player, {
    required this.height,
    required this.width,
    required this.liststyle,
    this.showMusicImg = true,
    this.showRank = false,
    this.showRankChange = false,
  }) : super(
         (BuildContext context, int index) => buildPlayListDetail(
           context,
           index,
           items,
           player,
           height,
           width,
           liststyle,
           showMusicImg,
           showRank,
           showRankChange,
         ),
         childCount: items.length,
       );
}

Widget? buildPlayListDetail(
  BuildContext context,
  int index,
  List<singleMusic> items,
  MusicPlayer player,
  double height,
  double width,
  MusicListStyle liststyle,
  bool showMusicImg,
  bool showRank,
  bool showRankChange,
) {
  if (items.isEmpty) return null;
  if (index >= items.length) return null;
  SvgPicture detailicon = SvgPicture.asset(
    'lib/assets/icon/listdot.svg',
    width: 20,
    height: 20,
    color: liststyle.artistColor,
  );
  SvgPicture mvicon = SvgPicture.asset(
    'lib/assets/icon/MV.svg',
    width: 20,
    height: 20,
    color: liststyle.musicNameColor,
  );
  // String currentSongId = player.currentSong.value?.id ?? '';
  // Color selectTextColor = currentSongId == items[index].id
  //     ? Colors.red
  //     : Colors.black;
  return Obx(() {
    String currentSongId = player.currentSong.value?.id ?? '';
    Color selectTextColor = currentSongId == items[index].id
        ? Colors.red
        : liststyle.musicNameColor;
    return Container(
      // padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await player.playAt(index, autoPlay: true);
          },
          onLongPress: () {},
          splashColor: liststyle.splashColor,
          highlightColor: liststyle.highlightColor,
          child: Container(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 20,
              right: 10,
            ),
            child: Flex(
              direction: Axis.horizontal,
              spacing: 12,
              children: [
                if (showRank)
                  Container(
                    width: 33,
                    // height: 20,
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: liststyle.showRankStyle! && index <= 2 ? liststyle.topSize : liststyle.bottomSize,
                            fontWeight: liststyle.showRankStyle! && index <= 2 ? liststyle.topWeight : FontWeight.normal,
                            color: liststyle.showRankStyle! && index <= 2 ? liststyle.topColor : liststyle.artistColor,
                          ),
                        ),
                        // if(showRankChange && index <= 2)
                        // Flex(
                        //   spacing: 4,
                        //     direction: Axis.horizontal,
                        //     children: [
                        //       Icon(CupertinoIcons.triangle_fill, size: 6),
                        //       Text(
                        //         '${index + 1}',
                        //         style: TextStyle(
                        //           fontSize: 12,
                        //           color: liststyle.artistColor,
                        //         ),
                        //       ),
                        //     ],
                        //   )
                      ],
                    ),
                  ),
                if (showMusicImg)
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(5),
                  //   child: Image.network(
                  //     'https://images.weserv.nl/?url=${items[index].picUrl}',
                  //     headers: {
                  //       'Referer': 'https://music.163.com/',
                  //       'sec-ch-ua-platform': '"Windows"',
                  //       'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0',
                  //     },
                  //     width: 60,
                  //     height: 60,
                  //   ),
                  // ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: 'https://images.weserv.nl/?url=${items[index].picUrl}',
                      httpHeaders: {
                        'Referer': 'https://music.163.com/',
                        'sec-ch-ua-platform': '"Windows"',
                        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0',
                      },
                      width: 60,
                      height: 60,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      errorListener: (Object e) {
                        print(e);
                      },
                    ),
                  ),
                Expanded(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: Flex(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          direction: Axis.vertical,
                          spacing: 5,
                          children: [
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              items[index].name,
                              style: TextStyle(
                                fontSize: 16,
                                color: selectTextColor,
                              ),
                            ),
                            Flex(
                              direction: Axis.horizontal,
                              spacing: 5,
                              children: [
                                Tag(
                                  music: TagInfo(
                                    fee: items[index].fee,
                                    pop: items[index].pop,
                                  ),
                                  type: 0,
                                ),
                                Expanded(
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      // text: items[index].name,
                                      children: [
                                        if (items[index].album?.name != '')
                                          TextSpan(
                                            text:
                                                '${items[index].artists.name} - ',
                                            style: TextStyle(
                                              color: liststyle.artistColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        TextSpan(
                                          text: '${items[index].album?.name}',
                                          style: TextStyle(
                                            color: liststyle.artistColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (items[index].mvid != 0)
                        IconButton(onPressed: () {}, icon: mvicon),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SingleMusicPop(
                        music: items[index],
                        height: height,
                        currContext: context,
                        width: width,
                      ),
                    );
                  },
                  icon: detailicon,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
}
