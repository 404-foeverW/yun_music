import 'package:flutter/material.dart';
import 'package:yun_music/main.dart';
import 'package:yun_music/pages/album/index.dart';
import 'package:yun_music/pages/backgroundplaylist/index.dart';
import 'package:yun_music/pages/home/index.dart';
import 'package:yun_music/pages/login/index.dart';
import 'package:yun_music/pages/my/index.dart';
import 'package:yun_music/pages/ranking/index.dart';
import 'package:yun_music/pages/recommendmusic/index.dart';
import 'package:yun_music/pages/searchpage/index.dart';

Widget getRouterWidgets() {
  return MaterialApp(
    navigatorKey: navigatorKey,
    routes: getRouterMap(),
  );
}

Map<String, Widget Function(BuildContext)> getRouterMap() {
  return {
    '/login': (context) => LoginPage(),
    '/everdrecommendMusicPage': (context) => RecommendMusicPage(),
    '/bgplaylist': (context) => BackgroundPlaylistPage(),
    '/ablum': (context) => AlbumPage(),
    '/ranking': (context) => RankingPage(),
    // '/my': (context) => MyPage(),
    '/my': (context) => MyPageT(),
    '/searchPage': (context) => SearchPage(),
    // '/': (context) => LoginPage(),
    '/': (context) => HomePage()
  };
}