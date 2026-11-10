// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/musicplayer.dart';
import 'package:yun_music/store/index.dart';

class TabBarList extends StatefulWidget {
  final player;
  final Duration? fristDuration;
  const TabBarList({
    super.key,
    required this.player,
    this.fristDuration,
  });

  @override
  State<TabBarList> createState() => _TabBarListState();
}

class _TabBarListState extends State<TabBarList> {
  final commondata = Get.find<CommonData>();

  // int currentIndex = 0;
  void setCurrentIndex(int index) {
    if(tabBarList[index]['path'] != null && tabBarList[index]['path'] != '') {
      // currentIndex = index;
      commondata.setCurrentTabbarIndex(index);
      Navigator.pushNamed(context, tabBarList[index]['path']);
      return;
    }
    setState(() {});
  }

  List<Map<String, dynamic>> tabBarList = [
    {'title': '首页', 'index': 0, 'path': '/'},
    {'title': '搜索', 'index': 1, 'path': '/searchPage'},
    {'title': '笔记', 'index': 2},
    {'title': '我的', 'index': 3, 'path': '/my'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color.fromRGBO(230, 230, 230, 1)],
        ),
      ),
      child: Column(
        spacing: 12,
        children: [
          MusicPlayController(
            // current: currentIndex,
            current: commondata.currentTabbarIndex,
            player: widget.player,
            fristDuration: widget.fristDuration,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabBarList.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setCurrentIndex(index);
                  },
                  child: Text(
                    tabBarList[index]['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: commondata.currentTabbarIndex == index
                          ? Colors.black
                          : Color.fromRGBO(0, 0, 0, 0.2),
                      fontSize: 16,
                      fontWeight: commondata.currentTabbarIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}