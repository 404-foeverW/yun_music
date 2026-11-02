import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserInfoBody extends StatefulWidget {
  const UserInfoBody({super.key});

  @override
  State<UserInfoBody> createState() => _UserInfoBodyState();
}

class _UserInfoBodyState extends State<UserInfoBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: '',
            width: 90,
            height: 90,
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: Color.fromRGBO(255, 240, 245, 1),
              child: Icon(
                CupertinoIcons.person_fill,
                color: Color.fromRGBO(255, 182, 193, 1),
                size: 40,
              ),
            ),
          ),
          SizedBox(height: 16),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Text('背景牌', style: TextStyle(color: Colors.white, fontSize: 24)),
              VipAnimation(),
            ],
          ),
        ],
      ),
    );
  }
}

// vip动画
class VipAnimation extends StatefulWidget {
  const VipAnimation({super.key});

  @override
  State<VipAnimation> createState() => _VipAnimationState();
}

class _VipAnimationState extends State<VipAnimation>
    with TickerProviderStateMixin {
  late Animation<double> moveAnimation;
  late Animation<double> roteAnimation;
  // late Animation<Color?> colorAnimation;
  late AnimationController moveController;
  // late AnimationController rotateController;

  /// 当前目标颜色，AnimatedContainer 会自动过渡
  Color? _targetColor = Colors.transparent;
  bool _disposed = false;

  static const double _turnsPerMove = 1.0;

  @override
  void initState() {
    super.initState();
    // 移动 + 颜色：来回
    moveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // 旋转：持续单向
    // rotateController = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // );
    moveAnimation = Tween(
      begin: 0.0,
      end: 0.4,
    ).animate(CurvedAnimation(parent: moveController, curve: Curves.easeInOut));

    roteAnimation = moveAnimation.drive(
      Tween(begin: 0.0, end: math.pi * 2 * _turnsPerMove),
    );

    // roteAnimation = Tween(
    //   begin: 0.0,
    //   end: math.pi * 2,
    // ).animate(rotateController);
    // colorAnimation = ColorTween(
    //   begin: Colors.transparent,
    //   end: Colors.grey,
    // ).animate(moveController);

    // animationController.forward();

    _runLoop();
  }

  Future<void> _runLoop() async {
    bool isGrey = true;
    while(!_disposed && mounted) {
      // ① 原位 → 最大位置
    if (!await _forward()) return;
    if (!mounted || _disposed) return;

    // ② 颜色：透明 → 灰
    setState(() => _targetColor = isGrey ? Colors.grey : Colors.transparent);
    await Future.delayed(const Duration(milliseconds: 500)); // 等颜色过渡

    // ③ 最大位置 → 原位
    if (!await _reverse()) return;
    if (!mounted || _disposed) return;

    // ⑦ 等待几秒
    await Future.delayed(const Duration(seconds: 10));
    isGrey = !isGrey;
    }
  }

  Future<bool> _forward() async {
    try {
      await moveController.forward(from: 0);
      // await rotateController.forward(from: 0);
      return true;
    } on TickerCanceled {
      return false; // dispose 时动画被取消
    }
  }

  Future<bool> _reverse() async {
    try {
      await moveController.reverse();
      // await rotateController.reverse();
      return true;
    } on TickerCanceled {
      return false; // dispose 时动画被取消
    }
  }

  @override
  void dispose() {
    _disposed = true;
    moveController.dispose();
    // rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VipWidget(
      moveAnimation: moveAnimation,
      roteAnimation: roteAnimation,
      // colorAnimation: colorAnimation,
      targetColor: _targetColor,
    );
  }
}

class VipWidget extends AnimatedWidget {
  final Animation<double> moveAnimation;
  final Animation<double> roteAnimation;
  // final Animation<Color?> colorAnimation;
  final Color? targetColor;   

  final double width = 125;
  final double height = 20;

  VipWidget({
    Key? key,
    required this.moveAnimation,
    required this.roteAnimation,
    // required this.colorAnimation,
    required this.targetColor,
  }) : super(
         key: key,
         listenable: Listenable.merge([
           moveAnimation,
           roteAnimation,
          //  colorAnimation,
         ]),
       );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400), 
          width: width,
          height: height,
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            // color: colorAnimation.value,
            color: targetColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 5,
            children: [
              Text("VIP", style: TextStyle(color: Colors.white, fontSize: 12)),
              SizedBox(width: 4),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Text(
                    '￥1开通',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Icon(
                    CupertinoIcons.chevron_forward,
                    color: Colors.white,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(moveAnimation.value * width, 0),
          // origin: Offset((height + 10) / 2, (height + 10) / 2),
          child: Transform.rotate(
            angle: roteAnimation.value,
            child: Container(
              width: height + 10,
              height: height + 10,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'lib/assets/icon/guangpu.svg',
                width: height + 10,
                height: height + 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
