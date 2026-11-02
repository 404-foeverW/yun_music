import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeaderPart extends SliverPersistentHeaderDelegate {
  final double minExtentHeight;
  final double statusBarHeight;
  HeaderPart({
    required this.minExtentHeight,
    required this.statusBarHeight,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double progress = shrinkOffset / (maxExtent - minExtent);
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight, left: 10, right: 10),
      color: Color.lerp(Colors.transparent, Colors.white, progress),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          GestureDetector(
            onTap:() {
              
            },
            child: SvgPicture.asset('lib/assets/icon/danlieliebiao.svg', width: 25, height: 25, color: Colors.white)
          ),
          Expanded(
            child: Flex(
              spacing: 10,
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flex(direction: Axis.horizontal, children: [
                  Icon(CupertinoIcons.plus, size: 12, color: Colors.grey),
                  Text('添加状态', style: TextStyle(fontSize: 14, color: Colors.grey))
                ]),
                IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.plus, size: 28, color: Colors.white),),
                IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search, size: 28, color: Colors.white),),
                IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.ellipsis_vertical, size: 28, color: Colors.white),),
              ]
            )
          )
        ]
      )
    );
  }

  @override
  double get maxExtent => statusBarHeight + minExtentHeight;

  @override
  double get minExtent => minExtentHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}