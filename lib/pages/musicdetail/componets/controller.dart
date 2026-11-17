// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/store/musicplay.dart';

class Controller extends StatefulWidget {
  // final Duration totalduration;
  final Rxn<Duration> totalduration;
  // final Duration? currentduration;
  final Rx<Duration> currentduration;
  final AnimationController progressController;
  final Animation<double> progressAnimation;
  final Rxn<Song> currentmusic;
  const Controller({
    super.key,
    required this.totalduration,
    required this.progressController,
    required this.progressAnimation,
    required this.currentduration,
    required this.currentmusic,
  });

  @override
  State<Controller> createState() => _ControllerState();
}

class _ControllerState extends State<Controller>
    with SingleTickerProviderStateMixin {
  String formatCurrentTime(Duration duration, double progress) {
    // print('duration.inMilliseconds');
    // print(duration);
    final p = progress.clamp(0.0, 1.0);
    final current = Duration(
      milliseconds: (duration.inMilliseconds * p).round(),
    );
    print('current');
    print(current);
    print(current.inMinutes);
    print(current.inSeconds);
    final hours = current.inMinutes.toString().padLeft(2, '0');
    final minutes = current.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  void initState() {
    super.initState();
    print('widget.currentduration');
    print(widget.currentduration.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        children: [
          Column(
            children: [
              // 播放进度条
              Progress(
                totalduration: widget.totalduration,
                currentduration: widget.currentduration,
                progressController: widget.progressController,
                progressAnimation: widget.progressAnimation,
              ),
              SizedBox(height: 10),
              // 进度条信息
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedBuilder(
                    animation: widget.progressAnimation,
                    builder: (context, _) {
                      return Obx(() => Text(
                        formatCurrentTime(
                          widget.totalduration.value ?? Duration.zero,
                          widget.progressAnimation.value,
                        ),
                        style: TextStyle(
                          color: Colors.white.withAlpha(80),
                          fontSize: 12,
                        ),
                      ));
                    },
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      '极高音质',
                      style: TextStyle(
                        color: Colors.white.withAlpha(80),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    formatCurrentTime(widget.totalduration.value ?? Duration.zero, 1),
                    style: TextStyle(
                      color: Colors.white.withAlpha(80),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              // 控制按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ControllerBtn(
                    icon: SvgPicture.asset(
                      'lib/assets/icon/liebiaoxunhuan.svg',
                      width: 25,
                      height: 25,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                  ControllerBtn(
                    icon: Icon(
                      CupertinoIcons.backward_end_fill,
                      size: 25,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                  ControllerBtn(
                    icon: SvgPicture.asset(
                      'lib/assets/icon/bofang2.svg',
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                  ControllerBtn(
                    icon: Icon(
                      CupertinoIcons.forward_end_fill,
                      size: 25,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 播放进度条
class Progress extends StatefulWidget {
  // final Duration totalduration;
  final Rxn<Duration> totalduration;
  // final Duration? currentduration;
  final Rx<Duration>? currentduration;
  final AnimationController progressController;
  final Animation<double> progressAnimation;
  const Progress({
    super.key,
    required this.totalduration,
    this.currentduration,
    required this.progressController,
    required this.progressAnimation,
  });

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress>
    with SingleTickerProviderStateMixin {
  // late AnimationController _animationController;
  // late Animation<double> _animation;
  final double dotsize = 8;

  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: widget.totalduration,
  //   );
  //   _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: dotsize,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: widget.progressAnimation,
                  builder: (context, _) {
                    return LinearProgressIndicator(
                      value: widget.progressAnimation.value,
                      backgroundColor: Colors.white.withAlpha(20),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                      minHeight: 2,
                      borderRadius: BorderRadius.circular(1),
                    );
                  },
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: AnimatedBuilder(
                  animation: widget.progressAnimation,
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(width * widget.progressAnimation.value, 0),
                      child: Container(
                        width: dotsize,
                        height: dotsize,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
