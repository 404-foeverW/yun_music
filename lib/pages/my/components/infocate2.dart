// ignore_for_file: avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Cate {
  String title;
  String? iconPath;
  bool isShowNotic;
  int? noticNum;
  Widget Function(
    BuildContext context,
    double minExtentHeight, {
    VoidCallback? onReachLeftEdge,
    VoidCallback? onReachRightEdge,
  })?
  childWidget;
  Widget Function()? listView;

  Cate({
    required this.title,
    this.isShowNotic = false,
    this.iconPath = '',
    this.noticNum = 0,
    this.childWidget,
    this.listView,
  });
}

class InfoCate extends SliverPersistentHeaderDelegate {
  final RxInt currentIndex;
  final RxInt subCurrentIndex;
  final void Function(int) onTabChange;
  final void Function(int) onSubTabChange;
  final double containerHeight = 120;
  final GlobalKey headerKey;
  final double minExtentHeight;
  final ValueNotifier<bool> isPinnedNotifier; // 是否固定

  InfoCate({
    required this.headerKey,
    required this.minExtentHeight,
    required this.isPinnedNotifier,
    required this.currentIndex,
    required this.subCurrentIndex,
    required this.onTabChange,
    required this.onSubTabChange,
  });

  List<Cate> cateList = [
    Cate(title: '音乐'),
    Cate(title: '播客'),
    Cate(title: '笔记'),
  ];

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
          child: Obx(() {
            return TabsParant(
              minExtentHeight: minExtentHeight,
              cateList: cateList,
              currentIndex: currentIndex.value,
              subCurrentIndex: subCurrentIndex.value,
              onTabChange: onTabChange,
              onSubTabChange: onSubTabChange,
            );
          }),
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
    // return (
    //   currentIndex != (oldDelegate as InfoCate).currentIndex ||
    //   subCurrentIndex != (oldDelegate as InfoCate).subCurrentIndex
    // );
    return false;
  }
}

class TabsParant extends StatefulWidget {
  final double minExtentHeight;
  final List<Cate> cateList;
  final int currentIndex;
  final int subCurrentIndex;
  final void Function(int) onTabChange;
  final void Function(int) onSubTabChange;
  const TabsParant({
    super.key,
    required this.minExtentHeight,
    required this.cateList,
    required this.currentIndex,
    required this.subCurrentIndex,
    required this.onTabChange,
    required this.onSubTabChange,
  });

  @override
  State<TabsParant> createState() => _TabsParantState();
}

class _TabsParantState extends State<TabsParant> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
          ),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.cateList.length, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: GestureDetector(
                  onTap: () {
                    widget.onTabChange(index);
                    setState(() {});
                  },
                  child: Text(
                    widget.cateList[index].title,
                    style: TextStyle(
                      fontSize: 21,
                      color: widget.currentIndex == index
                          ? Colors.black
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (widget.currentIndex == 0)
          CateMusic(
            minExtentHeight: widget.minExtentHeight,
            subCurrentIndex: widget.subCurrentIndex,
            onTabChange: widget.onTabChange,
            onSubTabChange: widget.onSubTabChange,
          ),
        if (widget.currentIndex == 1)
          CatePodcast(
            minExtentHeight: widget.minExtentHeight,
            subCurrentIndex: widget.subCurrentIndex,
            onTabChange: widget.onTabChange,
            onSubTabChange: widget.onSubTabChange,
          ),
        if (widget.currentIndex == 2)
          CateNote(minExtentHeight: widget.minExtentHeight),
      ],
    );
  }
}

// 音乐
class CateMusic extends StatefulWidget {
  final double minExtentHeight;
  final int subCurrentIndex;
  final void Function(int) onTabChange;
  final void Function(int) onSubTabChange;
  const CateMusic({
    super.key,
    required this.minExtentHeight,
    required this.subCurrentIndex,
    required this.onTabChange,
    required this.onSubTabChange,
  });

  @override
  State<CateMusic> createState() => _CateMusicState();
}

class _CateMusicState extends State<CateMusic> {
  List<Cate> cateList = [
    Cate(title: '近期', iconPath: 'lib/assets/icon/lock.svg'),
    Cate(title: '创建', noticNum: 3, isShowNotic: true),
    Cate(title: '收藏', noticNum: 30, isShowNotic: true),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
          child: Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: List.generate(cateList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onSubTabChange(index);
                        setState(() {});
                      },
                      child: Row(
                        spacing: 4,
                        children: [
                          if (cateList[index].iconPath != '')
                            SvgPicture.asset(
                              cateList[index].iconPath ?? '',
                              width: 20,
                              height: 20,
                              color: widget.subCurrentIndex == index
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          Badge(
                            label: Text(
                              cateList[index].isShowNotic
                                  ? cateList[index].noticNum.toString()
                                  : '',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.subCurrentIndex == index
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                            alignment: Alignment.topRight,
                            offset: const Offset(15, 0),
                            backgroundColor: Colors.transparent,
                            child: Text(
                              cateList[index].title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: widget.subCurrentIndex == index
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: widget.subCurrentIndex == index
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Flex(
                spacing: 20,
                direction: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'lib/assets/icon/daoru.svg',
                      width: 20,
                      height: 20,
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'lib/assets/icon/liebiao-dian.svg',
                      width: 20,
                      height: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 播客
class CatePodcast extends StatefulWidget {
  final double minExtentHeight;
  final int subCurrentIndex;
  final void Function(int) onTabChange;
  final void Function(int) onSubTabChange;

  const CatePodcast({
    super.key,
    required this.minExtentHeight,
    required this.subCurrentIndex,
    required this.onTabChange,
    required this.onSubTabChange,
  });

  @override
  State<CatePodcast> createState() => _CatePodcastState();
}

class _CatePodcastState extends State<CatePodcast> {
  List<Cate> cateList = [
    Cate(title: '全部', noticNum: 0, isShowNotic: true),
    Cate(title: '播客', noticNum: 0, isShowNotic: true),
    Cate(title: '有声书', noticNum: 0, isShowNotic: true),
  ];
  void setIndex(int index) {
    widget.onSubTabChange(index);
    setState(() {});
  }

  final PageController _innerController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
          child: Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Flex(
                  direction: Axis.horizontal,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: List.generate(cateList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setIndex(index);
                      },
                      child: Row(
                        spacing: 4,
                        children: [
                          if (cateList[index].iconPath != '')
                            SvgPicture.asset(
                              cateList[index].iconPath ?? '',
                              width: 20,
                              height: 20,
                              color: widget.subCurrentIndex == index
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          Badge(
                            label: Text(
                              cateList[index].isShowNotic
                                  ? cateList[index].noticNum.toString()
                                  : '',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.subCurrentIndex == index
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                            alignment: Alignment.topRight,
                            offset: const Offset(15, 0),
                            backgroundColor: Colors.transparent,
                            child: Text(
                              cateList[index].title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: widget.subCurrentIndex == index
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: widget.subCurrentIndex == index
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Flex(
                spacing: 20,
                direction: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'lib/assets/icon/zhuanhuanshunxu.svg',
                      width: 20,
                      height: 20,
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'lib/assets/icon/liebiao-dian.svg',
                      width: 20,
                      height: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 笔记
class CateNote extends StatefulWidget {
  final double minExtentHeight;

  /// 内层最左继续向右拉时触发（父组件上一页）
  final VoidCallback? onReachLeftEdge;

  /// 内层最右继续向左拉时触发（父组件下一页）
  final VoidCallback? onReachRightEdge;
  const CateNote({
    super.key,
    required this.minExtentHeight,
    this.onReachLeftEdge,
    this.onReachRightEdge,
  });

  @override
  State<CateNote> createState() => _CateNoteState();
}

class _CateNoteState extends State<CateNote> {
  List<Cate> cateList = [Cate(title: '播放')];
  int layoutType = 0;
  final String listArrangement = 'lib/assets/icon/caidan.svg';
  final String verticalArrangement = 'lib/assets/icon/caidan1.svg';

  int podcaIndex = 0;
  void setIndex(int index) {
    podcaIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Flex(
                    direction: Axis.horizontal,
                    spacing: 10,
                    children: [
                      Icon(
                        CupertinoIcons.arrowtriangle_right_circle_fill,
                        size: 40,
                        color: Colors.red,
                      ),
                      Text('播放全部', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    layoutType = layoutType == 0 ? 1 : 0;
                    setState(() {});
                  },
                  child: SvgPicture.asset(
                    layoutType == 0 ? listArrangement : verticalArrangement,
                    width: 20,
                    height: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
