// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yun_music/components/musicplayer.dart';
import 'package:yun_music/components/pressmask.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/utils/showDialog.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final deviceInfo = Get.find<DeviceInfoService>();
  final player = Get.find<MusicPlayer>();
  LocalData localData = LocalData();

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
  @override
  void initState() {
    super.initState();
    searchHistory.map((item)=> localData.setSearchHistory(item));
    Future.microtask(() async {
      searchHistory = await localData.getSearchHistory();
      print(searchHistory);
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
                        SliverToBoxAdapter(child: SearchHistory(
                          searchHistory: searchHistory,
                        )),
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
  const SearchHistory({
    super.key,
    required this.searchHistory,
  });

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
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
        ],
      ),
    );
  }
}