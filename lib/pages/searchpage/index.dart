import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/api/playlist.dart';
import 'package:yun_music/components/tabbar.dart';
import 'package:yun_music/pages/home/components/userInfoDrawer.dart';
import 'package:yun_music/pages/searchpage/components/header.dart';
import 'package:yun_music/pages/searchpage/components/searchcate.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/store/musicplay.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final player = Get.find<MusicPlayer>(); //获取播放器实例
  final _key = GlobalKey<ScaffoldState>();
  final deviceInfo = Get.find<DeviceInfoService>();
  double contentHeight = 100;
  Duration fristDuration = Duration.zero;
  List<PlayList> recommendPlayList = [];

  List<String> randomKeyValues = ['周杰伦', '薛之谦', '陈奕迅', '林俊杰'];
  RxInt keyValueIndex = 0.obs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      recommendPlayList = await getRecommendPlayList({'limit': 100});
      setState(() {});
    });
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      keyValueIndex++;
      if(keyValueIndex >= randomKeyValues.length) {
        keyValueIndex.value = 0;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Drawer(child: Userinfodrawer()),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(color: Color.fromRGBO(248, 248, 255, 1)),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: Header(
                contentHeight: contentHeight,
                paddingTop: deviceInfo.statusBarHeight,
                scaffoldkey: _key,
                randomKeyValues: randomKeyValues,
                keyValueIndex: keyValueIndex,
              ),
            ),
            SliverToBoxAdapter(child: SearchCate()),
            SliverToBoxAdapter(child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text('浏览全部', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87))
            )),
            SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
                mainAxisExtent: 120,
              ),
              itemCount: recommendPlayList.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: 'https://images.weserv.nl/?url=${recommendPlayList[index].coverImgUrl}',
                            httpHeaders: {
                              'Referer': 'https://music.163.com/',
                              'sec-ch-ua-platform': '"Windows"',
                              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0',
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recommendPlayList[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // SizedBox(height: 2),
                            // Text(
                            //   '听你想听的',
                            //   style: TextStyle(
                            //     color: Colors.white.withValues(alpha: 0.6),
                            //     fontSize: 14,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: TabBarList(
        player: player,
        fristDuration: fristDuration,
      ),
    );
  }
}
