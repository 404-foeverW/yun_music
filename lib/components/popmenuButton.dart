import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuItem {
  String text;
  int value;
  String? icon;
  Widget? iconWidget;

  MenuItem({required this.text, required this.value, this.icon, this.iconWidget});
}

class PopupMenu extends StatefulWidget {
  final List<MenuItem> menuList;
  final Widget icon;
  const PopupMenu({super.key, required this.menuList, required this.icon});

  @override
  State<PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {

  // List<Map<String, dynamic>> menuList = [
  //   {
  //     'icon': 'lib/assets/icon/sangediandian-white.svg',
  //     'text': '日推评价',
  //     'value': '1'
  //   },
  // ];

  List<PopupMenuEntry<String>> widgetList = [];

  @override
  void initState() {
    super.initState();
    widgetList = widget.menuList.map((e) {
      return PopupMenuItem<String>(
        value: e.value.toString(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Flex(
          spacing: 10,
          direction: Axis.horizontal,
          children: [
            if(e.icon != null && e.icon!.isNotEmpty)
              SvgPicture.asset(e.icon!, width: 30,height: 30,),
            if(e.iconWidget != null)
              e.iconWidget!,
            Text(e.text),
          ],
        )
        ),
      );
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.white,
      itemBuilder:(context) {
        return widgetList;
      },
      icon: widget.icon,
    );
  }
}