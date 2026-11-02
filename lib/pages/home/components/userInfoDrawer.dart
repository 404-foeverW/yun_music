// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/store/index.dart';

class Userinfodrawer extends StatefulWidget {
  const Userinfodrawer({super.key});

  @override
  State<Userinfodrawer> createState() => _UserinfodrawerState();
}

class _UserinfodrawerState extends State<Userinfodrawer> {
  final deviceInfo = Get.find<DeviceInfoService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: deviceInfo.statusBarHeight,
        // bottom: deviceInfo.bottomSafeAreaHeight,
      ),
      color: Color.fromRGBO(211, 211, 211, 0.6),
      child: Column(
        children: [
          HeaderInfo(),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [MemberColumn(), SizedBox(height: 20), MenuList()],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: deviceInfo.bottomSafeAreaHeight,
                    ),
                    // color: Colors.white.withValues(alpha: .5),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(248, 248, 255, 1),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0, -10),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(248, 248, 255, 1),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(-10, 0),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(248, 248, 248, 1),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(10, 0),
                        ),
                      ],
                      color: const Color.fromRGBO(248, 248, 248, 1),
                    ),
                    child: Flex(
                      direction: Axis.horizontal,
                      spacing: 20,
                      children: [
                        Expanded(
                          child: PressMask(
                            maskOpacity: 1,
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Flex(
                                mainAxisAlignment: MainAxisAlignment.center,
                                direction: Axis.horizontal,
                                spacing: 5,
                                children: [
                                  SvgPicture.asset(
                                    'lib/assets/icon/shezhi.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                  Text(
                                    '设置',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: PressMask(
                            maskOpacity: 1,
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Flex(
                                mainAxisAlignment: MainAxisAlignment.center,
                                direction: Axis.horizontal,
                                spacing: 5,
                                children: [
                                  SvgPicture.asset(
                                    'lib/assets/icon/gengduo.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                  Text(
                                    '更多',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 菜单栏
class Menu {
  String? iconPath;
  double? iconwidth;
  double? iconheight;
  Widget? icon;
  String title;
  Widget? subWidget;

  Menu({
    this.iconPath,
    this.icon,
    required this.title,
    this.subWidget,
    this.iconwidth = 25,
    this.iconheight = 25,
  });
}

class MenuList extends StatefulWidget {
  const MenuList({super.key});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  List<Map<String, dynamic>> menuList = [
    {
      "children": [
        Menu(
          iconPath: "lib/assets/icon/mianfei.svg",
          title: "免费听VIP歌曲",
          subWidget: TextButton(
            style: ButtonStyle(
              minimumSize: WidgetStatePropertyAll(Size(0, 0)),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              ),
              side: WidgetStateProperty.all(BorderSide(color: Colors.red)),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {},
            child: Text(
              '一键开启',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ),
      ],
    },
    {
      "children": [
        Menu(
          iconPath: "lib/assets/icon/a-xiaoxiquanbuxiaoxi-copy.svg",
          iconheight: 20,
          iconwidth: 20,
          title: "我的消息",
          subWidget: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '99+',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        Menu(
          iconPath: "lib/assets/icon/beike.svg",
          title: "我的云贝",
          subWidget: Text(
            '免费兑换黑胶VIP',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Menu(
          iconPath: "lib/assets/icon/gexingzhuangban.svg",
          title: "装扮中心",
          subWidget: Text(
            '普通小狗收藏卡空降',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Menu(iconPath: "lib/assets/icon/chuangzuozhongxin.svg", title: "创作者中心"),
      ],
    },
    {
      "children": [
        Menu(
          iconPath: "lib/assets/icon/zuijinbofang.svg",
          title: "最近播放",
          subWidget: Text(
            '5台设备登录',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Menu(iconPath: "lib/assets/icon/dingshiguanbi-01.svg", title: "定时关闭"),
      ],
    },
    {
      "children": [
        Menu(iconPath: "lib/assets/icon/shangcheng.svg", title: "商城"),
        Menu(iconPath: "lib/assets/icon/piaoju.svg", title: "云村有票"),
        Menu(
          iconPath: "lib/assets/icon/mulmcloudmusic.svg",
          title: "云推歌",
          iconheight: 20,
          iconwidth: 20,
        ),
        Menu(iconPath: "lib/assets/icon/wodekefu.svg", title: "我的客服"),
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        spacing: 10,
        children: menuList.map<Widget>((item) {
          return Container(
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.withAlpha(50), width: 1),
              ),
            ),
            child: Column(
              children: item['children']!.map<Widget>((Menu e) {
                return PressMask(
                  maskOpacity: 1,
                  child: Container(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            e.iconPath != null
                                ? SvgPicture.asset(
                                    e.iconPath!,
                                    width: e.iconwidth,
                                    height: e.iconheight,
                                  )
                                : e.icon ?? Container(),
                            SizedBox(width: 10),
                            Text(
                              e.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        e.subWidget ?? Container(),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 会员专栏
class MemberColumn extends StatefulWidget {
  const MemberColumn({super.key});

  @override
  State<MemberColumn> createState() => _MemberColumnState();
}

class _MemberColumnState extends State<MemberColumn> {
  List<Map<String, dynamic>> activeList = [
    {
      'icon': 'lib/assets/icon/member_icon_1.svg',
      'title': '每日打卡，加速等级成长',
      'btnText': '去打卡',
    },
    {
      'icon': 'lib/assets/icon/member_icon_2.svg',
      'title': '限时福利，一分钟领会员!',
      'btnText': '立享特惠',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(72, 61, 139, 0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        spacing: 40,
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        // Expanded(child: Text('黑胶VIP期待你的加入', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        Text(
                          '黑胶VIP期待你的加入',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Icon(
                          CupertinoIcons.chevron_forward,
                          color: Colors.white,
                          size: 12,
                        ),
                      ],
                    ),
                    Text(
                      '续费立享20+项会员特权',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  ),
                  minimumSize: WidgetStateProperty.all(Size(0, 0)),
                ),
                child: Text(
                  '优惠开通',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 30.0,
              scrollDirection: Axis.vertical,
              autoPlay: true,
            ),
            items: activeList.map((item) {
              return PressMask(
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          // Icon(Icons.circle, color: Colors.white, size: 10),
                          Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          item['btnText'],
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// 用户信息
class HeaderInfo extends StatefulWidget {
  const HeaderInfo({super.key});

  @override
  State<HeaderInfo> createState() => _HeaderInfoState();
}

class _HeaderInfoState extends State<HeaderInfo> {
  // double alpha = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                CachedNetworkImage(
                  imageUrl: '',
                  width: 30,
                  height: 30,
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: Color.fromRGBO(255, 240, 245, 1),
                    child: Icon(
                      CupertinoIcons.person_fill,
                      color: Color.fromRGBO(255, 182, 193, 1),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.transparent;
                      }
                      return Colors.black;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((state) {
                      if (state.contains(WidgetState.pressed)) {
                        return Colors.black.withValues(alpha: 0.3); // 按下变浅
                      }
                      return Colors.black;
                    }),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        '背景牌',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(CupertinoIcons.chevron_forward),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            spacing: 20,
            children: [
              PressMask(
                onTap: () {},
                maskColor: Colors.transparent,
                child: SvgPicture.asset(
                  'lib/assets/icon/tinggeshiqu.svg',
                  width: 25,
                  height: 25,
                ),
              ),
              PressMask(
                onTap: () {},
                maskColor: Colors.transparent,
                child: SvgPicture.asset(
                  'lib/assets/icon/saoyisao.svg',
                  width: 25,
                  height: 25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PressMask extends StatefulWidget {
  final Widget child;
  final Color maskColor; // 遮罩颜色
  final double maskOpacity; // 遮罩强度
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PressMask({
    super.key,
    required this.child,
    this.maskColor = Colors.white,
    this.maskOpacity = 0.4,
    this.borderRadius,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<PressMask> createState() => _PressMaskState();
}

class _PressMaskState extends State<PressMask> {
  bool _pressed = false;

  void _update(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _update(true),
      onTapUp: (_) => _update(false),
      onTapCancel: () => _update(false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: _pressed ? 0.5 : 1,
            duration: const Duration(milliseconds: 100),
            child: ClipRRect(child: widget.child),
          ),
        ],
      ),
    );
  }
}
