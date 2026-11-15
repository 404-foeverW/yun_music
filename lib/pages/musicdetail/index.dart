import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/pages/musicdetail/componets/contentAnimation.dart';
import 'package:yun_music/pages/musicdetail/componets/freeAnimation.dart';
import 'package:yun_music/pages/musicdetail/componets/musicinfo.dart';
import 'package:yun_music/store/index.dart';

class MusicDetail extends StatefulWidget {
  const MusicDetail({super.key});

  @override
  State<MusicDetail> createState() => _MusicDetailState();
}

class _MusicDetailState extends State<MusicDetail>
    with TickerProviderStateMixin {
  final deviceInfo = Get.find<DeviceInfoService>();
  static const Color _color1 = Color.fromRGBO(211, 211, 211, 1);
  static const Color _color2 = Colors.white;
  static const Color _color3 = Color.fromRGBO(15, 20, 32, 1);

  late final AnimationController _toneArmController;
  late final AnimationController _recordController;
  late final Animation<double> _toneArmAnimation;
  late final Animation<double> _recordAnimation;
  final double _radius = -math.pi / 6;
  bool _isPlaying = false;

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
  }

  Future<void> _togglePlay() async {
    if(_toneArmAnimation.isAnimating) return;
    if(_isPlaying) {
      _isPlaying = false;
      setState(() {});
      await _toneArmController.reverse();
      if (!mounted) return;
      _recordController.stop();
    } else {
      _isPlaying = true;
      setState(() {});
      await _toneArmController.forward();
      if (!mounted) return;
      _recordController.repeat();
    }
  }

  @override
  void dispose() {
    _toneArmController.dispose();
    _recordController.dispose();
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
                        '每日推荐',
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
            radius: _radius
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
          ),
          // 控制器
          Container(child: Text('控制器'))
        ],
      ),
    );
  }
}
