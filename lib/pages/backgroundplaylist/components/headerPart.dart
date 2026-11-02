// ignore_for_file: avoid_print

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yun_music/components/animatedFillShrinkReturn.dart';
import 'package:yun_music/utils/index.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class HeaderPart extends SliverPersistentHeaderDelegate {
  final double statusBarHeight; // 状态栏高度
  final double contentHeight; // 内容区高度
  final double deviceHeight; // 设备高度
  final double devicewidth; // 设备宽度
  final Color loadingColor;
  final PlayList playListInfo;
  final Color bgColor;

  HeaderPart({
    required this.statusBarHeight,
    required this.contentHeight,
    required this.deviceHeight,
    required this.devicewidth,
    required this.loadingColor,
    required this.playListInfo,
    required this.bgColor,
  });

  @override
  double get maxExtent => deviceHeight * 0.55;

  @override
  double get minExtent => contentHeight + 10;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final maxShrink = maxExtent - minExtent;
    final double progress = maxShrink == 0
        ? 1.0
        : (shrinkOffset / maxShrink).clamp(0.0, 1.0);
    final double reverseprogress = maxShrink == 0 ? 1.0 : (1 - progress);
    return Container(
      // color: bgColor,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HeaderAppBar(
              statusBarHeight: statusBarHeight,
              contentHeight: contentHeight + 10,
              progress: progress,
              bgColor: bgColor,
              title: playListInfo.name
            ),
          ),
          // Positioned.fill(
          //   child: LayoutBuilder(
          //     builder: (BuildContext context, BoxConstraints constraints) {
          //       double maxHeight = constraints.maxHeight;
          //       return HeaderContent(
          //         paddingTop: contentHeight + 20,
          //         height: maxHeight - contentHeight + 20,
          //         loadingColor: loadingColor,
          //         playListInfo: playListInfo,
          //       );
          //     },
          //   ),
          // ),
          Positioned.fill(
            child: ClipRect(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final maxHeight = constraints.maxHeight;
                  // print('--------------$maxHeight------------');
                  // final paddingTop = contentHeight + 20;
                  final paddingTop = contentHeight;
                  // ✅ 高度不足，直接不构建
                  if (maxHeight - paddingTop <= 100) {
                    // return const SizedBox.shrink();
                    return Container();
                  }
                  return Opacity(
                    opacity: reverseprogress,
                    child: Transform.translate(
                      offset: Offset(0, -30 * progress),
                      child: HeaderContent(
                        paddingTop: paddingTop,
                        height: maxHeight - paddingTop,
                        loadingColor: loadingColor,
                        playListInfo: playListInfo,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderAppBar extends StatefulWidget {
  final double statusBarHeight; // 状态栏高度
  final double contentHeight; // 内容区高度
  final double progress;
  final Color bgColor;
  final String title;
  const HeaderAppBar({
    super.key,
    required this.statusBarHeight,
    required this.contentHeight,
    required this.progress,
    required this.bgColor,
    required this.title,
  });

  @override
  State<HeaderAppBar> createState() => _HeaderAppBarState();
}

class _HeaderAppBarState extends State<HeaderAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.contentHeight,
      padding: EdgeInsets.only(
        top: widget.statusBarHeight,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Color.lerp(Colors.transparent, widget.bgColor, widget.progress),
      ),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              CupertinoIcons.chevron_back,
              color: Colors.white,
              size: 30,
            ),
          ),
          if (widget.progress > 0.9)
            Expanded(
              child: Text(
                widget.title,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          Flex(
            direction: Axis.horizontal,
            spacing: 18,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: Icon(
                  CupertinoIcons.search,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SvgPicture.asset(
                'lib/assets/icon/liebiao-dian.svg',
                width: 30,
                height: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeaderContent extends StatefulWidget {
  final double paddingTop; // 内容区高度
  final double height; // 内容区高度
  final Color loadingColor;
  final PlayList playListInfo;
  HeaderContent({
    super.key,
    required this.paddingTop,
    required this.height,
    required this.loadingColor,
    required this.playListInfo,
  });

  @override
  State<HeaderContent> createState() => _HeaderContentState();
}

bool isLoadingImage = true;
final GlobalKey _bgAreaKey = GlobalKey();

class _HeaderContentState extends State<HeaderContent> {
  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(
      widget.playListInfo.updateTime,
    );
    final String updateTime = '${time.year}-${time.month}-${time.day}';
    List<Map<String, dynamic>> btnLists = [
      {
        'icon': 'lib/assets/icon/fenxiang1.svg',
        'text': '分享',
        'num': widget.playListInfo.shareCount.toString(),
      },
      {
        'icon': 'lib/assets/icon/pinglun.svg',
        'text': '评论',
        'num': widget.playListInfo.commentCount.toString(),
      },
      {
        'icon': 'lib/assets/icon/tianjia.svg',
        'text': '收藏',
        'num': getPlayCount(widget.playListInfo.subscribedCount),
      },
    ];

    void setIsLoadingImage(bool value) {
      // print(value);
      isLoadingImage = value;
      setState(() {});
    }

    List<String> bgImageListTop = [];
    List<String> bgImageListBto = [];
    int imgNum = 0;
    final tracks = widget.playListInfo.tracks;
    if (tracks.length >= 2) {
      bgImageListTop = tracks.sublist(0, 2).map((e) => e.picUrl).toList();
    } else {
      bgImageListTop = tracks.map((e) => e.picUrl).toList();
    }
    if (tracks.length >= 6) {
      bgImageListBto = tracks.sublist(2, 6).map((e) => e.picUrl).toList();
    } else if (tracks.length > 2) {
      bgImageListBto = tracks.sublist(2).map((e) => e.picUrl).toList();
    }
    // print(bgImageListTop);
    // print(bgImageListBto);
    imgNum = bgImageListTop.length + bgImageListBto.length;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = ((screenWidth - 20) * 0.5).clamp(80.0, 200.0);
    return SizedBox(
      height: widget.height,
      child: ClipRect(
        child: OverflowBox(
          maxHeight: double.infinity,
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.only(
              top: widget.paddingTop,
              left: 10,
              right: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 10,
              children: [
                ClipRRect(
                  key: _bgAreaKey,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.white),
                      // color: isLoadingImage ? widget.loadingColor : Colors.transparent,
                    ),
                    child: BgImageList(
                      bgImageListTop: bgImageListTop,
                      bgImageListBto: bgImageListBto,
                      imgNum: imgNum,
                      setIsLoadingImage: setIsLoadingImage,
                      loadingColor: widget.loadingColor,
                      width: imageSize,
                      height: imageSize,
                      parentKey: _bgAreaKey,
                    ),
                  ),
                ),
                Text(
                  widget.playListInfo.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '更新时间: $updateTime',
                  style: TextStyle(
                    color: Color.fromRGBO(220, 220, 220, 1),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  // margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    // direction: Axis.horizontal,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          widget.playListInfo.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 122, 121, 121),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Icon(
                        CupertinoIcons.chevron_forward,
                        color: const Color.fromARGB(255, 122, 121, 121),
                        size: 12,
                      ),
                    ],
                  ),
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...List.generate(btnLists.length, (index) {
                      return Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                        ),
                        child: Flex(
                          direction: Axis.horizontal,
                          spacing: 5,
                          children: [
                            SvgPicture.asset(
                              btnLists[index]['icon'],
                              width: 18,
                              height: 18,
                              color: Colors.white,
                            ),
                            Text(
                              btnLists[index]['num'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BgImageList extends StatefulWidget {
  final List<String> bgImageListTop;
  final List<String> bgImageListBto;
  final int imgNum;
  final Function(bool) setIsLoadingImage;
  final Color loadingColor;
  final double width;
  final double height;
  final GlobalKey parentKey;

  const BgImageList({
    super.key,
    required this.bgImageListTop,
    required this.bgImageListBto,
    required this.imgNum,
    required this.setIsLoadingImage,
    required this.loadingColor,
    required this.width,
    required this.height,
    required this.parentKey,
  });

  @override
  State<BgImageList> createState() => _BgImageListState();
}

class _BgImageListState extends State<BgImageList> {
  int loadedImage = 0; // 记录已加载的图片数量
  final Set<String> _loadedIds = {};

  void isLoadAllImage(String url) {
    loadedImage++;
    if (!_loadedIds.add(url)) return; // 已计过，跳过
    if (loadedImage == widget.imgNum) {
      loadedImage = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.setIsLoadingImage(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeWidth = math.max(widget.width, 10.0);
    final safeHeight = math.max(widget.height, 10.0);
    final btoSizeW = math.max((((safeWidth * 2) + 2) - (2 * 3)) / 4, 10.0);
    final btoSizeH = math.max((((safeHeight * 2) + 2) - (2 * 3)) / 4, 10.0);
    return OverflowBox(
      minWidth: 0,
      minHeight: 0,
      maxHeight: double.infinity,
      maxWidth: double.infinity,
      // maxWidth: widget.width,
      // maxHeight: widget.height,
      child: Transform.rotate(
        angle: -math.pi * 0.18,
        child: Transform.translate(
          offset: Offset(65, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Flex(
                spacing: 2,
                direction: Axis.horizontal,
                children: [
                  ...List.generate(widget.bgImageListTop.length, (index) {
                    final image = SizedBox(
                      width: widget.width,
                      height: widget.height,
                      child: Image.network(
                        'https://images.weserv.nl/?url=${widget.bgImageListTop[index]}',
                        width: widget.width,
                        height: widget.height,
                        loadingBuilder:
                            (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                            ) {
                              if (loadingProgress == null) {
                                isLoadAllImage(widget.bgImageListTop[index]);
                                return child;
                              }
                              return Container(
                                width: widget.width,
                                height: widget.height,
                                color: widget.loadingColor,
                              );
                            },
                      ),
                    );
                    // if(index == 0) {
                    //   return AnimatedFirstItem(
                    //     parentKey: widget.parentKey,
                    //     child: image,
                    //   );
                    // }
                    return image;
                  }),
                ],
              ),
              Flex(
                spacing: 2,
                direction: Axis.horizontal,
                children: [
                  ...List.generate(widget.bgImageListBto.length, (index) {
                    return SizedBox(
                      width: btoSizeW,
                      height: btoSizeH,
                      child: Image.network(
                        'https://images.weserv.nl/?url=${widget.bgImageListBto[index]}',
                        width: btoSizeW,
                        height: btoSizeH,
                        loadingBuilder:
                            (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                            ) {
                              if (loadingProgress == null) {
                                isLoadAllImage(widget.bgImageListBto[index]);
                                return child;
                              }
                              return Container(
                                width: btoSizeW,
                                height: btoSizeH,
                                color: widget.loadingColor,
                              );
                            },
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
