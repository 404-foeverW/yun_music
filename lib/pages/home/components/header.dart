// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderMenu extends SliverPersistentHeaderDelegate {
  final double statusBarHeight; // 状态栏高度
  final double contentHeight; // 内容区高度
  final Color backgroundColor;
  final GlobalKey<ScaffoldState> scaffoldkey;

  HeaderMenu({
    required this.statusBarHeight,
    required this.contentHeight,
    required this.backgroundColor,
    required this.scaffoldkey,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return HeaderItems(
      statusBarHeight: statusBarHeight,
      contentHeight: contentHeight,
      backgroundColor: backgroundColor,
      scaffoldkey: scaffoldkey,
    );
  }

  @override
  double get maxExtent => contentHeight;

  @override
  double get minExtent => contentHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class HeaderItems extends StatefulWidget {
  final double statusBarHeight; // 状态栏高度
  final double contentHeight; // 内容区高度
  final Color backgroundColor;
  final GlobalKey<ScaffoldState> scaffoldkey;
  const HeaderItems({super.key, this.statusBarHeight = 0, this.contentHeight = 0, this.backgroundColor = Colors.white, required this.scaffoldkey});

  @override
  State<HeaderItems> createState() => _HeaderItemsState();
}

class _HeaderItemsState extends State<HeaderItems> {
  int _curretntIndex = 0;

  final List<Map<String, dynamic>> _menuList = [
    {'title': '心动', 'path': '/', 'index': 0, 'style': null},
    {'title': '推荐', 'path': '/', 'index': 1, 'style': null},
    {'title': '音乐', 'path': '/', 'index': 2, 'style': null},
    {'title': '新人有礼', 'path': '/', 'index': 3, 'style': null},
    {'title': '播客', 'path': '/', 'index': 4, 'style': null},
    {'title': '听书', 'path': '/', 'index': 5, 'style': null},
    {'title': '免费听', 'path': '/', 'index': 6, 'style': null},
  ];

  final SvgPicture _leftMenu = SvgPicture.asset(
    'lib/assets/icon/danlieliebiao.svg',
    width: 30,
    height: 30,
  );
  final SvgPicture _search = SvgPicture.asset(
    'lib/assets/icon/sousuo1.svg',
    width: 30,
    height: 30,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Android 图标
        statusBarBrightness: Brightness.dark, // iOS 图标  // 让 header 背景透上来
      ),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: widget.statusBarHeight),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          spacing: 10,
          children: [
            GestureDetector(onTap: () {
              widget.scaffoldkey.currentState?.openDrawer();
            }, child: _leftMenu),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _menuList.map((item) {
                  return GestureDetector(
                    onTap: () {
                      _curretntIndex = item['index'];
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 3.5,
                            color: _curretntIndex == item['index']
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Text(
                        item['title'],
                        style: TextStyle(
                          color: _curretntIndex == item['index']
                              ? Colors.black
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            GestureDetector(onTap: () {}, child: _search),
          ],
        ),
      ),
    );
    // return SafeArea(
    //   child: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 10),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //     ),
    //     child: Row(
    //       spacing: 10,
    //       children: [
    //         GestureDetector(onTap: () {}, child: _leftMenu),
    //         Expanded(
    //           child: ListView(
    //             scrollDirection: Axis.horizontal,
    //             children: _menuList.map((item) {
    //               return GestureDetector(
    //                 onTap: () {
    //                   _curretntIndex = item['index'];
    //                   setState(() {});
    //                 },
    //                 child: Container(
    //                   alignment: Alignment.center,
    //                   margin: EdgeInsets.symmetric(horizontal: 10),
    //                   decoration: BoxDecoration(
    //                     border: Border(
    //                       bottom: BorderSide(
    //                         width: 3.5,
    //                         color: _curretntIndex == item['index']
    //                             ? Colors.black
    //                             : Colors.transparent,
    //                       ),
    //                     ),
    //                   ),
    //                   child: Text(
    //                     item['title'],
    //                     style: TextStyle(
    //                       color: _curretntIndex == item['index']
    //                           ? Colors.black
    //                           : Colors.grey,
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: 18,
    //                     ),
    //                   ),
    //                 ),
    //               );
    //             }).toList(),
    //           ),
    //         ),
    //         GestureDetector(onTap: () {}, child: _search),
    //       ],
    //     ),
    //   ),
    // );
  }
}
