import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yun_music/api/playlist.dart';
import 'package:yun_music/utils/index.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class RankingList extends StatefulWidget {
  const RankingList({super.key});

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  List<rankingListPlayList> list = [];

  Future<void> _getRankingList() async {
    try {
      var result = await getRankingListPlayList();
      if (!mounted || result.isEmpty) return;
      setState(() {
        list = result.sublist(0, 6);
      });
    } catch (e) {
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getRankingList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '排行榜',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Icon(CupertinoIcons.chevron_forward),
            ],
          ),
          Container(
            // width: 160,
            height: 295,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(list.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/ranking', arguments: {
                        'id': list[index].id,
                      });
                    },
                    child: PlayListBox(playitem: list[index])
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlayListBox extends StatefulWidget {
  final rankingListPlayList playitem;
  const PlayListBox({super.key, required this.playitem});

  @override
  State<PlayListBox> createState() => _PlayListBoxState();
}

class _PlayListBoxState extends State<PlayListBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 160,
          height: 160,
          margin: EdgeInsets.only(right: 10),
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            image: widget.playitem.coverImgUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(
                      'https://images.weserv.nl/?url=${widget.playitem.coverImgUrl}',
                      headers: {
                        'Referer': 'https://music.163.com/',
                        'sec-ch-ua-platform': '"Windows"',
                        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0',
                      },
                    ),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Stack(
            children: [
              const SizedBox.expand(),
              Positioned(
                right: 0,
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'lib/assets/icon/headseterji-copy.svg',
                        width: 20,
                        height: 20,
                      ),
                      if(getPlayCount(widget.playitem.playCount) != '')
                        Text(getPlayCount(widget.playitem.playCount), style: TextStyle(fontSize: 12,color: Colors.white))
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'lib/assets/icon/bofang2.svg',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 160,
          child: Text(
          widget.playitem.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        )
      ],
    );
  }
}