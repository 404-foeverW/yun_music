import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/pages/my/components/listview.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/utils/index.dart';

class RecommendList extends SliverPersistentHeaderDelegate {
  final deviceInfo = Get.find<DeviceInfoService>();

  final List<CateInfo> recommendList;
  final int cateType;
   // item点击事件
  void Function() onTap;
  // 右侧按钮点击事件
  void Function() btnTap;
  // 自定义右侧按钮
  Widget? customButton;

  RecommendList({
    required this.recommendList, 
    required this.cateType,
    required this.onTap,
    required this.btnTap,
    this.customButton
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Text(
                  '你可能喜欢',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Icon(CupertinoIcons.xmark, size: 20, color: Colors.grey)
            ]
          ),
          ListView.builder(
            itemCount: recommendList.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListItem(
                cateType: cateType,
                picUrl: recommendList[index].coverImgUrl,
                title: recommendList[index].name,
                subTitle: Text(
                  '${recommendList[index].trackCount}首 * ${getPlayCount(recommendList[index].playCount)}次播放',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey
                  )
                ),
                description: recommendList[index].description,
                btnTap: btnTap,
                customButton: customButton,
              );
            }
          )
        ]
      )
    );
  }

  @override
  // double get maxExtent => deviceInfo.height * 0.7;
  // double get maxExtent => deviceInfo.height - deviceInfo.statusBarHeight - 130;
  double get maxExtent {
    // 留出 HeaderPart + InfoCate 的空间，避免 extent 超过 viewport
    final available = deviceInfo.height - deviceInfo.statusBarHeight - 215;
    return available * 0.8; // 或一个合适的固定值
  }

  @override
  // double get minExtent => deviceInfo.height * 0.7;
  double get minExtent => maxExtent;


  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}