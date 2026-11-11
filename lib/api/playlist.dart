import 'package:dio/dio.dart';
import 'package:yun_music/constant/index.dart';
import 'package:yun_music/utils/Diorequest.dart';
import 'package:yun_music/viewmodel/playlist.dart';

Future<List<RecommendMusicNL>> getRecommendMusicNL({int page = 12}) async {
  List<dynamic> res = await diorequest.get(
    MusicApiUrl.recommendMusicNL,
    params: {"limit": page},
  );
  // print('实际数据');
  // print(res[0]['song']["artists"]);
  List<RecommendMusicNL> recommendMusicNL = res.map((item) {
    return RecommendMusicNL.fromJson({
      "id": item["id"],
      "type": item["type"],
      "name": item["name"],
      "copywriter": item["copywriter"],
      "picUrl": item["picUrl"],
      "canDislike": item["canDislike"],
      "mvid": item['song']["mvid"],
      "fee": item['song']['fee'],
      "pop": item['song']['popularity'],
      "artists": item['song']["artists"][0],
      "duration": item['song']["duration"],
      "album": item['song']["album"],
    });
  }).toList();
  return recommendMusicNL;
}

Future<List<RecommendPlayList>> getHightQualityPlayList({
  int page = 1,
  String tag = "全部",
}) async {
  Map<String, dynamic> res = await diorequest.get(
    MusicApiUrl.highqualityMusic,
    params: {"cat": tag, "limit": page},
  );
  List<dynamic> playlists = res['playlists'];

  List<RecommendPlayList> highqualityPlayList = playlists.map((item) {
    return RecommendPlayList.fromJson({
      "name": item['name'],
      "id": item['id'],
      "coverImgUrl": item['coverImgUrl'],
      "tags": item['tags'],
      "copywriter": '$tag推荐',
      "type": '1',
    });
  }).toList();
  return highqualityPlayList;
}

// 获取歌单列表
Future<List<singleMusic>> getPlayListDetail(String id) async {
  Map<String, dynamic> res = await diorequest.get(
    MusicApiUrl.playlistDetail,
    params: {"id": id},
  );
  List<dynamic> tracks = res['playlist']?['tracks'];
  print('tracks');
  print(tracks);
  // if(tracks is! List) return [];

  List<singleMusic> singleMusicList = tracks.whereType<Map>().map((item) {
    return singleMusic.fromJson({
      "id": item['id'],
      "name": item['name'],
      "ar": item['ar'][0],
      "picUrl": item['al']['picUrl'],
      "pop": item['pop'],
      "fee": item['fee'],
      "dt": item['dt'],
      "sq": item['sq'],
      "h": item['h'],
      "m": item['m'],
      "l": item['l'],
    });
  }).toList();
  return singleMusicList;
}

// 获取歌单详情
Future<PlayList> getPlayListDetailInfo(String id) async {
  Map<String, dynamic> res = await diorequest.get(
    MusicApiUrl.playlistDetail,
    params: {"id": id},
  );
  return PlayList.fromJson(res['playlist']);
}

Future<List<RecommendPlayList>> getNetFriendPlayList({
  int page = 1,
  String order = "hot",
}) async {
  Map<String, dynamic> res = await diorequest.get(
    MusicApiUrl.newAlbum,
    // MusicApiUrl.netFriendPlaylist,
    // params: {"order": order, "limit": page},
  );
  // List<dynamic> playlists = res['playlists'];
  List<dynamic> playlists = res['albums'];

  List<RecommendPlayList> highqualityPlayList = playlists.map((item) {
    return RecommendPlayList.fromJson({
      "name": item['name'],
      "id": item['id'],
      "coverImgUrl": item['picUrl'],
      "tags": item['tags'] == '' ? [] : item['tags'],
      "copywriter": '$order推荐',
      "type": '1',
    });
  }).toList();
  return highqualityPlayList;
}

Future<List<HotPlayListCate>> getHotPlayList() async {
  Map<String, dynamic> res = await diorequest.get(MusicApiUrl.hotPlayListCates);
  List<dynamic> playlists = res['tags'];

  List<HotPlayListCate> hotPlayList = playlists.map((item) {
    return HotPlayListCate.fromJson({"name": item['name'], "id": item['id']});
  }).toList();
  return hotPlayList;
}

// 获取排行榜歌单
Future<List<rankingListPlayList>> getRankingListPlayList() async {
  Map<String, dynamic> res = await diorequest.get(MusicApiUrl.topList);
  List<dynamic> playlists = res['list'];

  List<rankingListPlayList> list = playlists.map((item) {
    return rankingListPlayList.fromJson(item);
  }).toList();

  return list;
}

// 获取歌曲详情
Future<String> getSongDetail(String id) async {
  Map<String, dynamic> res = await  diorequest.get(MusicApiUrl.songDetail, params: {"id": id, "level": "exhigh"});
  List<Map<String, dynamic>> data = res['data'];
  if (data.isEmpty) return '';
  return data[0]['url'];
}

// 歌曲地址重定向获取
Future<String?> resolveDirectAudioUrl(String outerUrl) async {
  final dio = Dio();
  try {
    final response = await dio.get(
      outerUrl,
      options: Options(
        followRedirects: true,
        maxRedirects: 5,
        // 带上必要的请求头，增加成功率
        headers: {
          'Referer': 'https://music.163.com/',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36 Edg/155.0.0.0',
        },
      ),
    );
    // 返回最终请求的URL
    return response.realUri.toString();
  } catch (e) {
    print('解析直链失败: $e');
    return null;
  }
}

// 获取专辑歌曲内容
Future<List<singleMusic>> getAlbumDetail(String id) async {
  Map<String, dynamic> res = await diorequest.get(MusicApiUrl.albumDetail, params: {"id": id});
  List<dynamic> tracks = res['songs'];

  List<singleMusic> list = tracks.map((item) {
    return singleMusic.fromJson({
      "id": item['id'],
      "name": item['name'],
      "ar": item['ar'][0],
      "picUrl": item['al']['picUrl'],
      "pop": item['pop'],
      "fee": item['fee'],
      "dt": item['dt'],
      "sq": item['sq'],
      "h": item['h'],
      "m": item['m'],
      "l": item['l'],
    });
  }).toList();
  print(list);
  return list;
}
// 获取专辑详情内容
Future<AlbumDetail> getAlbumDetailInfo(String id) async {
  Map<String, dynamic> res = await diorequest.get(MusicApiUrl.albumDetail, params: {"id": id});
  return AlbumDetail.fromJson(res);
}

// 获取榜单详情
Future<RankingDetail> getRankingListDetail(String id) async {
  Map<String, dynamic> res = await diorequest.get(MusicApiUrl.playlistDetail, params: {"id": id});
  return RankingDetail.fromJson(res['playlist']);
}

// 获取推荐歌单
Future<List<PlayList>> getRecommendPlayList(Map<String, dynamic> params) async {
  List<dynamic> results = await diorequest.get(MusicApiUrl.recommendPlayList, params: params);
  // List<dynamic> results = res['result'];

  return results.map((item) {
    return PlayList.fromJson({
      ...item,
      'coverImgUrl': item['picUrl'],
    });
  }).toList();
}