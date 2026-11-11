// 无登录下推荐新曲
import 'package:yun_music/viewmodel/index.dart';

class RecommendMusicNL {
  int id;
  int type;
  String name;
  Map copywriter;
  String picUrl;
  bool canDislike;
  int mvid;
  int duration;
  int fee;
  int pop;
  Artists artists;
  Album? album;
 
  RecommendMusicNL({
    required this.id,
    required this.type,
    required this.name,
    required this.copywriter,
    required this.picUrl,
    required this.canDislike,
    required this.mvid,
    required this.fee,
    required this.pop,
    required this.artists,
    required this.duration,
    this.album
  });
  
  factory RecommendMusicNL.fromJson(Map<String, dynamic> json) {
    return RecommendMusicNL(
      id: json['id'] ?? "",
      type: json['type'] ?? 0,
      name: json['name'] ?? "",
      copywriter: json['copywriter'] ?? {},
      picUrl: json['picUrl'] ?? "",
      canDislike: json['canDislike'] ?? false,
      mvid: json['mvid'] ?? 0,
      artists: Artists.fromJson(json['artists']),
      fee: json['fee'] ?? 0,
      pop: json['pop'] ?? 0,
      duration: json['duration'] ?? 0,
      album: json['album'] != null ? Album.fromJson(json['album']) : null,
    );
  }
}
// 作者
class Artists {
  String name;
  int id;
  int picId;
  int img1v1Id;
  String briefDesc;
  String picUrl;
  String img1v1Url;
  int albumSize;
  List alias;
  String trans;
  int musicSize;
  int topicPerson;

  Artists({
    required this.name,
    required this.id,
    required this.picId,
    required this.img1v1Id,
    required this.briefDesc,
    required this.picUrl,
    required this.img1v1Url,
    required this.albumSize,
    required this.alias,
    required this.trans,
    required this.musicSize,
    required this.topicPerson,
  });

  factory Artists.fromJson(Map<String, dynamic> json) {
    return Artists(
      name: json['name'] ?? "",
      id: json['id'] ?? 0,
      picId: json['picId'] ?? 0,
      img1v1Id: json['img1v1Id'] ?? 0,
      briefDesc: json['briefDesc'] ?? "",
      picUrl: json['picUrl'] ?? "",
      img1v1Url: json['img1v1Url'] ?? "",
      albumSize: json['albumSize'] ?? 0,
      alias: json['alias'] ?? [],
      trans: json['trans'] ?? "",
      musicSize: json['musicSize'] ?? 0,
      topicPerson: json['topicPerson'] ?? 0,
    );
  }
}
// 首页推荐歌单
class RecommendPlayList {
  String name;
  String id;
  String coverImgUrl;
  List tags;
  String copywriter;
  //0: 推荐歌单 1: 精选歌单
  String type;

  RecommendPlayList({
    required this.name,
    required this.id,
    required this.coverImgUrl,
    required this.tags,
    required this.copywriter,
    required this.type,
  });

  factory RecommendPlayList.fromJson(Map<String, dynamic> json) {
    return RecommendPlayList(
      name: json['name'] ?? "",
      id: json['id'].toString(),
      coverImgUrl: json['coverImgUrl'] ?? "",
      tags: json['tags'] ?? [],
      copywriter: json['copywriter'] ?? "",
      type: json['type'] ?? "1",
    );
  }
}

// 热门歌单分类
class HotPlayListCate {
  String name;
  int id;

  HotPlayListCate({
    required this.name,
    required this.id,
  });

  factory HotPlayListCate.fromJson(Map<String, dynamic> json) {
    return HotPlayListCate(
      name: json['name'] ?? "",
      id: json['id'] ?? 0,
    );
  }
}


enum freeType {
  // fee 为 1 或 8 的歌曲均可单独购买 2 元单曲

  // 免费或无版权
  free(0),
  // VIP 歌曲
  vip(1),
  // 购买专辑
  buyalbum(4),
  // 非会员可免费播放低音质，会员可播放高音质及下载
  notvip(8);
  const freeType(this.value);
  final int value;
}

// 文件信息
class fileInfo {
  int br;
  int fid;
  int size;
  int vd;

  fileInfo({
    required this.br,
    required this.fid,
    required this.size,
    required this.vd,
  });

  factory fileInfo.fromJson(Map<String, dynamic> json) {
    return fileInfo(
      br: json['br'] ?? 0,
      fid: json['fid'] ?? 0,
      size: json['size'] ?? 0,
      vd: json['vd'] ?? 0,
    );
  }
}

// 专辑信息
class AlbumInfo {
  bool liked;
  int resourceType;
  int resourceId;
  int commentCount;
  int likedCount;
  int shareCount;
  String threadId;

  AlbumInfo({
    required this.liked,
    required this.resourceType,
    required this.resourceId,
    required this.commentCount,
    required this.likedCount,
    required this.shareCount,
    required this.threadId,
  });

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return AlbumInfo(
      liked: json['liked'] ?? false,
      resourceType: json['resourceType'] ?? 0,
      resourceId: json['resourceId'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      likedCount: json['likedCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      threadId: json['threadId'] ?? "",
    );
  }
}

/// 专辑模型
class Album {
  /// 专辑名
  final String name;

  /// 专辑 ID
  final int id;

  /// 专辑类型，如 Single
  final String type;

  /// 歌曲数量
  final int size;

  /// 封面图片 ID（大整数，Web 平台可能精度丢失，建议用 picIdStr）
  final int picId;

  /// 模糊封面图地址
  final String blurPicUrl;

  /// 公司 ID
  final int companyId;

  /// 封面图片 ID（与 picId 相同）
  final int pic;

  /// 封面图片地址
  final String picUrl;

  /// 发布时间（毫秒时间戳）
  final int publishTime;

  /// 描述
  final String description;

  /// 标签
  final String tags;

  /// 发行公司
  final String company;

  /// 简要描述
  final String briefDesc;

  /// 歌曲列表（如需强类型可替换为 List<Song>）
  final List<dynamic> songs;

  /// 别名列表
  final List<String> alias;

  /// 状态
  final int status;

  /// 版权 ID
  final int copyrightId;

  /// 评论 thread ID
  final String commentThreadId;

  /// 子类型，如“录音室版”
  final String subType;

  /// 译名，可能为 null
  final String? transName;

  /// 是否在售
  final bool onSale;

  /// 标记
  final int mark;

  /// 无缝播放标记
  final int gapless;

  /// 杜比音效标记
  final int dolbyMark;

  /// 封面图片 ID 的字符串形式（推荐 Web 端使用）
  final String picIdStr;
  final Artists artist;
  final AlbumInfo albumInfo;

  const Album({
    required this.name,
    required this.id,
    required this.type,
    required this.size,
    required this.picId,
    required this.blurPicUrl,
    required this.companyId,
    required this.pic,
    required this.picUrl,
    required this.publishTime,
    required this.description,
    required this.tags,
    required this.company,
    required this.briefDesc,
    required this.songs,
    required this.alias,
    required this.status,
    required this.copyrightId,
    required this.commentThreadId,
    required this.subType,
    required this.transName,
    required this.onSale,
    required this.mark,
    required this.gapless,
    required this.dolbyMark,
    required this.picIdStr,
    required this.artist,
    required this.albumInfo,
  });

  /// 从 JSON 构造
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      picId: json['picId'] as int? ?? 0,
      blurPicUrl: json['blurPicUrl'] as String? ?? '',
      companyId: json['companyId'] as int? ?? 0,
      pic: json['pic'] as int? ?? 0,
      picUrl: json['picUrl'] as String? ?? '',
      publishTime: json['publishTime'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      tags: json['tags'] as String? ?? '',
      company: json['company'] as String? ?? '',
      briefDesc: json['briefDesc'] as String? ?? '',
      songs: json['songs'] as List<dynamic>? ?? const [],
      alias: (json['alias'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: json['status'] as int? ?? 0,
      copyrightId: json['copyrightId'] as int? ?? 0,
      commentThreadId: json['commentThreadId'] as String? ?? '',
      subType: json['subType'] as String? ?? '',
      transName: json['transName'] as String?,
      onSale: json['onSale'] as bool? ?? false,
      mark: json['mark'] as int? ?? 0,
      gapless: json['gapless'] as int? ?? 0,
      dolbyMark: json['dolbyMark'] as int? ?? 0,
      picIdStr: json['picId_str'] as String? ?? '',
      artist: json['artist'] != null ? Artists.fromJson(json['artist']) : Artists.fromJson({}),
      albumInfo: json['info'] != null ? AlbumInfo.fromJson(json['info']) : AlbumInfo.fromJson({}),
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'type': type,
      'size': size,
      'picId': picId,
      'blurPicUrl': blurPicUrl,
      'companyId': companyId,
      'pic': pic,
      'picUrl': picUrl,
      'publishTime': publishTime,
      'description': description,
      'tags': tags,
      'company': company,
      'briefDesc': briefDesc,
      'songs': songs,
      'alias': alias,
      'status': status,
      'copyrightId': copyrightId,
      'commentThreadId': commentThreadId,
      'subType': subType,
      'transName': transName,
      'onSale': onSale,
      'mark': mark,
      'gapless': gapless,
      'dolbyMark': dolbyMark,
      'picId_str': picIdStr,
    };
  }

  /// 发布时间转为 DateTime
  DateTime get publishDateTime =>
      DateTime.fromMillisecondsSinceEpoch(publishTime);

  @override
  String toString() => 'Album(id: $id, name: $name, type: $type)';
}

// 专辑详情页面
class AlbumDetail {
  List<singleMusic> songs;
  Album album;

  AlbumDetail({
    required this.songs,
    required this.album,
  });

  factory AlbumDetail.fromJson(Map<String, dynamic> json) {
    return AlbumDetail(
      songs: (json['songs'] as List<dynamic>)
          .map((e) => singleMusic.fromJson(e))
          .toList(),
      album: Album.fromJson(json['album'])
    );
  }
}

// 歌曲
class singleMusic {
  String name;
  String id;
  String picUrl;
  int pop;
  int fee;
  int dt;
  int mvid;
  // 无损质量文件信息
  fileInfo? sq;
  // 高质量文件信息
  fileInfo? h;
  // 中质量文件信息
  fileInfo? m;
  // 低质量文件信息
  fileInfo? l;
  Artists artists;
  Album? album;

  singleMusic({
    required this.name,
    required this.id,
    required this.mvid,
    required this.picUrl,
    required this.pop,
    required this.fee,
    required this.dt,
    required this.artists,
    this.album,
    this.sq,
    this.h,
    this.m,
    this.l,
  });

  factory singleMusic.fromJson(Map<String, dynamic> json) {
    Album? album;
    if(json['album'] != null) {
      album = Album.fromJson(json['album']);
    }
    if(json['al'] != null) {
      album = Album.fromJson(json['al']);
    }
    Artists artists;
    if(json['ar'] is List) {
      artists = Artists.fromJson(json['ar'][0]);
    }else {
      artists = Artists.fromJson(json['ar']);
    }
    int mvid = 0;
    if(json['mv'] != null) {
      mvid = json['mv'];
    }
    if(json['mvid'] != null) {
      mvid = json['mvid'];
    }
    String picUrl = '';
    if(json['picUrl'] != null) {
      picUrl = json['picUrl'];
    }
    if(json['al'] != null && json['al']['picUrl'] != null) {
      picUrl = json['al']['picUrl'];
    }
    
    return singleMusic(
      name: json['name'] ?? "",
      id: json['id'].toString(),
      // mvid: json['mvid'] ? (json['mv'] ?? 0) : 0,
      mvid: mvid,
      picUrl: picUrl,
      pop: json['pop'] ?? 0,
      fee: json['fee'] ?? 0,
      dt: json['dt'] ?? 0,
      artists: artists,
      album: album ?? Album.fromJson({}),
      sq: json['sq'] != null ? fileInfo.fromJson(json['sq']) : fileInfo.fromJson({}),
      h: json['h'] != null ? fileInfo.fromJson(json['h']) : fileInfo.fromJson({}),
      m: json['m'] != null ? fileInfo.fromJson(json['m']) : fileInfo.fromJson({}),
      l: json['l'] != null ? fileInfo.fromJson(json['l']) : fileInfo.fromJson({}),
    );
  }
}

// 排行榜歌单
class rankingListPlayList {
  String name;
  int id;
  String coverImgUrl;
  String description;
  int playCount;
  int trackCount;
  String updateFrequency;
  int subscribedCount;

  rankingListPlayList({
    required this.name,
    required this.id,
    required this.coverImgUrl,
    required this.description,
    required this.playCount,
    required this.trackCount,
    required this.updateFrequency,
    required this.subscribedCount,
  });


  factory rankingListPlayList.fromJson(Map<String, dynamic> json) {
    return rankingListPlayList(
      name: json['name'] ?? "",
      id: json['id'] ?? 0,
      coverImgUrl: json['coverImgUrl'] ?? "",
      description: json['description'] ?? "",
      playCount: json['playCount'] ?? 0,
      trackCount: json['trackCount'] ?? 0,
      updateFrequency: json['updateFrequency'] ?? "",
      subscribedCount: json['subscribedCount'] ?? 0,
    );
  }
}
// 榜单信息
class RankingInfo {
  int id;
  String name;
  String coverImgUrl;
  String description;
  int playCount;
  int trackCount;
  String updateFrequency;
  int subscribedCount;
  int commentCount;
  int shareCount;
  List<UserInfo> subscribers;
  int trackUpdateTime; // 更新时间
  int trackNumberUpdateTime; // 歌曲数量更新时间
  int createTime; // 创建时间
  int status; // 状态
  bool opRecommend; // 是否推荐
  bool highQuality; // 是否高质量
  bool newImported; // 是否新导入
  bool ordered; // 是否排序
  int specialType; // 特殊类型
  int coverImgId; // 封面ID
  String commentThreadId; // 评论ID

  RankingInfo({
    required this.id,
    required this.name,
    required this.coverImgUrl,
    required this.description,
    required this.playCount,
    required this.trackCount,
    required this.updateFrequency,
    required this.subscribedCount,
    required this.commentCount,
    required this.shareCount,
    required this.subscribers,
    required this.trackUpdateTime,
    required this.trackNumberUpdateTime,
    required this.createTime,
    required this.status,
    required this.opRecommend,
    required this.highQuality,
    required this.newImported,
    required this.ordered,
    required this.specialType,
    required this.coverImgId,
    required this.commentThreadId,
  });

  factory RankingInfo.fromJson(Map<String, dynamic> json) {
    return RankingInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      coverImgUrl: json['coverImgUrl'] ?? "",
      description: json['description'] ?? "",
      playCount: json['playCount'] ?? 0,
      trackCount: json['trackCount'] ?? 0,
      updateFrequency: json['updateFrequency'] ?? "",
      subscribedCount: json['subscribedCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      subscribers: json['subscribers'] != null ? List<UserInfo>.from(json['subscribers'].map((x) => UserInfo.fromJson(x))) : [],
      trackUpdateTime: json['trackUpdateTime'] ?? 0,
      trackNumberUpdateTime: json['trackNumberUpdateTime'] ?? 0,
      createTime: json['createTime'] ?? 0,
      status: json['status'] ?? 0,
      opRecommend: json['opRecommend'] ?? false,
      highQuality: json['highQuality'] ?? false,
      newImported: json['newImported'] ?? false,
      ordered: json['ordered'] ?? false,
      specialType: json['specialType'] ?? 0,
      coverImgId: json['coverImgId'] ?? 0,
      commentThreadId: json['commentThreadId'] ?? "",
    );
  }
}
// 榜单详情
class RankingDetail {
  RankingInfo info;
  List<singleMusic> songs;

  RankingDetail({
    required this.info,
    required this.songs,
  });

  factory RankingDetail.fromJson(Map<String, dynamic> json) {
    return RankingDetail(
      info: RankingInfo.fromJson(json),
      songs: json['tracks'] != null ? List<singleMusic>.from(json['tracks'].map((x) => singleMusic.fromJson(x))) : [],
    );
  }
}

// 歌单创作者
class Creator {
  bool defaultAvatar; // 是否默认头像
  int province; // 省份
  int authStatus; // 认证状态
  bool followed; // 是否关注
  String avatarUrl; // 头像链接
  int accountStatus; // 账号状态
  int gender; // 性别
  int city; // 城市
  int birthday; // 生日
  int userId; // 用户ID
  int userType; // 用户类型
  String nickname; // 昵称
  String signature; // 个性签名
  String description; // 描述
  String detailDescription; // 详细描述
  int avatarImgId; // 头像ID
  int backgroundImgId; // 背景图片ID
  String backgroundUrl; // 背景图片链接
  int authority; // 权限
  bool mutual; // 是否互相关注
  List<dynamic> expertTags; // 专家标签
  int djStatus; // DJ状态
  int vipType; // VIP类型
  Map<String, dynamic>? remarkName; // 备注
  String avatarImgIdStr; // 头像ID字符串

  Creator({
    required this.defaultAvatar,
    required this.province,
    required this.authStatus,
    required this.followed,
    required this.avatarUrl,
    required this.accountStatus,
    required this.gender,
    required this.city,
    required this.birthday,
    required this.userId,
    required this.userType,
    required this.nickname,
    required this.signature,
    required this.description,
    required this.detailDescription,
    required this.avatarImgId,
    required this.backgroundImgId,
    required this.backgroundUrl,
    required this.authority,
    required this.mutual,
    required this.expertTags,
    required this.djStatus,
    required this.vipType,
    this.remarkName,
    required this.avatarImgIdStr,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      defaultAvatar: json['defaultAvatar'] ?? false,
      province: json['province'] ?? 0,
      authStatus: json['authStatus'] ?? 0,
      followed: json['followed'] ?? false,
      avatarUrl: json['avatarUrl'] ?? "",
      accountStatus: json['accountStatus'] ?? 0,
      gender: json['gender'] ?? 0,
      city: json['city'] ?? 0,
      birthday: json['birthday'] ?? 0,
      userId: json['userId'] ?? 0,
      userType: json['userType'] ?? 0,
      nickname: json['nickname'] ?? "",
      signature: json['signature'] ?? "",
      description: json['description'] ?? "",
      detailDescription: json['detailDescription'] ?? "",
      avatarImgId: json['avatarImgId'] ?? 0,
      backgroundImgId: json['backgroundImgId'] ?? 0,
      backgroundUrl: json['backgroundUrl'] ?? "",
      authority: json['authority'] ?? 0,
      mutual: json['mutual'] ?? false,
      expertTags: json['expertTags'] ?? [],
      djStatus: json['djStatus'] ?? 0,
      vipType: json['vipType'] ?? 0,
      remarkName: json['remarkName'],
      avatarImgIdStr: json['avatarImgIdStr'] ?? "",
    );
  }
}
// 歌单
class PlayList {
  int id;
  String name;
  String coverImgUrl;
  int adType;
  bool opRecommend;
  int trackCount; // 歌曲数量
  int specialType; // 0:普通歌单, 1:付费歌单, 2:机构歌单, 3:独家歌单, 4:达人歌单
  int playCount; // 播放次数
  int subscribedCount; // 订阅次数
  String description;
  List<dynamic> tags;
  int commentCount; // 评论次数
  int shareCount; // 分享次数
  Creator creator; // 歌单创作者
  int createTime; // 创建时间
  int updateTime; // 更新时间
  int trackUpdateTime; // 歌曲更新时间
  int trackNumberUpdateTime; // 歌曲数量更新时间
  int status; // 歌单状态
  bool highQuality; // 是否高质量
  bool newImported; // 是否新导入
  List<singleMusic> tracks; // 歌曲列表

  PlayList({
    required this.id,
    required this.name,
    required this.coverImgUrl,
    required this.adType,
    required this.opRecommend,
    required this.trackCount,
    required this.specialType,
    required this.playCount,
    required this.subscribedCount,
    required this.description,
    required this.tags,
    required this.commentCount,
    required this.shareCount,
    required this.creator,
    required this.createTime,
    required this.updateTime,
    required this.trackUpdateTime,
    required this.trackNumberUpdateTime,
    required this.status,
    required this.highQuality,
    required this.newImported,
    required this.tracks,
  });

  factory PlayList.fromJson(Map<String, dynamic> json) {
    return PlayList(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      coverImgUrl: json['coverImgUrl'] ?? "",
      adType: json['adType'] ?? 0,
      opRecommend: json['opRecommend'] ?? false,
      trackCount: json['trackCount'] ?? 0,
      specialType: json['specialType'] ?? 0,
      playCount: json['playCount'] ?? 0,
      subscribedCount: json['subscribedCount'] ?? 0,
      description: json['description'] ?? "",
      tags: json['tags'] ?? [],
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      creator: Creator.fromJson(json['creator'] ?? {}),
      createTime: json['createTime'] ?? 0,
      updateTime: json['updateTime'] ?? 0,
      trackUpdateTime: json['trackUpdateTime'] ?? 0,
      trackNumberUpdateTime: json['trackNumberUpdateTime'] ?? 0,
      status: json['status'] ?? 0,
      highQuality: json['highQuality'] ?? false,
      newImported: json['newImported'] ?? false,
      tracks: List<singleMusic>.from(json['tracks']?.map((x) => singleMusic.fromJson(x)) ?? []),
    );
  }
}