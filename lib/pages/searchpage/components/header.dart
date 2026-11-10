import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends SliverPersistentHeaderDelegate {
  final double contentHeight;
  final double paddingTop;
  final GlobalKey<ScaffoldState> scaffoldkey;

  Header({
    required this.contentHeight,
    required this.paddingTop,
    required this.scaffoldkey
  });

  List<String> randomKeyValues = ['周杰伦', '薛之谦', '陈奕迅', '林俊杰'];
  int keyValueIndex = 0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.only(top: paddingTop),
      child: Flex(
        spacing: 20,
        direction: Axis.horizontal,
        children: [
          SvgPicture.asset('lib/assets/icon/danlieliebiao.svg', width: 24, height: 24),
          Expanded(
            child: Container(
              height: contentHeight,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
              ),
              child: Flex(
                spacing: 5,
                direction: Axis.horizontal,
                children: [
                  Icon(CupertinoIcons.search, color: Colors.grey, size: 16),
                  Expanded(
                    child: Text(
                      randomKeyValues[keyValueIndex],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey
                      )
                    )
                  ),
                  SvgPicture.asset('lib/assets/icon/saoyisao.svg', width: 16, height: 16, color: Colors.grey),
                ]
              )
            )
          ),
          SvgPicture.asset('lib/assets/icon/tinggeshiqu.svg', width: 24, height: 24),
        ]
      )
    );
  }

  @override
  double get maxExtent => contentHeight;

  @override
  double get minExtent => contentHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return keyValueIndex != (oldDelegate as Header).keyValueIndex;
  }
}