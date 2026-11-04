import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeaderPart extends SliverPersistentHeaderDelegate {
  final double minExtentHeight;
  final double statusBarHeight;
  final ValueNotifier<bool> isPinnedNotifier;

  HeaderPart({
    required this.minExtentHeight,
    required this.statusBarHeight,
    required this.isPinnedNotifier,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ValueListenableBuilder(
      valueListenable: isPinnedNotifier,
      builder: (context, isPinned, _) {
        Color iconColor = isPinned ? Colors.black : Colors.white;
        return Container(
          height: maxExtent,
          padding: EdgeInsets.only(top: statusBarHeight,left: 10, right: 10, bottom: 10),
          // color: Color.lerp(Colors.transparent, Colors.white, isPinned ? 1 : 0),
          color: isPinned ? Colors.white : Colors.transparent,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  'lib/assets/icon/danlieliebiao.svg',
                  width: 25,
                  height: 25,
                  color: iconColor,
                ),
              ),
              Expanded(
                child: Flex(
                  spacing: 10,
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Icon(CupertinoIcons.plus, size: 12, color: Colors.grey),
                        Text(
                          '添加状态',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    IconButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.plus,
                        size: 28,
                        color: iconColor,
                      ),
                    ),
                    IconButton(
                       style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.search,
                        size: 28,
                        color: iconColor,
                      ),
                    ),
                    IconButton(
                       style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.ellipsis_vertical,
                        size: 28,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => minExtentHeight + 10;

  @override
  double get minExtent => minExtentHeight + 10;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
