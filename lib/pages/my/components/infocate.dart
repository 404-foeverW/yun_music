// ignore_for_file: avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Cate {
  String title;
  String? iconPath;
  bool? isShowNotic;
  int? noticNum;

  Cate({
    required this.title,
    this.isShowNotic = false,
    this.iconPath = '',
    this.noticNum = 0,
  });
}

class InfoCate extends SliverPersistentHeaderDelegate {
  final double containerHeight = 120;
  final GlobalKey headerKey;
  final double minExtentHeight;
  final ValueNotifier<bool> isPinnedNotifier; // 是否固定

  InfoCate({
    required this.headerKey,
    required this.minExtentHeight,
    required this.isPinnedNotifier,
  });

  List<Cate> cateList = [
    Cate(title: '音乐'),
    Cate(title: '播客'),
    Cate(title: '笔记'),
  ];
  int currentIndex = 0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ValueListenableBuilder(
      valueListenable: isPinnedNotifier,
      builder: (context, isPinned, _) {
        double radius = isPinned ? 0 : 10;
        return Container(
          key: headerKey,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
          ),
          child: TabsParant(
            minExtentHeight: minExtentHeight,
            cateList: cateList,
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => minExtentHeight;

  @override
  double get minExtent => minExtentHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return currentIndex != (oldDelegate as InfoCate).currentIndex;
  }
}

class TabsParant extends StatefulWidget {
  final double minExtentHeight;
  final List<Cate> cateList;
  const TabsParant({
    super.key,
    required this.minExtentHeight,
    required this.cateList,
  });

  @override
  State<TabsParant> createState() => _TabsParantState();
}

class _TabsParantState extends State<TabsParant> {
  int currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.minExtentHeight * 0.1,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.cateList.length, (index) {
              return Container(
                child: GestureDetector(
                  onTap: () {
                    currentIndex = index;
                    _controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300), 
                      curve: Curves.easeInOut,
                    );
                    setState(() {});
                    print(widget.cateList[index].title);
                  },
                  child: Text(
                    widget.cateList[index].title,
                    style: TextStyle(
                      fontSize: 21,
                      color: currentIndex == index ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        CarouselSlider.builder(
          carouselController: _controller, // 绑定
          options: CarouselOptions(
            height: widget.minExtentHeight * 0.9,
            onPageChanged:(index, reason) {
              currentIndex = index;
              setState(() {});
            },
          ),
          itemCount: widget.cateList.length,
          itemBuilder: (context, index, realIndex) {
            return Container(child: Text(widget.cateList[index].title));
          },
        ),
      ],
    );
  }
}
