// ignore_for_file: avoid_print

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/modalBottom.dart';
import 'package:yun_music/main.dart';
import 'package:yun_music/utils/index.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class HeaderPart extends SliverPersistentHeaderDelegate {
  final double minExtentHeight;
  final double statusBarHeight;
  final double deviceHeight;
  final double devicewidth;
  final RankingDetail rankingDetail;
  void Function(bool show)? showImgFunc;

  HeaderPart({
    required this.minExtentHeight,
    required this.rankingDetail,
    required this.statusBarHeight,
    required this.deviceHeight,
    required this.devicewidth,
    this.showImgFunc,
  });

  @override
  double get maxExtent => deviceHeight * 0.53;

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
    List<String> top3 = rankingDetail.songs.sublist(0, 4).map((item) {
      return item.picUrl;
    }).toList();
    return Stack(
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 0),
            child: Image.network(
              'https://images.weserv.nl/?url=${rankingDetail.info.coverImgUrl}',
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
        Positioned.fill(
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
        Positioned.fill(
          bottom: 0,
          left: 10,
          right: 10,
          child: Opacity(
            opacity: 1 - progress,
            child: Container(
              padding: EdgeInsets.only(
                top: minExtentHeight + 10,
                left: 10,
                right: 10,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double height = constraints.maxHeight;
                  return HeaderContent(
                    rankingDetail: rankingDetail,
                    height: height,
                    width: devicewidth - 20,
                    top3: top3,
                  );
                },
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            height: deviceHeight * 0.4,
            decoration: BoxDecoration(
              color: Color.lerp(Colors.transparent, Colors.white, progress)
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            // color: Color.lerp(Colors.transparent, Colors.white, progress),
            color: progress == 1 ? Colors.white : Colors.transparent,
            height: minExtentHeight + statusBarHeight,
            // padding: EdgeInsets.only(top: statusBarHeight),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: HederAppBar(
              progress: progress,
              name: rankingDetail.info.name,
              showImgFunc: showImgFunc,
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
  void Function(bool show)? showImgFunc;
  HederAppBar({
    super.key,
    required this.progress,
    required this.name,
    this.showImgFunc,
  });

  @override
  State<HederAppBar> createState() => _HederAppBarState();
}

class _HederAppBarState extends State<HederAppBar> {
  late final SheetConfig sheetConfig;
  RxBool showAlbumCover = true.obs;

  @override
  void initState() {
    super.initState();
    sheetConfig = SheetConfig(
      title: '歌单: 网易云${widget.name}',
      items: [
        SheetListItem(
          iconPath: 'lib/assets/icon/qingkongwenjianjia.svg',
          text: '清空下载文件',
        ),
        SheetListItem(
          iconPath: 'lib/assets/icon/fengmian.svg',
          text: '展示专辑封面',
          isOperator: true,
          operatorWidget: Obx(
            () => Switch(
              inactiveTrackColor: Colors.grey,
              activeTrackColor: Colors.red,
              value: showAlbumCover.value,
              onChanged: (value) {
                print(value);
                widget.showImgFunc!(value);
                setState(() {
                  showAlbumCover.value = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = widget.progress == 1 ? Colors.black : Colors.white;
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
                icon: Icon(CupertinoIcons.arrow_left, color: color),
              ),
              Text(
                widget.progress == 1 ? widget.name : '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.search, color: color),
              iconSize: 28,
            ),
            IconButton(
              onPressed: () {
                showBottomSheetPop(context, sheetConfig);
              },
              icon: Icon(CupertinoIcons.ellipsis_vertical, color: color),
              iconSize: 28,
            ),
          ],
        ),
      ],
    );
  }
}

class HeaderContent extends StatefulWidget {
  final RankingDetail rankingDetail;
  final double height;
  final double width;
  final List<String> top3;
  const HeaderContent({
    super.key,
    required this.rankingDetail,
    required this.height,
    required this.width,
    required this.top3,
  });

  @override
  State<HeaderContent> createState() => _HeaderContentState();
}

class _HeaderContentState extends State<HeaderContent> {
  void showRankTime(BuildContext context) {
    // 1. 获取 Overlay 的 context，它包含了 MaterialLocalizations
    final overlayContext = navigatorKey.currentState?.overlay?.context;
    if (overlayContext == null) {
      debugPrint('无法获取 Overlay context');
      return;
    }
    DateTime date = DateTime.now();
    String year = date.year.toString();
    List<List<String>> pickData = [
      ['$year年'],
      [
        '当期',
        '12期 (10.16~10.22)',
        '11期 (10.09~10.15)',
        '10期 (10.02~10.08)',
        '9期 (09.25~10.01)',
        '8期 (09.18~09.24)',
        '7期 (09.11~09.17)',
        '6期 (09.04~09.10)',
        '5期 (08.28~10.03)',
        '4期 (08.21~08.27)',
        '3期 (08.14~08.20)',
        '2期 (08.07~08.13)',
        '1期 (07.31~08.06)',
      ],
    ];
    final defaultIndex = [0, 0];
    String title = '切换榜单时间';
    final picker = Picker(
      onBuilderItem: (context, text, child, selected, column, index) {
        // 根据 column 区分两列，设置不同的高亮色
        final highlightColor = Colors.black;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            text ?? '',
            style: TextStyle(
              color: selected
                  ? highlightColor
                  : Colors.black87.withValues(alpha: 0.7),
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      },
      itemExtent: 60,
      adapter: PickerDataAdapter<String>(pickerData: pickData, isArray: true),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      selecteds: defaultIndex, // 默认选中项
      cancelText: '取消',
      confirmText: '确定',
      cancelTextStyle: const TextStyle(color: Colors.black),
      confirmTextStyle: const TextStyle(color: Colors.black),
    );
    // .showModal(overlayContext);

    showModalBottomSheet(
      context: context, // 这里使用 HeaderContent 的 context 即可，因为路由会提供新 context
      builder: (routeContext) {
        // 使用 makePicker() 获取 Widget
        return SizedBox(height: 300, child: picker.makePicker());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.only(bottom: 10),
      child: ClipRect(
        child: OverflowBox(
          maxHeight: double.infinity,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25),
              Container(
                width: widget.width,
                height: 190,
                child: Stack(
                  children: [
                    Positioned(
                      left: (widget.width / 2) - 95 - 60,
                      bottom: 10,
                      child: Transform.rotate(
                        angle: -math.pi / 26,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Opacity(
                            opacity: 0.4,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://images.weserv.nl/?url=${widget.top3[1]}',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'lib/assets/icon/xingzhuang.svg',
                                      width: 16,
                                      height: 16,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '2',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SvgPicture.asset(
                                      'lib/assets/icon/a-xingzhuang1.svg',
                                      width: 16,
                                      height: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: (widget.width / 2) - 95 - 70,
                      bottom: 10,
                      child: Transform.rotate(
                        angle: math.pi / 26,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Opacity(
                            opacity: 0.4,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://images.weserv.nl/?url=${widget.top3[2]}',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.topRight,
                                child: Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset(
                                      'lib/assets/icon/xingzhuang.svg',
                                      width: 16,
                                      height: 16,
                                      color: Color.fromRGBO(184, 134, 111, 1),
                                    ),
                                    Text(
                                      '3',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      'lib/assets/icon/a-xingzhuang1.svg',
                                      width: 16,
                                      height: 16,
                                      color: Color.fromRGBO(184, 134, 111, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: (widget.width / 2) - 95,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 190,
                          height: 190,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://images.weserv.nl/?url=${widget.top3[0]}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0, 0.3, 1],
                                colors: [
                                  Colors.white.withValues(alpha: 0.6),
                                  Colors.white.withValues(alpha: 0.6),
                                  Colors.transparent,
                                ],
                              )
                            ),
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'lib/assets/icon/xingzhuang.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                Text(
                                  'TOP 1',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 215, 0, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SvgPicture.asset(
                                  'lib/assets/icon/a-xingzhuang1.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Flex(
                direction: Axis.horizontal,
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '网易云${widget.rankingDetail.info.name}',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    CupertinoIcons.exclamationmark_circle,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 3,
                children: [
                  Flex(
                    direction: Axis.horizontal,
                    spacing: 2,
                    children: [
                      SvgPicture.asset(
                        'lib/assets/icon/wangyiyun1.svg',
                        width: 18,
                        height: 18,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      Text(
                        '网易云音乐',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      thickness: 2,
                      indent: 4,
                      endIndent: 4,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    '${getPlayCount(widget.rankingDetail.info.playCount)}次播放',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      thickness: 2,
                      indent: 4,
                      endIndent: 4,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      showRankTime(context);
                    },
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          '最近更新  ${getDateTime(widget.rankingDetail.info.trackUpdateTime)}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.chevron_right,
                          color: Colors.white.withValues(alpha: 0.6),
                          size: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              RankingOperator(
                shareCount: widget.rankingDetail.info.shareCount,
                commentCount: widget.rankingDetail.info.commentCount,
                subscribedCount: widget.rankingDetail.info.subscribedCount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RankingOperator extends StatefulWidget {
  final int shareCount;
  final int commentCount;
  final int subscribedCount;
  const RankingOperator({
    super.key,
    required this.shareCount,
    required this.commentCount,
    required this.subscribedCount,
  });

  @override
  State<RankingOperator> createState() => _RankingOperatorState();
}

class _RankingOperatorState extends State<RankingOperator> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> list = [
      {'icon': 'lib/assets/icon/share.svg', 'text': widget.shareCount},
      {'icon': 'lib/assets/icon/pinglun.svg', 'text': widget.commentCount},
      {'icon': 'lib/assets/icon/tianjia.svg', 'text': widget.subscribedCount},
    ];
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Flex(
        spacing: 15,
        direction: Axis.horizontal,
        children: List.generate(list.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Flex(
                  spacing: 5,
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      list[index]['icon'],
                      width: 25,
                      height: 25,
                      color: Colors.white,
                    ),
                    Text(
                      list[index]['text'].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
