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
  String manIcon = 'lib/assets/icon/nansheng-copy.svg';
  String womanIcon = 'lib/assets/icon/tubiaozhizuomoban.svg';
  Color manColor = Color.fromRGBO(88, 183, 233, 1);
  Color womanColor = Color.fromRGBO(207, 120, 173, 1);

  List<Map<String, dynamic>> operatorList = [
    {'icon': 'lib/assets/icon/zuijinbofang.svg', 'text': '最近'},
    {'icon': 'lib/assets/icon/xiazai2.svg', 'text': '本地'},
    {'icon': 'lib/assets/icon/vipSolid01.svg', 'text': '会员'},
    {'icon': 'lib/assets/icon/gexingzhuangban.svg', 'text': '装扮'},
    {'icon': 'lib/assets/icon/gengduo.svg', 'text': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      margin: EdgeInsets.only(bottom: 20),
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
          SizedBox(height: 10),
          Row(
            spacing: 3,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Baseline(
                baseline: 20,
                baselineType: TextBaseline.alphabetic,
                child: SvgPicture.asset(
                  manIcon,
                  width: 16,
                  height: 16,
                  color: manColor,
                ),
              ),
              Text(
                '.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Baseline(
                baseline: 22,
                baselineType: TextBaseline.alphabetic,
                child: SvgPicture.asset(
                  'lib/assets/icon/huizhang.svg',
                  width: 16,
                  height: 16,
                  color: Colors.grey,
                ),
              ),
              Baseline(
                baseline: 18,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  '12枚徽章',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Flex(
            spacing: 15,
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '关注',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '粉丝',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Lv.9',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '1601',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '小时',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Flex(
            spacing: 12,
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...operatorList.map((item) {
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromRGBO(74, 66, 66, 1),
                  ),
                  child: Flex(direction: Axis.horizontal, children: [
                    SvgPicture.asset(item['icon'], width: 20, height: 20, color: Colors.white),
                    if(item['text'] != '')
                    SizedBox(width: 5),
                    Text(
                      item['text'],
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ])
                );
              }),
              // Container(
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     color: Color.fromRGBO(74, 66, 66, 1),
              //   ),
              //   child: Flex(direction: Axis.horizontal, children: [
              //     SvgPicture.asset('lib/assets/icon/zuijinbofang.svg', width: 20, height: 20, color: Colors.white),
              //     SizedBox(width: 5),
              //     Text(
              //       '最近',
              //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //     )
              //   ])
              // )
            ]
          )
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
  late AnimationController moveController;

  /// 当前目标颜色，AnimatedContainer 会自动过渡
  final List<Color> _defaultColors = [Colors.grey, Colors.grey, Colors.grey];
  final List<Color> _targetColors = [
    Color.fromRGBO(37, 30, 30, 1),
    Color.fromRGBO(63, 52, 52, 1),
    Color.fromRGBO(74, 66, 66, 1),
  ];
  final Color _defaultSvgColor = Colors.grey;
  final Color _activeSvgColor = Colors.black;

  List<Color> _targetColor = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
  ];
  Color svgColor = Colors.grey;
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
    moveAnimation = Tween(
      begin: 0.0,
      end: 0.35,
    ).animate(CurvedAnimation(parent: moveController, curve: Curves.easeInOut));

    roteAnimation = moveAnimation.drive(
      Tween(begin: 0.0, end: math.pi * 2 * _turnsPerMove),
    );

    _runLoop();
  }

  Future<void> _runLoop() async {
    bool isGrey = true;
    while (!_disposed && mounted) {
      // ① 原位 → 最大位置
      if (!await _forward()) return;
      if (!mounted || _disposed) return;

      // ② 颜色：透明 → 灰
      setState(() {
        _targetColor = isGrey ? _defaultColors : _targetColors;
        svgColor = isGrey ? _defaultSvgColor : _activeSvgColor;
      });
      await Future.delayed(const Duration(milliseconds: 500)); // 等颜色过渡

      // ③ 最大位置 → 原位
      if (!await _reverse()) return;
      if (!mounted || _disposed) return;

      // ⑦ 等待几秒
      await Future.delayed(const Duration(seconds: 30));
      isGrey = !isGrey;
    }
  }

  Future<bool> _forward() async {
    try {
      await moveController.forward(from: 0);
      return true;
    } on TickerCanceled {
      return false; // dispose 时动画被取消
    }
  }

  Future<bool> _reverse() async {
    try {
      await moveController.reverse();
      return true;
    } on TickerCanceled {
      return false; // dispose 时动画被取消
    }
  }

  @override
  void dispose() {
    _disposed = true;
    moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VipWidget(
      moveAnimation: moveAnimation,
      roteAnimation: roteAnimation,
      targetColor: _targetColor,
      svgColor: svgColor,
    );
  }
}

class VipWidget extends AnimatedWidget {
  final Animation<double> moveAnimation;
  final Animation<double> roteAnimation;
  final List<Color> targetColor;
  final Color svgColor;

  final double width = 125;
  final double height = 20;

  VipWidget({
    Key? key,
    required this.moveAnimation,
    required this.roteAnimation,
    required this.targetColor,
    required this.svgColor,
  }) : super(
         key: key,
         listenable: Listenable.merge([moveAnimation, roteAnimation]),
       );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width + 10,
      height: height + 15,
      child: Stack(
        children: [
          Positioned(
            top: 8,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: width,
              height: height,
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.2, 0.4, 1],
                  colors: targetColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 5,
                children: [
                  Text(
                    "VIP",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
          ),
          Positioned(
            top: 8,
            child: Transform.translate(
              offset: Offset(moveAnimation.value * width, -5),
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
                    'lib/assets/icon/yinleguangpan.svg',
                    fit: BoxFit.cover,
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
