// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/store/musicplay.dart';

class ControllerBtns extends StatefulWidget {
  final Rx<PlayMode> playMode;
  final Function(PlayMode) setPlayMode;
  final RxBool isPlaying;
  final Function() togglePlay;
  final Function(String) changeMusic;
  const ControllerBtns({
    super.key,
    required this.playMode,
    required this.setPlayMode,
    required this.isPlaying,
    required this.togglePlay,
    required this.changeMusic,
  });

  @override
  State<ControllerBtns> createState() => _ControllerBtnsState();
}

class _ControllerBtnsState extends State<ControllerBtns> {
  Map<PlayMode, String> playModeMap = {
    PlayMode.loopOne: 'lib/assets/icon/danquxunhuan.svg',
    PlayMode.sequence: 'lib/assets/icon/liebiaoxunhuan.svg',
    PlayMode.shuffle: 'lib/assets/icon/suiji.svg',
  };
  List<PlayMode> playModeList = [PlayMode.sequence, PlayMode.shuffle, PlayMode.loopOne];


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 模式切换
        ControllerBtn(
          icon: Obx(() {
            return SvgPicture.asset(
            playModeMap[widget.playMode.value]!,
            width: 25,
            height: 25,
            color: Colors.white,
          );
          }),
          onTap: () {
            final mode = playModeList.removeAt(0);
            widget.setPlayMode(mode);
            playModeList.add(mode);
          },
        ),
        // 上一首
        ControllerBtn(
          icon: Icon(
            CupertinoIcons.backward_end_fill,
            size: 25,
            color: Colors.white,
          ),
          onTap: () {
            widget.changeMusic('prev');
          },
        ),
        // 播放/暂停
        ControllerBtn(
          icon: Obx(() {
            return SvgPicture.asset(
            widget.isPlaying.value ? 'lib/assets/icon/weibiaoti519.svg' : 'lib/assets/icon/bofang2.svg',
            width: 40,
            height: 40,
            color: Colors.white,
          );
          }),
          onTap: () {
            widget.togglePlay();
          },
        ),
        // 下一首
        ControllerBtn(
          icon: Icon(
            CupertinoIcons.forward_end_fill,
            size: 25,
            color: Colors.white,
          ),
          onTap: () {
            widget.changeMusic('next');
          },
        ),
        // 播放列表
        ControllerBtn(
          icon: SvgPicture.asset(
            'lib/assets/icon/bofangliebiao-white.svg',
            width: 25,
            height: 25,
            color: Colors.white,
          ),
          onTap: () {},
        ),
      ],
    );
  }
}

class ControllerBtn extends StatefulWidget {
  final Widget icon; // 按钮
  final Function() onTap; // 点击事件
  const ControllerBtn({super.key, required this.icon, required this.onTap});

  @override
  State<ControllerBtn> createState() => _ControllerBtnState();
}

class _ControllerBtnState extends State<ControllerBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: widget.onTap, child: widget.icon);
  }
}
