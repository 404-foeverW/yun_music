// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yun_music/components/musicplayer.dart';

class TabBarList extends StatefulWidget {
  final player;
  final Duration fristDuration;
  const TabBarList({
    super.key,
    required this.player,
    required this.fristDuration,
  });

  @override
  State<TabBarList> createState() => _TabBarListState();
}

class _TabBarListState extends State<TabBarList> {
  int currentIndex = 0;
  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Map<String, dynamic>> tabBarList = [
    {'title': '首页', 'index': 0},
    {'title': '搜索', 'index': 1},
    {'title': '笔记', 'index': 2},
    {'title': '我的', 'index': 3},
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
            current: currentIndex,
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
                      color: currentIndex == index
                          ? Colors.black
                          : Color.fromRGBO(0, 0, 0, 0.2),
                      fontSize: 16,
                      fontWeight: currentIndex == index
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