// ignore_for_file: avoid_print

import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/store/musicplay.dart';

class ContentAnimation extends StatefulWidget {
  final AnimationController toneArmController;
  final AnimationController recordController;
  final Animation<double> toneArmAnimation;
  final Animation<double> recordAnimation;
  final double radius;
  final Rxn<Song> currentmusic;
  final List<SongBrief> songList;

  const ContentAnimation({
    super.key,
    required this.toneArmController,
    required this.recordController,
    required this.toneArmAnimation,
    required this.recordAnimation,
    required this.radius,
    required this.currentmusic,
    required this.songList,
  });

  @override
  State<ContentAnimation> createState() => _ContentAnimationState();
}

class _ContentAnimationState extends State<ContentAnimation>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final deviceInfo = MediaQuery.of(context);
    double width = deviceInfo.size.width * 0.75;
    double subWidth = width * 0.68;
    double armwith = 120;
    double armHeight = 190;
    return Container(
      width: deviceInfo.size.width,
      height: deviceInfo.size.height * 0.6,
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.white, width: 1.2),
      // ),
      child: Center(
        child: SizedBox(
          width: deviceInfo.size.width,
          height: width + 120,
          child: Stack(
            children: [
              // 唱片
              Positioned(
                left: width / 2 - subWidth / 2 - 15,
                top: 110,
                child: Container(
                  width: width,
                  height: width,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        width: width,
                        height: width,
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   color: Colors.white.withAlpha(20),
                          //   width: 1.2,
                          // ),
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha(10),
                        ),
                      ),
                      Positioned(
                        child: AnimatedBuilder(
                          animation: widget.recordAnimation,
                          builder: (context, _) {
                            return Transform.rotate(
                              angle: widget.recordAnimation.value,
                              child: Container(
                                width: width,
                                height: width,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'lib/assets/icon/play_disc_cover.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: subWidth,
                                  height: subWidth,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 5,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          'https://images.weserv.nl/?url=${widget.currentmusic.value?.coverUrl}',
                                      httpHeaders: {
                                        'Referer': 'https://music.163.com/',
                                        'sec-ch-ua-platform': '"Windows"',
                                        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0',
                                      },
                                    ),
                                  ),
                                ),
                                // child: Image.asset('lib/assets/icon/play_disc_cover.png'),
                              ),
                            );
                          },
                        ),
                      ),
                      // Positioned(
                      //   top: width / 2 - subWidth / 2,
                      //   left: width / 2 - subWidth / 2,
                      //   child: Container(
                      //       width: subWidth,
                      //       height: subWidth,
                      //        decoration: BoxDecoration(
                      //        border: Border.all(color: Colors.black, width: 5),
                      //        shape: BoxShape.circle,
                      //        ),
                      //       child: ClipRRect(
                      //         borderRadius: BorderRadius.circular(1000),
                      //         child: CachedNetworkImage(
                      //         fit: BoxFit.cover,
                      //         imageUrl: 'https://images.weserv.nl/?url=https://p1.music.126.net/NDh4QW1TwPlG0QNh-0K_Lw==/109951173628365926.jpg?param=200y200',
                      //       )
                      //       ),
                      //     ),
                      // ),
                    ],
                  ),
                ),
              ),
              // 唱片臂
              Positioned(
                left: width / 2 + 8,
                child: AnimatedBuilder(
                  animation: widget.toneArmAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      alignment: Alignment.topLeft,
                      origin: Offset(30, 30),
                      angle: widget.toneArmAnimation.value,
                      child: Container(
                        width: armwith,
                        height: armHeight,
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //     color: Colors.white.withAlpha(20),
                        //     width: 1.2,
                        //   ),
                        // ),
                        child: Image.asset(
                          'lib/assets/icon/play_needle_play.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
