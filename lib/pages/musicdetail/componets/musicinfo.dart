import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InfoBox extends StatefulWidget {
  final double width;
  final Color bgColor;
  const InfoBox({super.key, required this.width, required this.bgColor});

  @override
  State<InfoBox> createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Flex(
        spacing: 30,
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: widget.width * 0.6,
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.white.withAlpha(20),
            //     width: 1,
            //   )
            // ),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScrollTitle(
                  title: 'To Be A Man (Mega Remix)',
                  icon: Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(20),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'VIP',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  showIcon: true,
                ),
                ScrollTitle(
                  title: 'Dax / The Mediary / Shane / Skywalker DaVinci / Kaveman Brown / Hailey Dayton / Ben Becker / Brutha Rick / Romeo ThaGreatwhite / Phix / Atlus',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    fontWeight: FontWeight.bold,
                  ),
                  showIcon: true,
                ),
              ],
            )
          ),
          GestureDetector(
            onTap: () {},
            child: Badge(
              backgroundColor: widget.bgColor,
              offset: Offset(5, 0),
              label: Text(
                '45w+',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              child: Icon(
                CupertinoIcons.suit_heart,
                size: 35,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Badge(
              backgroundColor: widget.bgColor,
              offset: Offset(5, 0),
              label: Text(
                '999+',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              child: SvgPicture.asset(
                'lib/assets/icon/pinglun.svg',
                width: 35,
                height: 35,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollTitle extends StatefulWidget {
  final String title;
  final Widget icon;
  final bool showIcon;
  final TextStyle style;
  const ScrollTitle({
    super.key,
    required this.title,
    this.icon = const Icon(
      CupertinoIcons.chevron_forward,
      color: Color.fromRGBO(255, 255, 255, 0.6),
    ),
    this.showIcon = true,
    this.style = const TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  });

  @override
  State<ScrollTitle> createState() => _ScrollTitleState();
}

class _ScrollTitleState extends State<ScrollTitle> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        return Flex(
          direction: Axis.horizontal,
          children: [
            SizedBox(
              width: maxWidth * 0.8,
              child: Text(
                widget.title,
                style: widget.style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 10),
            widget.showIcon ? widget.icon : Container(),
          ],
        );
      },
    );
  }
}
