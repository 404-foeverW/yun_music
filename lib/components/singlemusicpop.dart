// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yun_music/components/tag.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class SongSheet {
  String title;
  String? icon;
  String? picUrl;
  int? musicnum;
  SongSheet({required this.title, this.icon, this.picUrl, this.musicnum});
}

class MusicOperator {
  String? prop;
  String iconPath;
  String? activeIcon;
  String? text;
  String? activeText;
  String? adverb; // 副词
  Function? callback;
  Widget? suffix; // 后缀组件
  bool show; // 是否显示
  bool Function()? showfun;
  bool active; // 是否激活
  bool Function({MusicOperator? item, singleMusic? music})? boolActive;
  Function? logic;

  MusicOperator({
    required this.iconPath,
    this.activeIcon,
    this.prop,
    this.text,
    this.activeText,
    this.adverb,
    this.callback,
    this.suffix,
    this.show = true,
    this.showfun,
    this.active = false,
    this.boolActive,
    this.logic,
  });
}

class SuffixTag extends StatefulWidget {
  final String text;
  final Color fillcolor;
  final Color textcolor;

  static const Color defaultFullColor = Color.fromARGB(255, 243, 138, 130);
  static const Color defaultTextColor = Color.fromARGB(255, 212, 18, 18);
  static const Color defaultBorderColor = Color.fromARGB(255, 245, 109, 100);

  const SuffixTag({
    super.key,
    required this.text,
    this.fillcolor = defaultFullColor,
    this.textcolor = defaultTextColor,
  });

  @override
  State<SuffixTag> createState() => _SuffixTagState();
}

class _SuffixTagState extends State<SuffixTag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: widget.textcolor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          color: widget.textcolor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SingleMusicPop extends StatefulWidget {
  final singleMusic music;
  final double height;
  final double width;
  final BuildContext currContext;
  const SingleMusicPop({
    super.key,
    required this.music,
    required this.height,
    required this.currContext,
    required this.width,
  });

  @override
  State<SingleMusicPop> createState() => _SingleMusicPopState();
}

class _SingleMusicPopState extends State<SingleMusicPop> {
  bool collectionMusicList({MusicOperator? item, singleMusic? music}) {
    Navigator.pop(widget.currContext);
    showModalBottomSheet(
      context: widget.currContext,
      builder: (context) =>
          CollectionPop(height: widget.height, width: widget.width),
    );
    return true;
  }

  bool sureNoLike({MusicOperator? item, singleMusic? music}) {
    Navigator.pop(widget.currContext);
    showModalBottomSheet(
      context: widget.currContext,
      builder: (context) => NoLikePop(height: widget.height, item: item),
    );
    return true;
  }

  late List<MusicOperator> operatorList;

  @override
  void initState() {
    super.initState();
    operatorList = [
      MusicOperator(
        prop: 'appreciate',
        iconPath: 'lib/assets/icon/zanshangguanli.svg',
        text: '赞赏该曲',
        show: false,
      ),
      MusicOperator(iconPath: 'lib/assets/icon/xiayishou.svg', text: '下一首播放'),
      MusicOperator(
        iconPath: 'lib/assets/icon/xihuan-xianxing.svg',
        activeIcon: 'lib/assets/icon/aixin.svg',
        text: '喜欢',
        activeText: '取消喜欢',
        active: false,
        boolActive: ({MusicOperator? item, singleMusic? music}) {
          if (item == null) return false;
          item.active = !item.active;
          print(item.active);
          return false;
        },
      ),
      MusicOperator(
        iconPath: 'lib/assets/icon/tianjia.svg',
        text: '收藏到歌单',
        boolActive: collectionMusicList,
      ),
      MusicOperator(
        iconPath: 'lib/assets/icon/buxihuan.svg',
        text: '减少推荐',
        boolActive: sureNoLike,
      ),
      MusicOperator(iconPath: 'lib/assets/icon/xiazai2.svg', text: '下载'),
      MusicOperator(iconPath: 'lib/assets/icon/pinglun.svg', text: '评论'),
      MusicOperator(iconPath: 'lib/assets/icon/fenxiang1.svg', text: '分享'),
      MusicOperator(
        iconPath: 'lib/assets/icon/gouwuche.svg',
        text: '单曲购买',
        suffix: SuffixTag(text: '永久拥有该歌曲'),
      ),
      MusicOperator(
        prop: 'ar',
        iconPath: 'lib/assets/icon/geshou.svg',
        text: '歌手:',
        adverb: '',
      ),
      MusicOperator(
        prop: 'ars',
        iconPath: 'lib/assets/icon/chuangzuozheguanli.svg',
        text: '创作者:',
        adverb: '',
        show: false,
      ),
      MusicOperator(
        prop: 'album',
        iconPath: 'lib/assets/icon/zhuanji.svg',
        text: '专辑',
        adverb: '',
      ),
      MusicOperator(
        iconPath: 'lib/assets/icon/yuntuige.svg',
        text: '云推歌',
        adverb: '',
        show: false,
      ),
      MusicOperator(iconPath: 'lib/assets/icon/guangpu.svg', text: '更多乐谱: 吉他'),
      MusicOperator(iconPath: 'lib/assets/icon/lingsheng.svg', text: '设为铃声'),
      MusicOperator(
        iconPath: 'lib/assets/icon/lipinka.svg',
        text: '音乐礼品卡',
        suffix: SuffixTag(text: '送好友'),
      ),
    ];
    for (var item in operatorList) {
      if (item.prop == '') continue;
      if (item.prop == 'ar') {
        item.adverb = widget.music.artists.name;
      }
      if (item.prop == 'album') {
        item.adverb = widget.music.album?.name;
      }
    }
    operatorList = operatorList.where((item) => item.show).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height * 0.8,
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Flex(
              spacing: 10,
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(
                  spacing: 10,
                  direction: Axis.horizontal,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://images.weserv.nl/?url=${widget.music.picUrl}',
                        headers: {
                          'Referer': 'https://music.163.com/',
                          'sec-ch-ua-platform': '"Windows"',
                          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0',
                        },
                        width: 60,
                        height: 60,
                      ),
                    ),
                    Expanded(
                      child: Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flex(
                            direction: Axis.horizontal,
                            spacing: 5,
                            children: [
                              Expanded(
                                child: Text(
                                  '歌曲:  ${widget.music.name}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (widget.music.fee == 8)
                                Tag(
                                  music: TagInfo(
                                    fee: widget.music.fee,
                                    pop: widget.music.pop,
                                  ),
                                  type: 0,
                                ),
                            ],
                          ),
                          Text(
                            widget.music.artists.name,
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    if (widget.music.fee == 8)
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          side: WidgetStateProperty.all(
                            BorderSide(color: Colors.red, width: 1),
                          ),
                          padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          ),
                          backgroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            //设置按下时的背景颜色
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.red;
                            }
                            //默认不使用背景颜色
                            return null;
                          }),
                          textStyle: WidgetStateProperty.all(
                            TextStyle(fontSize: 18, inherit: false),
                          ),
                          foregroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.white;
                            }
                            return Colors.red;
                          }),
                        ),
                        child: Text(
                          'VIP仅￥0.04/天',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
                if (widget.music.fee == 8)
                  Text(
                    '开通VIP畅享千万曲库下载特权',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: operatorList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: Color.fromRGBO(0, 0, 0, .3),
                  highlightColor: Color.fromRGBO(0, 0, 0, .1),
                  onTap: () {
                    if (operatorList[index].boolActive == null) return;
                    operatorList[index].boolActive!(
                      item: operatorList[index],
                      music: widget.music,
                    );
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Flex(
                      direction: Axis.horizontal,
                      spacing: 10,
                      children: [
                        if (operatorList[index].active == false)
                          SvgPicture.asset(
                            operatorList[index].iconPath,
                            width: 25,
                            height: 25,
                          ),
                        if (operatorList[index].active == true &&
                            operatorList[index].activeIcon != '')
                          SvgPicture.asset(
                            operatorList[index].activeIcon ?? '',
                            width: 25,
                            height: 25,
                          ),
                        Expanded(
                          child: Flex(
                            direction: Axis.horizontal,
                            spacing: 5,
                            children: [
                              Text(
                                operatorList[index].text ?? '',
                                style: TextStyle(fontSize: 14),
                              ),
                              if (operatorList[index].adverb != '')
                                Text(
                                  operatorList[index].adverb ?? '',
                                  style: TextStyle(fontSize: 14),
                                ),
                              if (operatorList[index].suffix != null)
                                operatorList[index].suffix ?? Text(''),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 收藏弹出框
class CollectionPop extends StatefulWidget {
  final double height;
  final double width;
  const CollectionPop({super.key, required this.height, required this.width});

  @override
  State<CollectionPop> createState() => _CollectionPopState();
}

class _CollectionPopState extends State<CollectionPop> {
  // 排序: 0-常用 1-默认
  int sorting = 0;
  List<SongSheet> musicList = [
    SongSheet(
      title: '新建歌单',
      icon: 'lib/assets/icon/jiahao_o.svg',
      picUrl: '',
      musicnum: 0,
    ),
    SongSheet(
      title: '我喜欢的音乐',
      icon: 'lib/assets/icon/aixin.svg',
      picUrl: '',
      musicnum: 161,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height * 0.45,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Flex(
                mainAxisSize: MainAxisSize.max,
                direction: Axis.horizontal,
                children: [
                  Text(
                    '收藏到歌单',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 5,
                      children: [
                        GestureDetector(
                          onTap: () {
                            sorting = sorting == 1 ? 0 : 1;
                            setState(() {});
                          },
                          child: Flex(
                            direction: Axis.horizontal,
                            spacing: 5,
                            children: [
                              SvgPicture.asset(
                                'lib/assets/icon/zhuanhuanshunxu.svg',
                                width: 15,
                                height: 15,
                              ),
                              Text(
                                sorting == 0 ? '常用' : '默认',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '|',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            '多选',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: musicList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: Color.fromRGBO(0, 0, 0, .3),
                  highlightColor: Color.fromRGBO(0, 0, 0, .1),
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Flex(
                      spacing: 10,
                      direction: Axis.horizontal,
                      children: [
                        if (musicList[index].picUrl != '')
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              'https://images.weserv.nl/?url=${musicList[index].picUrl}',
                              headers: {
                                'Referer': 'https://music.163.com/',
                                'sec-ch-ua-platform': '"Windows"',
                                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0',
                              },
                              width: 60,
                              height: 60,
                            ),
                          ),
                        if (musicList[index].picUrl == '')
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 218, 215, 215),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                musicList[index].icon ?? '',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Flex(
                            direction: Axis.vertical,
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                musicList[index].title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (musicList[index].musicnum != 0)
                                Text(
                                  '${musicList[index].musicnum}首',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 不喜欢内容弹出框
class NoLikePop extends StatefulWidget {
  final singleMusic? music;
  final MusicOperator? item;
  final double height;
  const NoLikePop({super.key, this.item, required this.height, this.music});

  @override
  State<NoLikePop> createState() => _NoLikePopState();
}

class _NoLikePopState extends State<NoLikePop> {
  late List<Map<String, dynamic>> selectList;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    selectList = [
      {'text': '不喜欢歌曲', 'adverb': widget.music?.name ?? '', 'value': ''},
      {
        'text': '不喜欢音乐人',
        'adverb': widget.music?.artists.name ?? '',
        'value': '',
      },
    ];
  }

  List buildSelectItem() {
    return List.generate(selectList.length, (index) {
      return GestureDetector(
        onTap: () {
          currentIndex = index;
          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${selectList[index]['text']}: ${selectList[index]['adverb']}',
              ),
              if (currentIndex == index)
                SvgPicture.asset(
                  'lib/assets/icon/xuanzhong.svg',
                  width: 20,
                  height: 20,
                ),
              if (currentIndex != index)
                SvgPicture.asset(
                  'lib/assets/icon/yuanxingweixuanzhong.svg',
                  width: 20,
                  height: 20,
                ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Text(
                '选择不喜欢的内容',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '音乐黑名单',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (selectList.isNotEmpty) ...buildSelectItem(),
          SizedBox(height: 40,),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 70, vertical: 10)),
                backgroundColor: WidgetStateProperty.all(Colors.red),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              child: Text(
                '确定',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
