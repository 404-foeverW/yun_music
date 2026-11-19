// ignore_for_file: avoid_print

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/pages/musicdetail/componets/contentAnimation.dart';
import 'package:yun_music/pages/musicdetail/componets/controller.dart';
import 'package:yun_music/pages/musicdetail/componets/controllerbtn.dart';
import 'package:yun_music/pages/musicdetail/componets/freeAnimation.dart';
import 'package:yun_music/pages/musicdetail/componets/musicinfo.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/store/musicplay.dart';

class MusicDetail extends StatefulWidget {
  const MusicDetail({super.key});

  @override
  State<MusicDetail> createState() => _MusicDetailState();
}

class _MusicDetailState extends State<MusicDetail>
    with TickerProviderStateMixin {
  final player = Get.find<MusicPlayer>();

  final deviceInfo = Get.find<DeviceInfoService>();
  static const Color _color1 = Color.fromRGBO(211, 211, 211, 1);
  static const Color _color2 = Colors.white;
  static const Color _color3 = Color.fromRGBO(15, 20, 32, 1);

  // 唱臂控制器
  late final AnimationController _toneArmController;
  // 唱盘控制器
  late final AnimationController _recordController;
  // 唱臂动画
  late final Animation<double> _toneArmAnimation;
  // 唱盘动画
  late final Animation<double> _recordAnimation;
  final double _radius = -math.pi / 6;
  bool _isPlaying = false;

  // 进度条点控制器
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;
  final Duration musicduration = Duration(minutes: 3, seconds: 30);

  @override
  void initState() {
    super.initState();
    _toneArmController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _recordController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 10000),
    );
    _toneArmAnimation = Tween<double>(begin: _radius, end: 0).animate(
      CurvedAnimation(parent: _toneArmController, curve: Curves.easeInOut),
    );
    _recordAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_recordController);

    _progressController = AnimationController(
      vsync: this,
      // duration: musicduration,
      value: player.progress,
      duration: player.duration.value,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );
    if (player.isPlaying.value) {
      _isPlaying = true;
      _toneArmController.forward();
      _recordController.repeat();
      _progressController.repeat();
    }
  }

  Future<void> _togglePlay() async {
    if (_toneArmAnimation.isAnimating) return;
    print('_togglePlay');
    print(_isPlaying);
    if (_isPlaying) {
      _isPlaying = false;
      player.pause();
      setState(() {});
      await _toneArmController.reverse();
      if (!mounted) return;
      _recordController.stop();
      _progressController.stop();
    } else {
      _isPlaying = true;
      player.play();
      setState(() {});
      await _toneArmController.forward();
      if (!mounted) return;
      _recordController.repeat();
      _progressController.forward(from: player.progress);
    }
  }

  void setPlayPosition(double position, Duration duration) {
    _progressController.value = position;
    player.seek(duration);
  }

  void changeMusic(String type) async {
    try {
      print('_isPlaying: $_isPlaying');
      if (_isPlaying) {
        await _toneArmController.reverse();
      }
      if (type == 'next') {
        player.playNext();
      } else if (type == 'prev') {
        player.playPrevious();
      }
      print('重新开启动画------1');
      print('进度条开启动画------');
      _progressController.forward(from: 0);
      print('唱臂开启动画------');
      _toneArmController.forward().catchError((error) {
        print('唱臂开启动画失败------error: $error');
      });
      print('唱盘开启动画------');
      _recordController.repeat();
      print('重新开启动画------2');
      if (!_isPlaying) {
        _isPlaying = true;
        print('_isPlaying: $_isPlaying');
        setState(() {});
      }
    } catch (e) {
      print('changeMusic error: $e');
    }
  }

  @override
  void dispose() {
    _toneArmController.dispose();
    _recordController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = (deviceInfo.width - 30) / 2 - 80;
    return Container(
      padding: EdgeInsets.only(
        top: deviceInfo.statusBarHeight,
        left: 15,
        right: 15,
        bottom: deviceInfo.bottomSafeAreaHeight,
      ),
      decoration: BoxDecoration(color: _color3),
      child: Column(
        children: [
          // 头部
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.chevron_down,
                  color: _color1,
                  size: 25,
                ),
              ),
              SizedBox(width: size),
              // SizedBox(width: (deviceInfo.width - 30)/2),
              Expanded(
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Text(
                        player.musicOrigin,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _color1,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    FreeAnimation(),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'lib/assets/icon/fenxiang1.svg',
                  width: 20,
                  height: 20,
                  color: _color1,
                ),
              ),
            ],
          ),
          // 内容
          ContentAnimation(
            toneArmController: _toneArmController,
            recordController: _recordController,
            toneArmAnimation: _toneArmAnimation,
            recordAnimation: _recordAnimation,
            radius: _radius,
            currentmusic: player.currentSong,
            songList: player.playlist,
          ),
          // TextButton(
          //   onPressed: _togglePlay,
          //   child: Text(
          //     _isPlaying ? '暂停' : '播放',
          //     style: TextStyle(
          //       color: _color1,
          //       fontSize: 14,
          //     ),
          //   ),
          // )
          // 信息栏
          InfoBox(
            width: deviceInfo.width - 30,
            bgColor: _color3,
            currentmusic: player.currentSong,
          ),
          // 控制器-进度条
          Controller(
            currentduration: player.position,
            totalduration: player.duration,
            progressController: _progressController,
            progressAnimation: _progressAnimation,
            currentmusic: player.currentSong,
            currentProgress: player.progress,
            setPlayPosition: setPlayPosition,
          ),
          SizedBox(height: 30),
          // 控制器-按钮
          ControllerBtns(
            playMode: player.playMode,
            setPlayMode: player.setPlayMode,
            isPlaying: player.isPlaying,
            togglePlay: _togglePlay,
            changeMusic: changeMusic,
          ),
          // 底部栏
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ControllerBtn(
                      icon: SvgPicture.asset(
                        'lib/assets/icon/shouji.svg',
                        width: 25,
                        height: 25,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      onTap: () {},
                    ),
                    ControllerBtn(
                      icon: SvgPicture.asset(
                        'lib/assets/icon/woaifamingx.svg',
                        width: 25,
                        height: 25,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      onTap: () {},
                    ),
                    ControllerBtn(
                      icon: SvgPicture.asset(
                        'lib/assets/icon/careful.svg',
                        width: 25,
                        height: 25,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      onTap: () {},
                    ),
                    ControllerBtn(
                      icon: SvgPicture.asset(
                        'lib/assets/icon/dian1.svg',
                        width: 25,
                        height: 25,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
