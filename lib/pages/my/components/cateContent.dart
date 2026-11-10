// ignore_for_file: avoid_print

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/pages/my/components/listview.dart';
import 'package:yun_music/pages/my/index2.dart';

// class Cate {
//   String title;
//   String? iconPath;
//   bool isShowNotic;
//   int? noticNum;
//   // Widget? childWidget;
//   Widget Function(
//     BuildContext context,
//     double minExtentHeight, {
//     VoidCallback? onReachLeftEdge,
//     VoidCallback? onReachRightEdge,
//   })?
//   childWidget;
//   Widget Function()? listView;

//   Cate({
//     required this.title,
//     this.isShowNotic = false,
//     this.iconPath = '',
//     this.noticNum = 0,
//     this.childWidget,
//     this.listView,
//   });
// }
class ContentPH extends SliverPersistentHeaderDelegate {
  final bool Function() isStopChange;
  final List<Cate> cateList;
  final double minExtentHeight;
  final CarouselSliderController carouselController;
  // final PageController innerController;
  final RxInt currentIndex;
  final RxInt subCurrentIndex;
  final void Function(int index) onSubTabChange;
  final void Function(int index) onTabChange;
  // 请求的api地址
  final Future Function(Map<String, dynamic>) requestApi;
  // 请求最近收听api
  final Future Function(Map<String, dynamic>)? requestRecentApi;
  // 请求推荐api
  final Future Function(Map<String, dynamic>)? requestRecommendApi;
  // 最近收听参数
  final Map<String, dynamic>? recentParams;
  // 推荐参数
  final Map<String, dynamic>? recommendParams;
  // 请求参数
  final Map<String, dynamic> params;
  const ContentPH({
    required this.isStopChange,
    required this.minExtentHeight,
    required this.carouselController,
    // required this.innerController,
    required this.currentIndex,
    required this.subCurrentIndex,
    required this.onSubTabChange,
    required this.onTabChange,
    required this.cateList,
    required this.requestApi,
    this.requestRecentApi,
    this.recentParams,
    this.params = const {},
    this.requestRecommendApi,
    this.recommendParams,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Catecontent(
        carouselController: carouselController,
        minExtentHeight: minExtentHeight,
        currentIndex: currentIndex,
        subCurrentIndex: subCurrentIndex,
        onTabChange: onTabChange,
        onSubTabChange: onSubTabChange,
        cateList: cateList,
        requestApi: getRencentInfo,
        requestRecommendApi: getRecommendInfo,
        recommendParams: recommendParams,
        params: params,
        isStopChange: isStopChange,
      ),
    );
  }

  @override
  double get maxExtent => minExtentHeight;

  @override
  double get minExtent => minExtentHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class Catecontent extends StatefulWidget {
  final bool Function() isStopChange;
  final List<Cate> cateList;
  final double minExtentHeight;
  final CarouselSliderController carouselController;
  // final PageController innerController;
  final RxInt currentIndex;
  final RxInt subCurrentIndex;
  final void Function(int index) onSubTabChange;
  final void Function(int index) onTabChange;
  // 请求的api地址
  final Future Function(Map<String, dynamic>) requestApi;
  // 请求最近收听api
  final Future Function(Map<String, dynamic>)? requestRecentApi;
  // 请求推荐api
  final Future Function(Map<String, dynamic>)? requestRecommendApi;
  // 最近收听参数
  final Map<String, dynamic>? recentParams;
  // 推荐参数
  final Map<String, dynamic>? recommendParams;
  // 请求参数
  final Map<String, dynamic> params;
  const Catecontent({
    super.key,
    required this.isStopChange,
    required this.minExtentHeight,
    required this.carouselController,
    // required this.innerController,
    required this.currentIndex,
    required this.subCurrentIndex,
    required this.onSubTabChange,
    required this.onTabChange,
    required this.cateList,
    required this.requestApi,
    this.requestRecentApi,
    this.recentParams,
    this.params = const {},
    this.requestRecommendApi,
    this.recommendParams,
  });

  @override
  State<Catecontent> createState() => _CatecontentState();
}

class _CatecontentState extends State<Catecontent> {
  List<CateInfo> _list = [];
  List<CateInfo> _rencentlist = [];
  List<CateInfo> _recommendlist = [];

  bool _loading = true;
  bool _loaded = false;

  Future<void> getInfo() async {
    if (_loaded) return;
    _list = await widget.requestApi(widget.params);
    if (widget.requestRecentApi != null) {
      _rencentlist = await widget.requestRecentApi!(widget.recentParams!);
    }
    if (widget.requestRecommendApi != null) {
      _recommendlist = await widget.requestRecommendApi!(
        widget.recommendParams!,
      );
    }
    _loading = false;
    _loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.red, width: 1)
      ),
      child: CarouselSlider.builder(
        carouselController: widget.carouselController, // 绑定
        options: CarouselOptions(
          viewportFraction: 1,
          // height: widget.minExtentHeight * 0.7,
          height: widget.minExtentHeight,
          onPageChanged: (index, reason) {
            widget.onSubTabChange(widget.subCurrentIndex.value);
            // setState(() {});
          },
          scrollPhysics: const NeverScrollableScrollPhysics(),
        ),
        itemCount: widget.cateList.length,
        itemBuilder: (context, index, realIndex) {
          return SizedBox(
            // height: widget.minExtentHeight * 0.7,
            height: widget.minExtentHeight,
            child: CarouselContent(
              isStopChange: widget.isStopChange,
              list: _list,
              rencentlist: _rencentlist,
              recommendlist: _recommendlist,
              cateList: widget.cateList[index].children,
              index: widget.subCurrentIndex.value,
              listView: widget.cateList[index].listView,
              onReachLeftEdge: () {
                // 内层最左继续右拉 → 父组件上一页
                if (widget.currentIndex.value > 0) {
                  print('onReachLeftEdge');
                  print(index);
                  widget.carouselController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  widget.onTabChange(widget.currentIndex.value - 1);
                }
                // widget.onTabChange(widget.currentIndex - 1);
              },
              onReachRightEdge: () {
                // print(widget.cateList.length);
                // print(index < widget.cateList.length - 1);
                // 内层最右继续左拉 → 父组件下一页
                if (widget.currentIndex.value < widget.cateList.length - 1) {
                  print('onReachRightEdge');
                  widget.carouselController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  widget.onTabChange(widget.currentIndex.value + 1);
                }
              },
              setIndex: widget.onSubTabChange,
              innerController:
                  widget.cateList[index].innerController ?? PageController(),
            ),
          );
        },
      ),
    );
  }
}

// 轮播主体内容
class CarouselContent extends StatefulWidget {
  final bool Function() isStopChange;
  final List<CateInfo> list;
  final List<CateInfo>? rencentlist;
  final List<CateInfo>? recommendlist;
  final List<Cate>? cateList;
  final int index;
  final Function(int index) setIndex;
  final PageController innerController;

  /// 内层最左继续向右拉时触发（父组件上一页）
  final VoidCallback? onReachLeftEdge;

  /// 内层最右继续向左拉时触发（父组件下一页）
  final VoidCallback? onReachRightEdge;
  final Widget Function(
    List<CateInfo>,
    Cate item, {
    List<CateInfo> rencentlist,
    List<CateInfo> recommendlist,
  })?
  listView;

  const CarouselContent({
    super.key,
    required this.isStopChange,
    required this.cateList,
    required this.index,
    required this.setIndex,
    required this.innerController,
    required this.list,
    required this.rencentlist,
    required this.recommendlist,
    this.onReachLeftEdge,
    this.onReachRightEdge,
    this.listView,
  });

  @override
  State<CarouselContent> createState() => _CarouselContentState();
}

class _CarouselContentState extends State<CarouselContent> {
  double _dragDelta = 0; // 拖拽距离
  bool get _isSinglePage => widget.cateList!.length <= 1;
  DateTime? _lastTriggerTime;

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

  int _innerIndex = 0;

  bool _onScrollNotification(ScrollNotification notification) {
    // print(notification);
    if (notification is! OverscrollNotification) return false;
    // final isAtLeft = widget.index == 0;
    // final isAtRight = widget.index == widget.cateList!.length - 1;
    final isAtLeft = _innerIndex == 0;
    final isAtRight = _innerIndex == widget.cateList!.length - 1;
    // overscroll < 0：用户向右拉（内容向右溢出）
    // overscroll > 0：用户向左拉
    if (notification.overscroll < 0 && isAtLeft) {
      if (_canTrigger()) widget.onReachLeftEdge?.call();
    } else if (notification.overscroll > 0 && isAtRight) {
      if (_canTrigger()) widget.onReachRightEdge?.call();
    }
    return false;
  }

  List<CateInfo> filterList(List<int> filterType, List<CateInfo> list) {
    return list
        .where((element) => filterType.contains(element.adType))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // List<CateInfo> list = filterList(
    //   widget.cateList![index].filterType,
    //   widget.list
    // );
    if (!widget.cateList!.isNotEmpty) return Text('暂未有数据');
    final content = NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: PageView.builder(
        // controller: widget.innerController,
        controller: widget.innerController,
        physics: const ClampingScrollPhysics(),
        itemCount: widget.cateList!.length,
        onPageChanged: (index) {
          if (!widget.isStopChange()) return;
          _innerIndex = index;
          widget.setIndex(index);
          // widget.index = index; // 不setState
          // setState(() {});
        },
        itemBuilder: (context, index) {
          // return widget.cateList![index].listView != null ?
          //   widget.cateList![index].listView?.call()
          //   : Container(child: Text('index: $index'),);
          return widget.listView != null
              ? widget.listView?.call(
                  filterList(widget.cateList![index].filterType, widget.list),
                  widget.cateList![index],
                  rencentlist: widget.rencentlist ?? [],
                  recommendlist: widget.recommendlist ?? [],
                )
              : Container(child: Text('index: $index'));
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
