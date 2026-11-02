import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yun_music/components/popmenuButton.dart';
import 'package:yun_music/pages/album/components/fullscreenPop.dart';
import 'package:yun_music/utils/index.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class Headerpart extends SliverPersistentHeaderDelegate {
  final double minExtentHeight;
  final double statusBarHeight;
  final double deviceHeight;
  final double devicewidth;
  final AlbumDetail albumInfo;
  final double operatorHeight = 50;

  Headerpart({
    required this.minExtentHeight,
    required this.statusBarHeight,
    required this.deviceHeight,
    required this.devicewidth,
    required this.albumInfo,
  });

  @override
  double get maxExtent => deviceHeight * 0.4;

  @override
  double get minExtent => minExtentHeight;

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
    double progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0, 1.0);
    return Stack(
      children: [
        // ========== ① 高斯模糊背景 ==========
        Positioned.fill(
          child: ClipPath(
            clipper: _imageClipper(
              arcHeight: 10,
              contentHeight: deviceHeight * 0.4 - 15,
            ),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Image.network(
                'https://images.weserv.nl/?url=${albumInfo.album.picUrl}',
                fit: BoxFit.cover,
                width: devicewidth,
                height: deviceHeight * 0.4 - 25,
                // 加载中/失败时显示深色占位
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: Colors.black);
                },
                errorBuilder: (_, __, ___) => Container(color: Colors.grey),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: ClipPath(
            clipper: _imageClipper(
              arcHeight: 10,
              contentHeight: deviceHeight * 0.4 - 15,
            ),
            child: Container(
              height: deviceHeight * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.withValues(alpha: 0.6), // 顶部深
                    Colors.grey.withValues(alpha: 0.3), // 中间浅
                    Colors.grey.withValues(alpha: 0.85), // 底部更深（衬托控件）
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 10,
          right: 20,
          child: Opacity(
            opacity: 1 - progress,
            child: Column(
              spacing: 35,
              children: [
                AlbumContent(albumInfo: albumInfo),
                AlbumOperator(
                  margin: devicewidth * 0.25 - 20,
                  commentCount: albumInfo.album.albumInfo.commentCount,
                  shareCount: albumInfo.album.albumInfo.shareCount,
                ),
              ],
            )
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Color.lerp(Colors.transparent, Colors.white, progress),
            height: minExtentHeight + statusBarHeight,
            // padding: EdgeInsets.only(top: statusBarHeight),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: HederAppBar(
              progress: progress,
              name: albumInfo.album.name,
            ),
          ),
        ),
      ],
    );
  }
}

class HederAppBar extends StatefulWidget {
  final double progress;
  final String name;
  const HederAppBar({super.key, required this.progress, required this.name});

  @override
  State<HederAppBar> createState() => _HederAppBarState();
}

class _HederAppBarState extends State<HederAppBar> {
  // List<MenuItem> menuList = [
  //   MenuItem(text: '清空下载文件', value: 1, iconWidget: Icon(CupertinoIcons.trash)),
  //   MenuItem(text: '举报', value: 2, iconWidget: Icon(CupertinoIcons.exclamationmark_triangle)),
  // ];

  @override
  Widget build(BuildContext context) {
    List<MenuItem> menuList = [
      MenuItem(
        text: '清空下载文件',
        value: 1,
        iconWidget: Icon(CupertinoIcons.trash),
      ),
      MenuItem(
        text: '举报',
        value: 2,
        iconWidget: Icon(CupertinoIcons.exclamationmark_triangle),
      ),
    ];

    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                iconSize: 28,
                icon: Icon(CupertinoIcons.arrow_left, color: widget.progress == 1 ? Colors.black :Colors.white),
              ),
              Text(
                widget.progress == 1 ? widget.name : '专辑',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.progress == 1 ? Colors.black :Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        PopupMenu(
          menuList: menuList,
          icon: Icon(CupertinoIcons.ellipsis_vertical, color: widget.progress == 1 ? Colors.black :Colors.white),
        ),
      ],
    );
  }
}

class _imageClipper extends CustomClipper<Path> {
  final double arcHeight; // 弧线凸起的高度
  final double contentHeight; // 内容高度

  _imageClipper({this.arcHeight = 60, required this.contentHeight});
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, contentHeight - arcHeight)
      // 底部弧线：从右下到左下，控制点在底部中间下方
      ..quadraticBezierTo(
        size.width / 2,
        contentHeight + arcHeight, // 控制点，越靠下弧度越大
        0,
        contentHeight - arcHeight,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

// 专辑操作按钮
class AlbumOperator extends StatefulWidget {
  final int shareCount;
  final int commentCount;
  final double margin;
  const AlbumOperator({
    super.key,
    required this.shareCount,
    required this.commentCount,
    required this.margin,
  });

  @override
  State<AlbumOperator> createState() => _AlbumOperatorState();
}

class _AlbumOperatorState extends State<AlbumOperator> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> list = [
      {'icon': 'lib/assets/icon/pinglun.svg', 'text': widget.commentCount},
      {'icon': '', 'text': ''},
      {'icon': 'lib/assets/icon/share.svg', 'text': widget.shareCount},
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.margin),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Flex(
        spacing: 10,
        direction: Axis.horizontal,
        children: List.generate(list.length, (index) {
          if (list[index]['icon'] == '' && list[index]['text'] == '') {
            return Container(width: 1, height: 20, color: Colors.grey);
          }
          return Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Flex(
                direction: Axis.horizontal,
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(list[index]['icon'], width: 20, height: 20),
                  Text(
                    getPlayCount(list[index]['text']),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// 专辑内容
class AlbumContent extends StatefulWidget {
  final AlbumDetail albumInfo;
  const AlbumContent({super.key, required this.albumInfo});

  @override
  State<AlbumContent> createState() => _AlbumContentState();
}

class _AlbumContentState extends State<AlbumContent> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 170,
        child: Flex(
          direction: Axis.horizontal,
          spacing: 15,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://images.weserv.nl/?url=${widget.albumInfo.album.picUrl}',
                width: 170,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.albumInfo.album.name,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {},
                        splashColor: Color.fromRGBO(255, 255, 255, 0.2),
                        highlightColor: Color.fromRGBO(255, 255, 255, 0.2),
                        child: Flex(
                          direction: Axis.horizontal,
                          spacing: 3,
                          children: [
                            Flexible(
                              child: Text(
                                '歌手: ${widget.albumInfo.album.artist.name}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_forward,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showFullScreenPop(
                        context, 
                        name: widget.albumInfo.album.name,
                        content: widget.albumInfo.album.description,
                        company: widget.albumInfo.album.company,
                        subType: widget.albumInfo.album.subType,
                        picUlr: widget.albumInfo.album.picUrl,
                      );
                    },
                    splashColor: Color.fromRGBO(255, 255, 255, 0.2),
                    highlightColor: Color.fromRGBO(255, 255, 255, 0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '发行时间: ${getDateTime(widget.albumInfo.album.publishTime)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Flex(
                          direction: Axis.horizontal,
                          spacing: 3,
                          children: [
                            Flexible(
                              child: Text(
                                widget.albumInfo.album.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_forward,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
