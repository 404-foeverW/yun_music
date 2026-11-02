// ignore_for_file: avoid_print

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/tag.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/utils/index.dart' show getDeviceInfo;
import 'package:yun_music/viewmodel/index.dart';

class MusicListPop extends StatefulWidget {
  final Color rippleColor;
  final Duration rippleDuration;
  const MusicListPop({
    super.key,
    this.rippleColor = Colors.red,
    this.rippleDuration = const Duration(milliseconds: 800),
  });

  @override
  State<MusicListPop> createState() => _MusicListPopState();
}

class _MusicListPopState extends State<MusicListPop>
    with TickerProviderStateMixin {
  final player = Get.find<MusicPlayer>();

  // 滚动控制器
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _rippleController;

  // 是否已经触底（用于防止同一次触底反复触发）
  bool _isAtBottom = false;
  // 波纹是否正在播放
  bool _rippleActive = false;

  @override
  void initState() {
    super.initState();

    _rippleController = AnimationController(
      vsync: this,
      duration: widget.rippleDuration,
    );
    _rippleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rippleActive = false;
        _rippleController.reset();
      }
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final scrollPosition = _scrollController.position;

    // ✅ 内容不足一屏时不触发
    if (scrollPosition.maxScrollExtent <= 0) return;
    // 允许 0.5 像素的容差
    final atBottom =
        scrollPosition.pixels >= scrollPosition.maxScrollExtent - 5.0;
    if (atBottom && !_isAtBottom) {
      _isAtBottom = true;
      // 触发加载更多
      print('触底了');
      _triggerRipple();
    } else if (!atBottom) {
      _isAtBottom = false;
    }
  }

  void _triggerRipple() {
    if (_rippleActive) return;
    _rippleActive = true;
    _rippleController.forward(from: 0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  int _tebleCurrentIndex = 0;
  void setTableIndex(int index) {
    print(index);
    _tebleCurrentIndex = index;
    setState(() {});
  }

  SvgPicture iconselectlist = SvgPicture.asset(
    'lib/assets/icon/select_list.svg',
    width: 20,
    height: 20,
  );
  SvgPicture icondeletelist = SvgPicture.asset(
    'lib/assets/icon/delete_list.svg',
    width: 20,
    height: 20,
  );
  SvgPicture icondeletesignle = SvgPicture.asset(
    'lib/assets/icon/delete_sigle.svg',
    width: 20,
    height: 20,
  );
  SvgPicture iconsinglelist = SvgPicture.asset(
    'lib/assets/icon/danlieliebiao-grey.svg',
    width: 20,
    height: 20,
  );
  SvgPicture iconxunhuan = SvgPicture.asset(
    'lib/assets/icon/liebiaoxunhuan.svg',
    width: 20,
    height: 20,
  );
  SvgPicture iconxiangjiao = SvgPicture.asset(
    'lib/assets/icon/xiangjiao.svg',
    width: 20,
    height: 20,
  );

  @override
  Widget build(BuildContext context) {
    DeviceInfo info = getDeviceInfo(context);
    return Container(
      width: info.width,
      height: info.height * 0.8,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 234, 234),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.only(
        // left: 15,
        // right: 15,
        bottom: info.bottomSafeAreaHeight,
        top: 10,
      ),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  spacing: 40,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setTableIndex(0);
                      },
                      child: Badge(
                        label: Text(
                          player.playlist.length.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _tebleCurrentIndex == 0
                                ? Colors.black
                                : Colors.grey.shade300,
                          ),
                        ),
                        alignment: Alignment.topRight,
                        offset: const Offset(10, 0),
                        backgroundColor: Colors.transparent,
                        child: Text(
                          '播放列表',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _tebleCurrentIndex == 0
                                ? Colors.black
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setTableIndex(1);
                      },
                      child: Text(
                        '历史播放',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _tebleCurrentIndex == 1
                              ? Colors.black
                              : const Color.fromARGB(255, 123, 121, 121),
                        ),
                      ),
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  spacing: 30,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('管理');
                      },
                      child: iconselectlist,
                    ),
                    GestureDetector(
                      onTap: () {
                        print('删除');
                      },
                      child: icondeletelist,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: RichText(
              text: TextSpan(
                text: '来自：',
                style: TextStyle(color: Colors.grey.shade500),
                children: [
                  TextSpan(
                    text: player.musicOrigin,
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // 歌曲列表
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, constraints) {
                final listWidth = constraints.maxWidth;
                final listHeight = constraints.maxHeight;
                return Obx(() {
                  final currentIndex = player.currentIndex.value;
                  final playlist = player.playlist;
                  return Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: playlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          Color textColor = currentIndex == index
                              ? Colors.red
                              : Colors.black;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                await player.playAt(index, autoPlay: true);
                              },
                              onLongPress: () {},
                              // borderRadius: BorderRadius.circular(12),
                              splashColor: Color.fromRGBO(0, 0, 0, .3),
                              highlightColor: Color.fromRGBO(0, 0, 0, .1),
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  bottom: index + 1 == playlist.length
                                      ? 30
                                      : 10,
                                  left: 15,
                                  right: 15,
                                ),
                                child: Row(
                                  spacing: 25,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Flex(
                                        spacing: 5,
                                        direction: Axis.horizontal,
                                        children: [
                                          if (currentIndex == index)
                                            Icon(
                                              CupertinoIcons.chart_bar_alt_fill,
                                              color: textColor,
                                              size: 20,
                                            ),
                                          Tag(
                                            music: TagInfo(
                                              fee: playlist[index].fee,
                                              pop: playlist[index].pop,
                                            ),
                                            type: 0,
                                          ),
                                          Expanded(
                                            child: RichText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                text: player
                                                    .playlist[index]
                                                    .title,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: textColor,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        ' - ${playlist[index].artist}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            151,
                                                            149,
                                                            149,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flex(
                                      direction: Axis.horizontal,
                                      spacing: 30,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print('单个删除');
                                            player.removeSong(index);
                                            setState(() {});
                                          },
                                          child: icondeletesignle,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print('单个选择');
                                          },
                                          child: iconsinglelist,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedBuilder(
                            animation: _rippleController,
                            builder: (BuildContext context, child) {
                              if (_rippleController.value == 0) {
                                return const SizedBox.shrink();
                              }
                              return CustomPaint(
                                size: Size(listWidth, listHeight),
                                painter: _RipplePainter(
                                  progress: _rippleController.value,
                                  origin: Offset(listWidth / 2, listHeight),
                                  color: widget.rippleColor,
                                  maxWidth: listWidth * 0.8, // 水平扩散到 80% 宽度
                                  maxHeight: listHeight * 0.2,
                                  rippleCount: 3, // 垂直扩散到 20% 高度
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: listWidth,
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.5, 0.5],
                              // colors: [Color.fromARGB(0, 0, 0, 0), Color.fromARGB(0, 0, 0, 0), Color.fromARGB(255, 243, 234, 234), Color.fromARGB(255, 243, 234, 234)],
                              colors: [
                                Color.fromARGB(0, 0, 0, 0),
                                Color.fromARGB(255, 243, 234, 234),
                              ],
                            ),
                          ),
                          child: Flex(
                            spacing: 30,
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.white,
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: Flex(
                                    spacing: 10,
                                    direction: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      iconxunhuan,
                                      Text(
                                        '列表循环',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.white,
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: Flex(
                                    spacing: 10,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    direction: Axis.horizontal,
                                    children: [
                                      iconxiangjiao,
                                      Text(
                                        '智能过渡',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Offset origin;
  final Color color;
  final double maxWidth; // 水平最大半径
  final double maxHeight; // 垂直最大半径（= size.height * 0.2）
  final int rippleCount;

  _RipplePainter({
    required this.progress,
    required this.origin,
    required this.color,
    required this.maxWidth,
    required this.maxHeight,
    this.rippleCount = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    for (int i = 0; i < rippleCount; i++) {
      // ✅ 每层错开 0.2 个进度
      final delay = i * 0.2;
      final p = (progress - delay).clamp(0.0, 1.0);
      if (p <= 0 || p >= 1) continue;

      // ✅ 椭圆：宽 = maxWidth * 2p，高 = maxHeight * 2p
      final rect = Rect.fromCenter(
        center: origin,
        width: maxWidth * 2 * p,
        height: maxHeight * 2 * p,
      );

      final paint = Paint()
        ..color = color.withValues(alpha: (1 - p) * 0.3)
        ..style = PaintingStyle.fill;

      // ✅ 画上半椭圆：从 180° 扫 180° 到 360°
      canvas.drawArc(rect, math.pi, math.pi, true, paint);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) =>
      old.progress != progress ||
      old.origin != origin ||
      old.color != color ||
      old.maxWidth != maxWidth ||
      old.maxHeight != maxHeight;
}
