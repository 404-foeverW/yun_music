// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CateInfo {
  int id;
  int adType;
  String name;
  String coverImgUrl;
  int playCount;
  int trackCount;
  String creator;
  List<dynamic> tags;
  String description;

  CateInfo({
    required this.id,
    required this.name,
    required this.coverImgUrl,
    required this.playCount,
    required this.trackCount,
    required this.creator,
    required this.tags,
    required this.description,
    required this.adType,
  });

  factory CateInfo.fromJson(Map<String, dynamic> json) {
    return CateInfo(
      id: json['id'],
      name: json['name'],
      coverImgUrl: json['coverImgUrl'],
      playCount: json['playCount'] ?? 0,
      trackCount: json['trackCount'] ?? 0,
      creator: json['creator'] ?? '',
      tags: json['tags'] ?? [],
      description: json['description'] ?? '',
      adType: json['adType'] ?? 0,
    );
  }
}

class DefaultWidget {
  // 图片地址
  String picUrl;
  // 标题
  String title;
  // 图片的遮罩层
  Widget? overlay;
  // 自定义子标题组件
  Widget? subTitle;
  // 自定义右侧按钮
  Widget? customButton;

  DefaultWidget({
    required this.picUrl,
    required this.title,
    this.subTitle,
    this.overlay,
    this.customButton,
  });
}

class OperatorWidget {
  // 操作提示图标
  Widget icon;
  // 操作提示文字
  String title;
  // 副标题
  String? subTitle;
  // 副组件
  Widget? customButton;
  // 操作点击事件
  void Function() onTap;

  OperatorWidget({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subTitle,
    this.customButton,
  });
}

class ListViewItem {
  // 请求的api地址
  Future Function(Map<String, dynamic>) requestApi;
  // 请求参数
  Map<String, dynamic> params;
  // 分类类型
  int cateType;
  // 自定义右侧按钮
  Widget? customButton;
  // item点击事件
  void Function() onTap;
  // 右侧按钮点击事件
  void Function() btnTap;
  // 默认显示的组件
  DefaultWidget? defaultWidget;
  // 默认操作组件
  List<OperatorWidget>? operatorWidgets;

  ListViewItem({
    required this.requestApi,
    required this.params,
    required this.cateType,
    this.defaultWidget,
    this.operatorWidgets,
    required this.onTap,
    required this.btnTap,
    this.customButton,
  });
}

class CateInfoListView extends StatefulWidget {
  final ListViewItem listViewItem;
  const CateInfoListView({super.key, required this.listViewItem});

  @override
  State<CateInfoListView> createState() => _CateInfoListViewState();
}

class _CateInfoListViewState extends State<CateInfoListView> {
  List<CateInfo> _list = [];
  bool _loading = true;
  bool _loaded = false;

  Future<void> getInfo() async {
    if (_loaded) return;
    _list = await widget.listViewItem.requestApi(widget.listViewItem.params);
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
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: CustomScrollView(
        // spacing: 10,
        slivers: [
          if (widget.listViewItem.defaultWidget != null)
            SliverToBoxAdapter(
              child: ListItem(
                cateType: widget.listViewItem.cateType,
                picUrl: widget.listViewItem.defaultWidget!.picUrl,
                title: widget.listViewItem.defaultWidget!.title,
                subTitle: widget.listViewItem.defaultWidget!.subTitle,
                overlay: widget.listViewItem.defaultWidget!.overlay,
                customButton: widget.listViewItem.defaultWidget!.customButton,
                btnTap: widget.listViewItem.btnTap,
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = _list[index];
                return ListItem(
                  cateType: widget.listViewItem.cateType,
                  picUrl: item.coverImgUrl,
                  title: item.name,
                  subTitle: widget.listViewItem.cateType == 0
                      ? Text('歌单 * ${item.trackCount}首 * ${item.creator}',
                          maxLines: 1, overflow: TextOverflow.ellipsis)
                      : Text(item.description,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                  description: item.description,
                  btnTap: widget.listViewItem.btnTap,
                  customButton: widget.listViewItem.customButton,
                );
              },
              childCount: _list.length,
            ),
          ),
          if (widget.listViewItem.operatorWidgets != null)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = widget.listViewItem.operatorWidgets![index];
                  return OperatorItem(
                    icon: item.icon,
                    title: item.title,
                    subTitle: item.subTitle,
                    onTap: item.onTap,
                    customButton: item.customButton,
                  );
                },
                childCount: widget.listViewItem.operatorWidgets!.length,
              ),
            ),
          // SliverToBoxAdapter(
          //   child: ListView(
          //     padding: const EdgeInsets.only(top: 0),
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(), 
          //     children: [
          //       if (widget.listViewItem.defaultWidget != null)
          //       ListItem(
          //         cateType: widget.listViewItem.cateType,
          //         picUrl: widget.listViewItem.defaultWidget!.picUrl,
          //         title: widget.listViewItem.defaultWidget!.title,
          //         subTitle: widget.listViewItem.defaultWidget!.subTitle,
          //         overlay: widget.listViewItem.defaultWidget!.overlay,
          //         customButton: widget.listViewItem.defaultWidget!.customButton,
          //         btnTap: widget.listViewItem.btnTap,
          //       ),
          //       ..._list.map((item) {
          //         return ListItem(
          //           cateType: widget.listViewItem.cateType,
          //           picUrl: item.coverImgUrl,
          //           title: item.name,
          //           subTitle: widget.listViewItem.cateType == 0
          //               ? Text(
          //                   '歌单 * ${item.trackCount}首 * ${item.creator}',
          //                   maxLines: 1,
          //                   overflow: TextOverflow.ellipsis,
          //                 )
          //               : Text(
          //                   item.description,
          //                   maxLines: 2,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //           description: item.description,
          //           btnTap: widget.listViewItem.btnTap,
          //           customButton: widget.listViewItem.customButton,
          //         );
          //       }),
          //       if (widget.listViewItem.operatorWidgets != null)
          //         ...widget.listViewItem.operatorWidgets!.map((item) {
          //           return OperatorItem(
          //             icon: item.icon,
          //             title: item.title,
          //             subTitle: item.subTitle,
          //             onTap: item.onTap,
          //             customButton: item.customButton,
          //           );
          //         }),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  // 分类类型
  final int cateType;

  // 图片地址
  final String picUrl;
  // 标题
  final String title;
  // 图片的遮罩层
  final Widget? overlay;
  // 自定义子标题组件
  final Widget? subTitle;
  // 自定义右侧按钮
  final Widget? customButton;
  // 标签
  final List<dynamic>? tags;
  // 描述
  final String? description;
  // 右侧按钮点击事件
  final void Function()? btnTap;
  const ListItem({
    super.key,
    required this.cateType,
    required this.picUrl,
    required this.title,
    this.subTitle,
    this.overlay,
    this.customButton,
    this.btnTap,
    this.tags,
    this.description,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Flex(
        direction: Axis.horizontal,
        spacing: 10,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: 'https://images.weserv.nl/?url=${widget.picUrl}',
                    httpHeaders: {
                      'Referer': 'https://music.163.com/',
                      'sec-ch-ua-platform': '"Windows"',
                      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0',
                    },
                    width: 80,
                    height: 80,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    errorListener: (Object e) {
                      print(e);
                    },
                  ),
                ),
                if (widget.overlay != null)
                  Align(alignment: Alignment.center, child: widget.overlay),
              ],
            ),
          ),
          Expanded(
            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.start,
              direction: Axis.vertical,
              spacing: 10,
              children: [
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.description != null && widget.cateType == 1)
                  Text(
                    widget.description ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                Flex(
                  direction: Axis.horizontal,
                  spacing: 5,
                  children: [
                    if (widget.tags != null && widget.tags!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigoAccent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          widget.tags![0],
                          style: TextStyle(
                            color: Colors.indigoAccent,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    if (widget.subTitle != null)
                      Expanded(child: widget.subTitle ?? Text('')),
                  ],
                ),
              ],
            ),
          ),
          if (widget.customButton != null)
            IconButton(
              onPressed: () {
                widget.btnTap?.call();
              },
              icon: widget.customButton ?? Container(),
              alignment: Alignment.center,
            ),
        ],
      ),
    );
  }
}

class OperatorItem extends StatefulWidget {
  // 操作提示图标
  final Widget icon;
  // 操作提示文字
  final String title;
  // 副标题
  final String? subTitle;
  // 副组件
  final Widget? customButton;

  // 操作点击事件
  final void Function() onTap;

  const OperatorItem({
    super.key,
    required this.icon,
    required this.title,
    this.subTitle,
    this.customButton,
    required this.onTap,
  });

  @override
  State<OperatorItem> createState() => _OperatorItemState();
}

class _OperatorItemState extends State<OperatorItem> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: widget.icon,
        ),
        Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          spacing: 5,
          children: [
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              widget.title,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            if (widget.subTitle != null) Text(widget.subTitle ?? ''),
          ],
        ),
        if (widget.customButton != null) widget.customButton ?? Container(),
      ],
    );
  }
}
