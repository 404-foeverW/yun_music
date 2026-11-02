import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yun_music/api/playlist.dart';
import 'package:yun_music/components/tag.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class Recommenmusic extends StatefulWidget {
  final String tag;
  final int rowsPerPage;
  const Recommenmusic({super.key, this.rowsPerPage = 3, this.tag = '华语'});

  @override
  State<Recommenmusic> createState() => _RecommenmusicState();
}

class _RecommenmusicState extends State<Recommenmusic> {
  final PageController _controller = PageController(initialPage: 0, viewportFraction: 0.9);
  late int _currentPage = 0;
  int get _totalPages =>
      musicList.isEmpty ? 0 : (musicList.length / widget.rowsPerPage).ceil();

  List<singleMusic> musicList = [];
  RecommendPlayList currPlayList = RecommendPlayList.fromJson({});
  Future<void> getData() async {
    try {
      List<RecommendPlayList> playList = await getHightQualityPlayList(
        tag: widget.tag,
      );
      // if (playList.isNotEmpty) {
      //   if (mounted) setState(() {});
      //   return;
      // }
      currPlayList = playList[0];
      List<singleMusic> musicList1 = await getPlayListDetail(currPlayList.id);
      // print('musicList1');
      // print(musicList1);
      if (!mounted || musicList1.isEmpty) return;
      musicList = musicList1.sublist(0, 9);
      setState(() {});
    } catch (e, stack) {
      print('获取推荐音乐失败: $e');
      print(stack);
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currPlayList.name.isNotEmpty ? currPlayList.name : '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          //歌单列表
          if (musicList.isNotEmpty)
            SizedBox(
              height: 200,
              child: PageView.builder(
                padEnds: false,
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _currentPage = index % _totalPages);
                },
                itemBuilder: (context, index) {
                  final realIndex = index % _totalPages;
                  return _buildPage(realIndex);
                },
              ),
            )
          else
            SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(int pageIndex) {
    final start = pageIndex * widget.rowsPerPage;
    final end = (start + widget.rowsPerPage).clamp(0, musicList.length);
    final pageData = musicList.isNotEmpty ? musicList.sublist(start, end) : [];
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          for (int i = 0; i < pageData.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: i == pageData.length - 1 ? 0 : 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          spacing: 15,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://images.weserv.nl/?url=${pageData[i].picUrl}',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    pageData[i].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Tag(music: TagInfo(fee: pageData[i].fee, pop: pageData[i].pop, sq: pageData[i].sq), type: 0),
                                      SizedBox(width: 5),
                                      Text(
                                        pageData[i].artists.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        'lib/assets/icon/bofang.svg',
                        width: 30,
                        height: 30,
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
