// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/utils/index.dart';

class Controller extends StatefulWidget {
  // final Duration totalduration;
  final Rxn<Duration> totalduration;
  // final Duration? currentduration;
  final Rx<Duration> currentduration;
  final AnimationController progressController;
  final Animation<double> progressAnimation;
  final Rxn<Song> currentmusic;
  final double currentProgress;
  final Function(double, Duration) setPlayPosition;
  const Controller({
    super.key,
    required this.totalduration,
    required this.progressController,
    required this.progressAnimation,
    required this.currentduration,
    required this.currentmusic,
    required this.currentProgress,
    required this.setPlayPosition,
  });

  @override
  State<Controller> createState() => _ControllerState();
}

class _ControllerState extends State<Controller>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    // print('widget.currentduration');
    // print(widget.currentduration.value);
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
                setPlayPosition: widget.setPlayPosition
              ),
              SizedBox(height: 10),
              // 进度条信息
              Obx(() => Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedBuilder(
                    animation: widget.progressAnimation,
                    builder: (context, _) {
                      // return Obx(
                      //   () => Text(
                      //     formatCurrentTime(
                      //       widget.totalduration.value ?? Duration.zero,
                      //       widget.progressAnimation.value,
                      //     ),
                      //     style: TextStyle(
                      //       color: Colors.white.withAlpha(80),
                      //       fontSize: 12,
                      //     ),
                      //   ),
                      // );
                      return Text(
                          formatCurrentTime(
                            widget.totalduration.value ?? Duration.zero,
                            widget.progressAnimation.value,
                          ),
                          style: TextStyle(
                            color: Colors.white.withAlpha(80),
                            fontSize: 12,
                          ),
                        );
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
                  // Obx(() {
                  //   return Text(
                  //   formatCurrentTime(
                  //     widget.totalduration.value ?? Duration.zero,
                  //     1,
                  //   ),
                  //   style: TextStyle(
                  //     color: Colors.white.withAlpha(80),
                  //     fontSize: 12,
                  //   ),
                  // );
                  // }),
                  Text(
                    formatCurrentTime(
                      widget.totalduration.value ?? Duration.zero,
                      1,
                    ),
                    style: TextStyle(
                      color: Colors.white.withAlpha(80),
                      fontSize: 12,
                    ),
                  )
                ],
              )),
              // SizedBox(height: 40),
              // 控制按钮
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
  final Function(double, Duration) setPlayPosition;
  const Progress({
    super.key,
    required this.totalduration,
    this.currentduration,
    required this.progressController,
    required this.progressAnimation,
    required this.setPlayPosition
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
                    // return LinearProgressIndicator(
                    //   value: widget.progressAnimation.value,
                    //   backgroundColor: Colors.white.withAlpha(20),
                    //   valueColor: const AlwaysStoppedAnimation<Color>(
                    //     Colors.white,
                    //   ),
                    //   minHeight: 2,
                    //   borderRadius: BorderRadius.circular(1),
                    // );
                    return SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 5
                        ),
                        overlayColor: Colors.transparent,
                      ),
                      child: Slider(
                        padding: EdgeInsets.zero, 
                        value: widget.progressAnimation.value,
                        min: 0,
                        max: 1,
                        onChanged: (value) {
                          if (!value.isFinite) return;
                          widget.progressController.value = value;
                        },
                        onChangeEnd: (value) {
                          if (!value.isFinite) return;
                          final total = widget.totalduration.value;
                          if(total == null || total.inMilliseconds <= 0 ) return;
                          widget.setPlayPosition(value, Duration(milliseconds: (total.inMilliseconds * value).round()));
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.white.withAlpha(20),
                      ),
                    );
                  },
                ),
              ),
              // Positioned(
              //   left: 0,
              //   top: 0,
              //   child: AnimatedBuilder(
              //     animation: widget.progressAnimation,
              //     builder: (context, _) {
              //       return Transform.translate(
              //         offset: Offset(width * widget.progressAnimation.value, 0),
              //         child: Container(
              //           width: dotsize,
              //           height: dotsize,
              //           decoration: const BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Colors.white,
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
