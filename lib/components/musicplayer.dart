// ignore_for_file: avoid_print
// 主页面播放器
import 'dart:math' as math;

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/musiclistpop.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/utils/index.dart';
import 'package:yun_music/viewmodel/index.dart';

class MusicPlayController extends StatefulWidget {
  final player;
  final Duration? fristDuration;
  final int? current;
  final PlayerStyle? playerStyle;

  const MusicPlayController({
    super.key,
    this.current,
    required this.player,
    this.fristDuration,
    this.playerStyle
  });

  @override
  State<MusicPlayController> createState() => _MusicPlayControllerState();
}

Widget _placeholder() {
  return Container(
    width: 40,
    height: 40,
    color: Colors.grey[300],
    child: const Icon(Icons.music_note, size: 24, color: Colors.grey),
  );
}

class _MusicPlayControllerState extends State<MusicPlayController> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  late final Worker _indexWorker;
  Duration _duration = Duration(milliseconds: 0);
  int _currentMusicIndex = 0;
  int _operationId = 0;
  bool _isAnimatingCarousel = false;

  PlayerStyle get _style => widget.playerStyle ?? PlayerStyle.getDefault;


  // List<Map<String, dynamic>> style = [
  //   {
  //     // 音乐名称颜色
  //     'musicNameColor': Colors.black,
  //     // 歌手颜色
  //     'artistColor': Colors.grey,
  //     // 播放/暂停图标颜色
  //     'iconColor': Colors.black,
  //     // 背景颜色
  //     'bgColor': Colors.white,
  //     // 阴影颜色
  //     'shadowColor': Color.fromARGB(255, 235, 230, 230),
  //     // 播放进度条颜色
  //     'progressColor': Colors.black,
  //     // 播放进度条背景颜色
  //     'progressBgColor': Colors.grey.shade300,
  //     // 播放列表图标颜色
  //     'listIconColor': 'black',
  //   },
  //   {
  //     'musicNameColor': Colors.white,
  //     'artistColor': Colors.grey.shade300,
  //     'iconColor': Colors.white,
  //     'bgColor': Colors.black,
  //     'shadowColor': Colors.black,
  //     'progressColor': Colors.white,
  //     'progressBgColor': Colors.grey.shade300,
  //     'listIconColor': 'white'
  //   },
  // ];


  // late GradientCircularProgress progress;

  // void changeDuration() {
  // progress._controller.forward();
  // }

  @override
  void initState() {
    super.initState();
    _duration = widget.fristDuration ?? Duration.zero;

    _indexWorker = ever(widget.player.currentIndex, (int index) {
      print('index--------------');
      print(index);
      print('_currentMusicIndex: ${_currentMusicIndex}');
      if (index != _currentMusicIndex) {
        _currentMusicIndex = index;
        _isAnimatingCarousel = true;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            await _carouselController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } finally {
            _isAnimatingCarousel = false;
          }
        });
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    _indexWorker.dispose(); // ✅ 取消监听
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: style.shadowColor,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              spacing: 10,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color: Colors.black,
                  ),
                  child: Obx(() {
                    final song = widget.player.currentSong.value;
                    final coverUrl = song?.coverUrl ?? '';
                    // if (coverUrl.isEmpty) {
                    //   return _placeholder();   // 没有封面时显示占位
                    // }
                    return ClipOval(
                      child: Image.network(
                        'https://images.weserv.nl/?url=${Uri.encodeComponent(coverUrl)}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _placeholder();
                        },
                      ),
                    );
                  }),
                ),
                Expanded(
                  child: Obx(() {
                      final playlist = widget.player.playlist;
                      // 列表为空时不构建
                      if (playlist.isEmpty) {
                        return const SizedBox(height: 50);
                      }
                      return CarouselSlider(
                        key: ValueKey(playlist.length),
                        carouselController: _carouselController,
                        items: List.generate(playlist.length, (index) {
                          final brief = playlist[index];
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: brief.title,
                                style: TextStyle(
                                  color: style.musicNameColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' - ${brief.artist}',
                                    style: TextStyle(color: style.artistColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 50,
                          onPageChanged: (index, reason) async {
                            // 程序化滚动（animateToPage 触发的）直接忽略，不参与业务
                            if (_isAnimatingCarousel) return;
                            if (index == _currentMusicIndex) return;
                            if (reason != CarouselPageChangedReason.manual) return;
                            final op = ++_operationId;
                            _currentMusicIndex = index;
                            if (widget.player.currentIndex.value != index) {
                              widget.player.currentIndex.value = index;
                            }
                            await widget.player.playAt(index, autoPlay: true);
                            print('_duration----------------------start');
                            // 防抖：期间又滑动过就忽略
                            if (op != _operationId) return;
                            if (!mounted) return;
                          },
                        ),
                      );
                    
                  })
                ),
              ],
            ),
          ),
          // PlayerBtn(),
          Obx(() {
            return GradientCircularProgress(
              size: 30,
              strokeWidth: 4,
              progress: widget.player.progress, // 0.0 ~ 1.0
              isPlaying: widget.player.isPlaying.value,
              onTap: widget.player.togglePlayPause,
              style: style
            );
          }),
          Obx(() {
            return MusicList(
              playList: widget.player.playlist,
              style: style
            );
          }),
          // MusicList(
          //   playList: widget.player.playlist,
          //   style: style
          // )
          // MusicList()
        ],
      ),
    );
  }
}

// 圆形进度条
class GradientCircularProgress extends StatelessWidget {
  final PlayerStyle style;
  final double size;
  final double strokeWidth;
  // final Duration duration;
  final double progress; // 0.0 ~ 1.0
  final bool isPlaying;
  final VoidCallback onTap;

  const GradientCircularProgress({
    super.key,
    this.size = 30,
    this.strokeWidth = 4,
    // required this.duration,
    required this.progress,
    required this.isPlaying,
    required this.onTap,
    required this.style
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: CustomPaint(
          size: Size(size, size),
          painter: _GradientCirclePainter(
            progress: progress.clamp(0.0, 1.0),
            strokeWidth: strokeWidth,
            style: style
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: Icon(
                isPlaying
                    ? CupertinoIcons.pause_circle_fill
                    : CupertinoIcons.arrowtriangle_right_circle_fill,
                color: style.iconColor,
                size: size * 0.55,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 画笔
class _GradientCirclePainter extends CustomPainter {
  final double progress; // 0.0 ~ 1.0
  final double strokeWidth;
  final PlayerStyle style;

  _GradientCirclePainter({required this.progress, required this.strokeWidth, required this.style});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 开始画圆体
    final beginPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = style.progressBgColor
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, beginPaint);

    // 开始画进度条
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi,
        colors: [
          style.progressColor, // 终点：白
          style.progressColor, // 终点：白
        ],
        stops: [0.0, 1.0],
        transform: GradientRotation(-math.pi / 2),
      ).createShader(rect);

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(_GradientCirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class MusicList extends StatefulWidget {
  final List<SongBrief> playList;
  final PlayerStyle style;
  const MusicList({super.key, required this.playList, required this.style});
  // const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {

  @override
  Widget build(BuildContext context) {
    String suffixName = widget.style.listIconColor;
    SvgPicture iconList = SvgPicture.asset(
      'lib/assets/icon/bofangliebiao-$suffixName.svg',
      width: 20,
      height: 20,
    );
    return GestureDetector(
      onTap: () {
        print('触发');
        if (widget.playList.isEmpty) {
          Toastutil.showToast(context, '播放列表为空');
          return;
        }
        showModalBottomSheet(
          context: context,
          builder: (context) => MusicListPop(),
        );
      },
      child: Container(
        width: 30,
        height: 30,
        margin: EdgeInsets.only(left: 25),
        child: iconList,
      ),
    );
  }
}
