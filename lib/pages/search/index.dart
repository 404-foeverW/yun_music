// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/musicplayer.dart';
import 'package:yun_music/components/pressmask.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/utils/showDialog.dart';
import 'package:yun_music/viewmodel/playlist.dart';

LocalData localData = LocalData();
final deviceInfo = Get.find<DeviceInfoService>();

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final player = Get.find<MusicPlayer>();

  List<String> searchHistory = [
    '周杰伦',
    '薛之谦',
    '林俊杰',
    'Stay With Me',
    '陈奕迅',
    '张学友',
    '归去来兮',
    '告白气球',
    '太湖石红贝',
  ];
  List<String> recommendtitles = [
    'Dark',
    '单曲循环钢琴曲',
    'II',
    '法老',
    '赵雷',
    '杀死那个石家庄人',
  ];
  List<RankingDetail> rankingList = [];
  Future<void> _getRankingList() async {
    final jsonData = await rootBundle.loadString(
      'lib/assets/json/search_ranking.json',
    );
    Map<String, dynamic> res = jsonDecode(jsonData) as Map<String, dynamic>;
    rankingList = res['data']
        .map<RankingDetail>((item) => RankingDetail.fromJson(item))
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await localData.setSearchHistory(list: searchHistory);
      searchHistory = await localData.getSearchHistory();
      await _getRankingList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 248, 255, 1),
      body: Container(
        padding: EdgeInsets.only(top: deviceInfo.statusBarHeight + 10),
        child: Column(
          children: [
            // 头部搜索栏
            SearchHearder(),
            SizedBox(height: 30),
            Operation(),
            SizedBox(height: 20),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double height = constraints.maxHeight;
                  print(height);
                  return SizedBox(
                    height: height,
                    child: CustomScrollView(
                      slivers: [
                        // 搜索记录
                        SliverToBoxAdapter(
                          child: SearchHistory(searchHistory: searchHistory),
                        ),
                        // 猜你喜欢
                        SliverToBoxAdapter(
                          child: RecommendTitle(
                            recommendtitles: recommendtitles,
                          ),
                        ),
                        // 热搜榜单
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 20,
                              left: 20,
                              right: 20,
                            ),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 885,
                                viewportFraction: 0.77,
                                enableInfiniteScroll: false,
                                padEnds: false
                              ),
                              items: rankingList.map((item) {
                                return RankingItem(item: item);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: deviceInfo.width,
        padding: EdgeInsets.only(bottom: deviceInfo.bottomSafeAreaHeight),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.3],
            colors: [Colors.transparent, Colors.white],
          ),
        ),
        child: MusicPlayController(player: player),
      ),
    );
  }
}

// 头部搜索栏
class SearchHearder extends StatefulWidget {
  const SearchHearder({super.key});

  @override
  State<SearchHearder> createState() => _SearchHearderState();
}

class _SearchHearderState extends State<SearchHearder> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 延迟到首帧后聚焦，避免和页面动画冲突
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        _focusNode.requestFocus();
      });
    });
    // _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 40,
      child: Flex(
        spacing: 10,
        direction: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(CupertinoIcons.chevron_back, size: 30),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                spacing: 5,
                children: [
                  Icon(CupertinoIcons.search, size: 20, color: Colors.grey),
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: '归去来兮  花粥',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: VerticalDivider(color: Colors.grey, thickness: 1),
                  ),
                  // VerticalDivider(
                  //   width: 30,
                  //   color: Colors.red,
                  //   indent: 0,
                  //   endIndent: 20,
                  //   thickness: 5,
                  // ),
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      foregroundColor: WidgetStateProperty.all(
                        Colors.transparent,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: WidgetStateProperty.all(Size(0, 0)),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {},
                    child: Text(
                      '搜索',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 功能栏
class Operation extends StatefulWidget {
  const Operation({super.key});

  @override
  State<Operation> createState() => _OperationState();
}

class _OperationState extends State<Operation> {
  List<Map<String, dynamic>> operationList = [
    {'icon': 'lib/assets/icon/geshou1.svg', 'text': '歌手'},
    {'icon': 'lib/assets/icon/yinlegedanyinfu.svg', 'text': '曲风'},
    {'icon': 'lib/assets/icon/paihangbang.svg', 'text': '排行榜'},
    {'icon': 'lib/assets/icon/tinggeshiqu.svg', 'text': '识曲'},
    {'icon': 'lib/assets/icon/shuji2.svg', 'text': '听书'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: operationList.map((item) {
          return Expanded(
            child: PressMask(
              child: Flex(
                direction: Axis.vertical,
                spacing: 10,
                children: [
                  SvgPicture.asset(item['icon'], width: 30, height: 30),
                  Text(item['text']),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 搜索记录
class SearchHistory extends StatefulWidget {
  final List<String> searchHistory;
  const SearchHistory({super.key, required this.searchHistory});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  bool isSingleLine = true;

  Widget _buildBottom() {
    return IconButton(
      onPressed: () {
        isSingleLine = !isSingleLine;
        setState(() {});
      },
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.all(5)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: WidgetStateProperty.all(Size(0, 0)),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        backgroundColor: WidgetStateProperty.all(
          Color.fromRGBO(248, 248, 255, 1),
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: const Color.fromARGB(255, 206, 203, 203), width: 1),
        ),
      ),
      icon: Icon(
        isSingleLine ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
        size: 16,
        weight: 18,
      ),
    );
  }

  Widget _buildsignleLine(List<String> history) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Stack(
        children: [
          ClipRect(
            child: OverflowBox(
              maxWidth: double.infinity, // 解除宽度约束，Row 不溢出
              maxHeight: 40,
              alignment: Alignment.centerLeft,
              child: Row(spacing: 10, children: [...history.map(_buildChip)]),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(-5, 0), // changes position of shadow
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(-10, 0), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
          Positioned(right: 0, top: 8, child: PressMask(child: _buildBottom())),
        ],
      ),
    );
  }

  Widget _buildWrap(List<String> history) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          ...history.map(_buildChip),
          PressMask(child: _buildBottom()),
        ],
      ),
    );
  }

  Widget _buildChip(String item) {
    return PressMask(
      child: Chip(
        backgroundColor: Colors.white,
        label: Text(item),
        deleteIcon: Icon(Icons.close, color: Colors.grey),
        onDeleted: () async {
          print('delete $item');
          await localData.removeSearchHistory(item);
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (localData.searchHistory.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        spacing: 10,
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '搜索记录',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              PressMask(
                child: GestureDetector(
                  onTap: () {
                    ShowDialog.showLoadingDialog(
                      context,
                      content: '确定要清空历史记录吗?',
                      onConfirm: () async {
                        await localData.clearSearchHistory();
                        setState(() => localData.searchHistory = []);
                      },
                    );
                  },
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          if (isSingleLine)
            _buildsignleLine(localData.searchHistory)
          else
            _buildWrap(localData.searchHistory),
        ],
      ),
    );
  }
}

class RecommendTitle extends StatefulWidget {
  final List<String> recommendtitles;
  const RecommendTitle({super.key, required this.recommendtitles});

  @override
  State<RecommendTitle> createState() => _RecommendTitleState();
}

class _RecommendTitleState extends State<RecommendTitle> {
  Widget _buildItem(String item) {
    return PressMask(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      child: Column(
        spacing: 10,
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '猜你喜欢',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              PressMask(
                child: GestureDetector(
                  onTap: () {
                    print('刷新');
                  },
                  child: Icon(
                    CupertinoIcons.arrow_clockwise,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          GridView.count(
            padding: EdgeInsets.only(top: 5),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisExtent: 40,
            children: [...widget.recommendtitles.map((e) => _buildItem(e))],
          ),
        ],
      ),
    );
  }
}

class RankingItem extends StatefulWidget {
  final RankingDetail item;
  const RankingItem({super.key, required this.item});

  @override
  State<RankingItem> createState() => _RankingItemState();
}

class _RankingItemState extends State<RankingItem> {

  Widget _buildSongItem(singleMusic music, int index) {
    Color numberColor = index <= 2 ? Colors.red : Colors.grey;
    Color nameColor = index <= 2 ? Colors.black : Colors.grey;
    FontWeight fontWeight = index <= 2 ? FontWeight.bold : FontWeight.normal;
    return PressMask(
      child: Container(
        height: 30,
        margin: EdgeInsets.only(top: 10),
        child: Flex(
          spacing: 10,
          direction: Axis.horizontal,
          children: [
            Text('${index+1}', style: TextStyle(color: numberColor, fontSize: 16, fontWeight: fontWeight)),
            Expanded(
              child: Text(
                music.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: nameColor, fontSize: 16, fontWeight: fontWeight),
              ),
            ),
          ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        spacing: 10,
        children: [
          // 标题
          Flex(
            direction: Axis.horizontal,
            spacing: 5,
            children: [
              Text(
                widget.item.info.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              PressMask(
                child: TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    minimumSize: WidgetStateProperty.all(Size.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                    backgroundColor: WidgetStateProperty.all(Color.fromRGBO(220, 220, 220, 1)),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Icon(Icons.play_arrow, size: 18, color: Colors.black),
                      Text(
                        '播放',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 1,
            color: Color.fromRGBO(245, 245, 245, 1),
          ),
          // Expanded(child: ListView.builder(
          //   itemCount: widget.item.songs.length,
          //   itemBuilder: (context, index) {
          //     return _buildSongItem(widget.item.songs[index], index);
          //   }
          // ))
          Expanded(child: Column(
            children: widget.item.songs.map((e) => _buildSongItem(e, widget.item.songs.indexOf(e))).toList(),
          ))
        ],
      ),
    );
  }
}
