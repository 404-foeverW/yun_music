import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchCate extends StatefulWidget {
  const SearchCate({super.key});

  @override
  State<SearchCate> createState() => _SearchCateState();
}

class _SearchCateState extends State<SearchCate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GridView.count(
        padding: const EdgeInsets.only(top: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisExtent: 90,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          CateItem(
            title: '排行榜',
            picUrl: 'http://p2.music.126.net/ucdEaYKU_dL0U2ae-wSRCQ==/109951174184824841.jpg?param=200y200',
            path: '',
            color: Color.fromRGBO(188, 143, 143, 1),
          ),
          CateItem(
            title: '歌单',
            picUrl: 'https://p1.music.126.net/hvlUpIZEY2QGDW_0N3V5-A==/109951171972165872.jpg?param=200y200',
            path: '',
            color: Color.fromRGBO(105, 105, 105, 1),
          ),
          CateItem(
            title: '播客',
            picUrl: 'http://p1.music.126.net/dLy2-sGwShC7MS7TIAqXZg==/109951168098474226.jpg?param=200y200',
            path: '',
            color: Color.fromRGBO(128, 128, 128, 1),
          ),
          CateItem(
            title: '听书',
            picUrl: 'http://p2.music.126.net/dC4xDv13BU4DGPe0nP7KRQ==/109951173904749676.jpg?param=200y200',
            path: '',
            color: Color.fromRGBO(0, 191, 255, 1),
          ),
        ],
      ),
    );
  }
}

class CateItem extends StatefulWidget {
  final String title;
  final String picUrl;
  final String path;
  final Color color;
  const CateItem({
    super.key,
    required this.title,
    required this.picUrl,
    required this.path,
    required this.color,
  });

  @override
  State<CateItem> createState() => _CateItemState();
}

class _CateItemState extends State<CateItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 0),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Stack(
              children: [
                Positioned(
                  left: 22,
                  top: 5,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: -math.pi / 10,
                  alignment: Alignment.topRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://images.weserv.nl/?url=${widget.picUrl}',
                      httpHeaders: {
                        'Referer': 'https://music.163.com/',
                        'sec-ch-ua-platform': '"Windows"',
                        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0',
                      },
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
