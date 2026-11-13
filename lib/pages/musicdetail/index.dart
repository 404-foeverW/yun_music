import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/pages/musicdetail/componets/contentAnimation.dart';
import 'package:yun_music/pages/musicdetail/componets/freeAnimation.dart';
import 'package:yun_music/store/index.dart';

class MusicDetail extends StatefulWidget {
  const MusicDetail({super.key});

  @override
  State<MusicDetail> createState() => _MusicDetailState();
}

class _MusicDetailState extends State<MusicDetail> with TickerProviderStateMixin {
  final deviceInfo = Get.find<DeviceInfoService>();
  static const Color _color1 = Color.fromRGBO(211, 211, 211, 1);
  static const Color _color2 = Colors.white;
  static const Color _color3 = Color.fromRGBO(15, 20, 32, 1);

  late final AnimationController _toneArmController;
  late final AnimationController _recordController;

  @override
  void initState() {
    super.initState();
    _toneArmController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _recordController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
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
          ),
        ],
      ),
    );
  }
}
