// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ContentAnimation extends StatefulWidget {
  final AnimationController toneArmController;
  final AnimationController recordController;
  const ContentAnimation({
    super.key,
    required this.toneArmController,
    required this.recordController,
  });

  @override
  State<ContentAnimation> createState() => _ContentAnimationState();
}

class _ContentAnimationState extends State<ContentAnimation>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final deviceInfo = MediaQuery.of(context);
    double width = deviceInfo.size.width * 0.8;
    print(width);
    double subWidth = width * 0.68;
    print(subWidth);
    return SizedBox(
      width: deviceInfo.size.width,
      child: Stack(
        children: [
          Container(
            width: width,
            height: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('lib/assets/icon/play_disc_cover.png'),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 12),
            ),
            child: Transform.translate(
              offset: Offset(width / 2042, width / 2042),
              child: Container(
                width: subWidth,
                height: subWidth,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 5),
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: 'https://images.weserv.nl/?url=https://p1.music.126.net/NDh4QW1TwPlG0QNh-0K_Lw==/109951173628365926.jpg?param=200y200',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
