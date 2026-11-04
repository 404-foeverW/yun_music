// ignore_for_file: avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Cate {
  String title;
  String? iconPath;
  bool isShowNotic;
  int? noticNum;
  // Widget? childWidget;
  Widget Function(
    BuildContext context,
    double minExtentHeight, {
    VoidCallback? onReachLeftEdge,
    VoidCallback? onReachRightEdge,
  })?
  childWidget;

  Cate({
    required this.title,
    this.isShowNotic = false,
    this.iconPath = '',
    this.noticNum = 0,
    this.childWidget,
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
    Cate(
      title: '音乐',
      childWidget:
          (context, minExtentHeight, {onReachLeftEdge, onReachRightEdge}) =>
              CateMusic(
                minExtentHeight: minExtentHeight,
                onReachLeftEdge: onReachLeftEdge,
                onReachRightEdge: onReachRightEdge,
              ),
    ),
    Cate(
      title: '播客',
      childWidget:
          (context, minExtentHeight, {onReachLeftEdge, onReachRightEdge}) =>
              CatePodcast(
                minExtentHeight: minExtentHeight,
                onReachLeftEdge: onReachLeftEdge,
                onReachRightEdge: onReachRightEdge,
              ),
    ),
    Cate(
      title: '笔记',
      childWidget:
          (context, minExtentHeight, {onReachLeftEdge, onReachRightEdge}) =>
              CateNote(
                minExtentHeight: minExtentHeight,
                onReachLeftEdge: onReachLeftEdge,
                onReachRightEdge: onReachRightEdge,
              ),
    ),
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
            viewportFraction: 1,
            height: widget.minExtentHeight * 0.9,
            onPageChanged: (index, reason) {
              currentIndex = index;
              setState(() {});
            },
            scrollPhysics: const NeverScrollableScrollPhysics(),
          ),
          itemCount: widget.cateList.length,
          itemBuilder: (context, index, realIndex) {
            return widget.cateList[index].childWidget!(
              context,
              widget.minExtentHeight * 0.9,
              onReachLeftEdge: () {
                // 内层最左继续右拉 → 父组件上一页
                if (index > 0) {
                  _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              onReachRightEdge: () {
                // 内层最右继续左拉 → 父组件下一页
                if (index < widget.cateList.length - 1) {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}

// 音乐
class CateMusic extends StatefulWidget {
  final double minExtentHeight;

  /// 内层最左继续向右拉时触发（父组件上一页）
  final VoidCallback? onReachLeftEdge;

  /// 内层最右继续向左拉时触发（父组件下一页）
  final VoidCallback? onReachRightEdge;
  const CateMusic({
    super.key,
    required this.minExtentHeight,
    this.onReachLeftEdge,
    this.onReachRightEdge,
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
  int musicIndex = 0;
  void setIndex(int index) {
    musicIndex = index;
    setState(() {});
  }

  // DateTime? _lastTriggerTime;
  // final CarouselSliderController _controller = CarouselSliderController();
  final PageController _innerController = PageController();

  // bool _canTrigger() {
  //   final now = DateTime.now();
  //   if (_lastTriggerTime != null &&
  //       now.difference(_lastTriggerTime!) < const Duration(milliseconds: 400)) {
  //     return false;
  //   }
  //   _lastTriggerTime = now;
  //   return true;
  // }

  // bool _onScrollNotification(ScrollNotification notification) {
  //   // print(notification);
  //   if (notification is! OverscrollNotification) return false;
  //   final isAtLeft = musicIndex == 0;
  //   final isAtRight = musicIndex == cateList.length - 1;
  //   // overscroll < 0：用户向右拉（内容向右溢出）
  //   // overscroll > 0：用户向左拉
  //   if (notification.overscroll < 0 && isAtLeft) {
  //     if (_canTrigger()) widget.onReachLeftEdge?.call();
  //   } else if (notification.overscroll > 0 && isAtRight) {
  //     if (_canTrigger()) widget.onReachRightEdge?.call();
  //   }
  //   return false;
  // }

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
                        musicIndex = index;
                        _innerController.jumpToPage(index);
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
                              color: musicIndex == index
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
                                color: musicIndex == index
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
                                fontWeight: musicIndex == index
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: musicIndex == index
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
        SizedBox(
          height: widget.minExtentHeight - 80,
          child: CarouselContent(
            cateList: cateList,
            index: musicIndex,
            onReachLeftEdge: widget.onReachLeftEdge,
            onReachRightEdge: widget.onReachRightEdge,
            setIndex: setIndex,
            innerController: _innerController,
          ),
          // child: NotificationListener<ScrollNotification>(
          //   onNotification: _onScrollNotification,
          //   // child: CarouselSlider.builder(
          //   //   carouselController: _controller, // 绑定
          //   //   options: CarouselOptions(
          //   //     viewportFraction: 1,
          //   //     height: widget.minExtentHeight - 80,
          //   //     // 关键：用 BouncingScrollPhysics 保证边界有 overscroll 事件，否则会卡在边界
          //   //     scrollPhysics: const ClampingScrollPhysics(),
          //   //     enableInfiniteScroll: false,
          //   //     onPageChanged: (index, reason) {
          //   //       print(index);
          //   //       musicIndex = index;
          //   //       setState(() {});
          //   //     },
          //   //   ),
          //   //   itemCount: cateList.length,
          //   //   itemBuilder: (context, index, realIndex) {
          //   //     return Container(child: Text('index: $index'),);
          //   //   },
          //   // ),

          //   child: PageView.builder(
          //     controller: _innerController,
          //     physics: const ClampingScrollPhysics(),
          //     itemCount: cateList.length,
          //     onPageChanged: (index) {
          //       musicIndex = index; // 不setState
          //       setState(() {});
          //     },
          //     itemBuilder: (context, index) {
          //       return Container(child: Text('index: $index'));
          //     },
          //   ),
          // ),
        ),
      ],
    );
  }
}

// 播客
class CatePodcast extends StatefulWidget {
  final double minExtentHeight;

  /// 内层最左继续向右拉时触发（父组件上一页）
  final VoidCallback? onReachLeftEdge;

  /// 内层最右继续向左拉时触发（父组件下一页）
  final VoidCallback? onReachRightEdge;
  const CatePodcast({
    super.key,
    required this.minExtentHeight,
    this.onReachLeftEdge,
    this.onReachRightEdge,
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
  int podcaIndex = 0;
  void setIndex(int index) {
    podcaIndex = index;
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
                        podcaIndex = index;
                        _innerController.jumpToPage(index);
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
                              color: podcaIndex == index
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
                                color: podcaIndex == index
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
                                fontWeight: podcaIndex == index
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: podcaIndex == index
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
        SizedBox(
          height: widget.minExtentHeight - 80,
          child: CarouselContent(
            cateList: cateList,
            index: podcaIndex,
            onReachLeftEdge: widget.onReachLeftEdge,
            onReachRightEdge: widget.onReachRightEdge,
            setIndex: setIndex,
            innerController: _innerController,
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
  final String listArrangement = 'lib/assets/icon/zhuanhuanshunxu.svg';
  final String verticalArrangement = 'lib/assets/icon/zhuanhuanshunxu.svg';

  int podcaIndex = 0;
  void setIndex(int index) {
    podcaIndex = index;
    setState(() {});
  }

  double _dragDelta = 0; // 拖拽距离
  bool get _isSinglePage => cateList.length <= 1;
  DateTime? _lastTriggerTime;
  // ---------- 单页：手势判断 ----------
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragDelta += details.primaryDelta ?? 0;
  }

  bool _canTrigger() {
    final now = DateTime.now();
    if (_lastTriggerTime != null &&
        now.difference(_lastTriggerTime!) < const Duration(milliseconds: 400)) {
      return false;
    }
    _lastTriggerTime = now;
    return true;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    const threshold = 50.0; // 拖动超过 50px 才算有效
    print(_dragDelta);
    if (_dragDelta > threshold) {
      // 向右拖 → 父级上一页
      if (_canTrigger()) widget.onReachLeftEdge?.call();
    } else if (_dragDelta < -threshold) {
      // 向左拖 → 父级下一页
      if (_canTrigger()) widget.onReachRightEdge?.call();
    }
    _dragDelta = 0;
  }

  // final PageController _innerController = PageController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: widget.minExtentHeight - 80,
        child: Column(
          children: [
            Opacity(
              opacity: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text('播放全部'),
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
            SizedBox(
              height: widget.minExtentHeight - 80,
              child: Container(child: Text('index: 1')),
            ),
          ],
        ),
      ),
    );
  }
}

// 轮播主体内容
class CarouselContent extends StatefulWidget {
  final List<Cate> cateList;
  final int index;
  final Function(int index) setIndex;
  final PageController innerController;

  /// 内层最左继续向右拉时触发（父组件上一页）
  final VoidCallback? onReachLeftEdge;

  /// 内层最右继续向左拉时触发（父组件下一页）
  final VoidCallback? onReachRightEdge;

  const CarouselContent({
    super.key,
    required this.cateList,
    required this.index,
    required this.setIndex,
    required this.innerController,
    this.onReachLeftEdge,
    this.onReachRightEdge,
  });

  @override
  State<CarouselContent> createState() => _CarouselContentState();
}

class _CarouselContentState extends State<CarouselContent> {
  double _dragDelta = 0; // 拖拽距离
  bool get _isSinglePage => widget.cateList.length <= 1;
  DateTime? _lastTriggerTime;
  // final CarouselSliderController _controller = CarouselSliderController();
  // final PageController _innerController = PageController();

  bool _canTrigger() {
    final now = DateTime.now();
    if (_lastTriggerTime != null &&
        now.difference(_lastTriggerTime!) < const Duration(milliseconds: 400)) {
      return false;
    }
    _lastTriggerTime = now;
    return true;
  }

  // ---------- 单页：手势判断 ----------
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragDelta += details.primaryDelta ?? 0;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    const threshold = 50.0; // 拖动超过 50px 才算有效
    print(_dragDelta);
    if (_dragDelta > threshold) {
      // 向右拖 → 父级上一页
      if (_canTrigger()) widget.onReachLeftEdge?.call();
    } else if (_dragDelta < -threshold) {
      // 向左拖 → 父级下一页
      if (_canTrigger()) widget.onReachRightEdge?.call();
    }
    _dragDelta = 0;
  }

  bool _onScrollNotification(ScrollNotification notification) {
    // print(notification);
    if (notification is! OverscrollNotification) return false;
    final isAtLeft = widget.index == 0;
    final isAtRight = widget.index == widget.cateList.length - 1;
    // overscroll < 0：用户向右拉（内容向右溢出）
    // overscroll > 0：用户向左拉
    if (notification.overscroll < 0 && isAtLeft) {
      if (_canTrigger()) widget.onReachLeftEdge?.call();
    } else if (notification.overscroll > 0 && isAtRight) {
      if (_canTrigger()) widget.onReachRightEdge?.call();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final content = NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      // child: CarouselSlider.builder(
      //   carouselController: _innerController, // 绑定
      //   options: CarouselOptions(
      //     viewportFraction: 1,
      //     // 关键：用 BouncingScrollPhysics 保证边界有 overscroll 事件，否则会卡在边界
      //     scrollPhysics: const ClampingScrollPhysics(),
      //     enableInfiniteScroll: false,
      //     onPageChanged: (index, reason) {
      //        widget.setIndex(index);
      //     },
      //   ),
      //   itemCount: cateList.length,
      //   itemBuilder: (context, index, realIndex) {
      //     return Container(child: Text('index: $index'),);
      //   },
      // ),

      child: PageView.builder(
        controller: widget.innerController,
        physics: const ClampingScrollPhysics(),
        itemCount: widget.cateList.length,
        onPageChanged: (index) {
          widget.setIndex(index);
          // widget.index = index; // 不setState
          // setState(() {});
        },
        itemBuilder: (context, index) {
          return Container(child: Text('index: $index'));
        },
      ),
    );
    if (_isSinglePage) {
      return GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        behavior: HitTestBehavior.opaque,
        child: Container(child: Text('index: 1')),
      );
    }
    return content;
  }
}
