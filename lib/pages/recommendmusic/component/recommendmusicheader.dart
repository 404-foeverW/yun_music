// 头部组件
// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecommendMusicHeader extends SliverPersistentHeaderDelegate {
  final double statusBarHeight; // 状态栏高度
  final double contentHeight; // 内容区高度
  final double deviceHeight; // 设备高度
  final double devicewidth; // 设备宽度

  RecommendMusicHeader({
    required this.statusBarHeight,
    required this.contentHeight,
    required this.deviceHeight,
    required this.devicewidth,
  });

  @override
  double get maxExtent => deviceHeight * 0.35;

  @override
  double get minExtent => contentHeight + 10;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // print(shrinkOffset);
    Color color1 = Color.fromRGBO(234, 129, 102, 1);
    Color color2 = Color.fromRGBO(255, 255, 255, 1);
    bool scopeOfDetermination = shrinkOffset == deviceHeight * 0.35;
    List<Color> headerbg = [color1, color2];
    final maxShrink = maxExtent - minExtent;
    final double progress = maxShrink == 0
        ? 1.0
        : (shrinkOffset / maxShrink).clamp(0.0, 1.0);
    final double reverseprogress = maxShrink == 0
        ? 1.0
        : (1 - progress);  
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.8, 1],
                colors: headerbg,
              ),
            ),
          ),
        ),
        // 上层：纯色，随滚动渐显
        Positioned.fill(child: Container(color: Color.fromRGBO(234, 129, 102, progress))),
        Positioned(
          width: devicewidth,
          bottom: 70,
          child: MyHeaderContent(
            scopeOfDetermination: scopeOfDetermination,
            progress: reverseprogress,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: contentHeight,
          child: MyHeaderAppBar(
            statusBarHeight: statusBarHeight,
            contentHeight: contentHeight,
          ),
        ),
      ],
    );
  }
}

// 内容区
class MyHeaderContent extends StatefulWidget {
  final bool scopeOfDetermination;
  final double progress;
  const MyHeaderContent({
    super.key,
    required this.scopeOfDetermination,
    required this.progress,
  });

  @override
  State<MyHeaderContent> createState() => _MyHeaderContentState();
}

class _MyHeaderContentState extends State<MyHeaderContent> {
  final SvgPicture _svgPicture = SvgPicture.asset(
    'lib/assets/icon/opticaldisc.svg',
    width: 14,
    height: 14,
  );
  final DateTime now = DateTime.now();
  int month = 0;
  int day = 0;

  @override
  void initState() {
    super.initState();
    month = now.month;
    day = now.day;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.progress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 左侧内容部分
            Flex(
              direction: Axis.vertical,
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: day.toString(),
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: '/',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      TextSpan(
                        text: month.toString(),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('点击了日历');
                  },
                  child: Flex(
                    direction: Axis.horizontal,
                    spacing: 2,
                    children: [
                      Text(
                        '查看今日运势',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Icon(
                        CupertinoIcons.chevron_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, .2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Flex(
                direction: Axis.horizontal,
                spacing: 6,
                children: [
                  Text('历史日推', style: TextStyle(color: Colors.white)),
                  SizedBox(
                    width: 47,
                    height: 30,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 5,
                          left: 2,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            width: 45,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'VIP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // color: Color.fromRGBO(0, 0, 0, .2),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsetsGeometry.all(1),
                            child: _svgPicture,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 状态栏
class MyHeaderAppBar extends StatefulWidget {
  final double statusBarHeight; // 状态栏高度
  final double contentHeight; // 内容区高度

  const MyHeaderAppBar({
    super.key,
    required this.statusBarHeight,
    required this.contentHeight,
  });

  @override
  State<MyHeaderAppBar> createState() => _MyHeaderAppBarState();
}

class _MyHeaderAppBarState extends State<MyHeaderAppBar> {
  final SvgPicture _arrow = SvgPicture.asset(
    'lib/assets/icon/leftarrow.svg',
    width: 30,
    height: 30,
  );
  // final SvgPicture _share = SvgPicture.asset(
  //   'lib/assets/icon/sangediandian-white.svg',
  //   width: 30,
  //   height: 30,
  // );

  // 推荐风格
  final List<String> styleList = ['默认推荐', '风格推荐'];
  List<Widget> _buildStyleList() {
    return List.generate(styleList.length, (index) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            print(index);
            setCurrentStyle(index);
            setState(() {});
          },
          child: Text(
            styleList[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: index == currentStyle
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: index == currentStyle
                  ? const Color.fromARGB(255, 21, 21, 21)
                  : Colors.white,
            ),
          ),
        ),
      );
    });
  }

  // 当前推荐风格
  int currentStyle = 0;
  void setCurrentStyle(int style) {
    currentStyle = style;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: widget.statusBarHeight,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 30,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            // icon: _arrow,
            icon: SvgPicture.asset(
              'lib/assets/icon/leftarrow.svg',
              width: 30,
              height: 30,
            )
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxWidth: 610),
              padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              height: widget.contentHeight,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, .2),
                borderRadius: BorderRadius.circular(45),
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // double width = constraints.maxWidth;
                  return Stack(
                    children: [
                      AnimatedAlign(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        alignment: currentStyle != 0
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 0.5, // 父级宽度的 50%
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 254),
                              borderRadius: BorderRadius.circular(45),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [..._buildStyleList()],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          PopupMenu()
          // IconButton(onPressed: () {
          // }, icon: _share)
          // PopupMenuButton(
          //   itemBuilder:(context) {
          //     return [
          //       PopupMenuItem(
          //         child: Flex(direction: Axis.horizontal, children: [])
          //       )
          //     ];
          //   },
          // )
        ],
      ),
    );
  }
}

class PopupMenu extends StatefulWidget {
  const PopupMenu({super.key});

  @override
  State<PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  // final SvgPicture _share = SvgPicture.asset(
  //   'lib/assets/icon/sangediandian-white.svg',
  //   width: 30,
  //   height: 30,
  // );

  List<Map<String, dynamic>> menuList = [
    {
      'icon': 'lib/assets/icon/sangediandian-white.svg',
      'text': '日推评价',
      'value': '1'
    },
    {
      'icon': 'lib/assets/icon/sangediandian-white.svg',
      'text': '常见问题解答',
      'value': '2'
    },
    {
      'icon': 'lib/assets/icon/sangediandian-white.svg',
      'text': '音乐黑名单',
      'value': '3'
    }
  ];

  List<PopupMenuEntry<String>> widgetList = [];

  @override
  void initState() {
    super.initState();
    widgetList = menuList.map((e) {
      return PopupMenuItem<String>(
        value: e['value'],
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Flex(
          spacing: 10,
          direction: Axis.horizontal,
          children: [
            if(e['icon'] != '' || e['icon'] != null)
              SvgPicture.asset(e['icon'],width: 30,height: 30,),
            Text(e['text']),
          ],
        )
        ),
      );
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.white,
      itemBuilder:(context) {
        return widgetList;
      },
      // icon: _share,
      icon: SvgPicture.asset('lib/assets/icon/sangediandian-white.svg',width: 30,height: 30,),
    );
  }
}