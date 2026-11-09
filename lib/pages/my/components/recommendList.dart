import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/pages/my/components/listview.dart';
import 'package:yun_music/store/index.dart';

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
              Icon(CupertinoIcons.xmark)
            ]
          ),
          ListView.builder(
            itemCount: recommendList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListItem(
                cateType: cateType,
                picUrl: recommendList[index].coverImgUrl,
                title: recommendList[index].name,
                subTitle: Text(
                  recommendList[index].description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
  double get maxExtent => deviceInfo.height * 0.7;

  @override
  double get minExtent => deviceInfo.height * 0.7;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}