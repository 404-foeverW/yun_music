import 'package:flutter/material.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class DeviceInfo {
  double width;
  double height;
  double statusBarHeight;
  double bottomSafeAreaHeight;
  double keyboardHeight;
  DeviceInfo(
    this.width,
    this.height,
    this.statusBarHeight,
    this.bottomSafeAreaHeight,
    this.keyboardHeight,
  );

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      json['width'] ?? 0,
      json['height'] ?? 0,
      json['statusBarHeight'] ?? 0,
      json['bottomSafeAreaHeight'] ?? 0,
      json['keyboardHeight'] ?? 0,
    );
  }
}

// 歌单通用组件配置项
class PlayMusicListConfig {
  // 页面标题
  String title;
  // 页面头部组件
  SliverPersistentHeaderDelegate headerPart;
  // Widget headerPart;
  // 页面主体组件
  Widget? bodyPart;
  // 头部控制器组件
  SliverPersistentHeaderDelegate headerControllerPart;
  // Widget headerControllerPart;
  // 提示组件
  Widget? tipPart;
  // 页面歌曲列表
  List<singleMusic> musicList;
  // 背景是否透明 true:透明 false:不透明
  bool? isTransparent;
  // 背景渐变色
  List<Color>? bgGradient;
  // 背景图片
  String? bgImg;
  // 播放器样式
  PlayerStyle? playerStyle;
  // 播放器样式类型 0:默认 1:白色
  int? playerType;
  // 歌曲列表样式
  MusicListStyle? musicListStyle;
  // 加载时背景色
  Color? loadingColor;
  // 是否显示歌曲图片
  bool? showMusicImg;
  // 控制是否显示图片函数
 void Function(bool show)? showImgFunc;
  // 是否显示排序
  bool? showRank;
  // 是否显示排行升降
  bool? showRankChange;

  PlayMusicListConfig({
    required this.title,
    required this.headerPart,
    this.bodyPart,
    required this.headerControllerPart,
    required this.musicList,
    this.tipPart,
    this.isTransparent,
    this.bgImg,
    this.playerStyle,
    this.playerType,
    this.bgGradient,
    this.musicListStyle,
    this.loadingColor = Colors.grey,
    this.showMusicImg = true,
    this.showRank = false,
    this.showRankChange = false,
    this.showImgFunc
  });
}

class MusicListStyle {
  // 歌曲名颜色
  Color musicNameColor;
  // 歌手颜色
  Color artistColor;
  // 排名上升颜色
  Color? upColor;
  // 排名下降颜色
  Color? downColor;
  // 排名不变颜色
  Color? equalColor;
  // 前三名颜色
  Color? topColor;
  // 后三名颜色
  Color? bottomColor;
  // 新歌颜色
  Color? newColor;
  double? topSize;
  double? bottomSize;
  FontWeight? topWeight;
  // 水波纹颜色
  Color? splashColor;
  Color? highlightColor;
  // 是否显示排行样式
  bool? showRankStyle;

  MusicListStyle({
    this.musicNameColor = Colors.black,
    this.artistColor = Colors.grey,
    this.upColor = Colors.red,
    this.downColor = const Color.fromRGBO(100, 149, 237, 1),
    this.equalColor = Colors.grey,
    this.topColor = Colors.red,
    this.bottomColor = Colors.grey,
    this.newColor = Colors.green,
    this.topSize = 25,
    this.bottomSize = 18,
    this.topWeight = FontWeight.bold,
    this.splashColor = const Color.fromRGBO(0, 0, 0, .3),
    this.highlightColor = const Color.fromRGBO(0, 0, 0, .1),
    this.showRankStyle = false,
  });
}

// 播放器样式颜色
class PlayerStyle {
  // 音乐名称颜色
  Color musicNameColor;
  // 歌手颜色
  Color artistColor;
  // 播放/暂停图标颜色
  Color iconColor;
  // 背景颜色
  Color bgColor;
  // 阴影颜色
  Color shadowColor;
  // 播放进度条颜色
  Color progressColor;
  // 播放进度条背景颜色
  Color progressBgColor;
  // 播放列表图标颜色
  String listIconColor;

  PlayerStyle({
    this.musicNameColor = Colors.black,
    this.artistColor = Colors.grey,
    this.iconColor = Colors.black,
    this.bgColor = Colors.white,
    this.shadowColor = const Color.fromARGB(255, 235, 230, 230),
    this.progressColor = Colors.black,
    this.progressBgColor = Colors.grey,
    this.listIconColor = 'black',
  });

  static PlayerStyle get getDefault => PlayerStyle(
      musicNameColor: Colors.black,
      artistColor: Colors.grey,
      iconColor: Colors.black,
      bgColor: Colors.white,
      shadowColor: Color.fromARGB(255, 235, 230, 230),
      progressColor: Colors.black,
      progressBgColor: Colors.grey.shade300,
      listIconColor: 'black'
    );
}

// 用户个人信息
class UserInfo {
  int authStatus; // 用户认证状态
  bool followed; // 是否关注
  int accountStatus; // 账号状态
  int userType; // 用户类型
  String? nickname;
  String? avatarUrl;
  int? userId;
  String? signature;
  int? gender;
  int? birthday;
  int? city;
  int? province;
  String? country;
  String? description;
  String? detailDescription;
  String? avatarImgIdStr;
  String? backgroundUrl;
  String? backgroundImgIdStr;
  bool? defaultAvatar;
  int? authority;
  bool? mutual;
  int? djStatus;
  int? vipType;
  int? avatarImgId;
  int? backgroundImgId;
  String? avatarImgId_str;
  String? backgroundImgId_str;
  bool anchor;

  UserInfo({
    required this.authStatus,
    required this.followed,
    required this.accountStatus,
    required this.userType,
    this.nickname,
    this.avatarUrl,
    this.userId,
    this.signature,
    this.gender,
    this.birthday,
    this.city,
    this.province,
    this.country,
    this.description,
    this.detailDescription,
    this.avatarImgIdStr,
    this.backgroundUrl,
    this.backgroundImgIdStr,
    this.defaultAvatar,
    this.authority,
    this.mutual,
    this.djStatus,
    this.vipType,
    this.avatarImgId,
    this.backgroundImgId,
    this.avatarImgId_str,
    this.backgroundImgId_str,
    required this.anchor,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      authStatus: json['authStatus'] ?? 0,
      followed: json['followed'] ?? false,
      accountStatus: json['accountStatus'] ?? 0,
      userType: json['userType'] ?? 0,
      nickname: json['nickname'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      userId: json['userId'] ?? 0,
      signature: json['signature'] ?? '',
      gender: json['gender'] ?? 0,
      birthday: json['birthday'] ?? 0,
      city: json['city'] ?? 0,
      province: json['province'] ?? 0,
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      detailDescription: json['detailDescription'] ?? '',
      avatarImgIdStr: json['avatarImgIdStr'] ?? '',
      backgroundUrl: json['backgroundUrl'] ?? '',
      backgroundImgIdStr: json['backgroundImgIdStr'] ?? '',
      defaultAvatar: json['defaultAvatar'] ?? false,
      authority: json['authority'] ?? 0,
      mutual: json['mutual'] ?? false,
      djStatus: json['djStatus'] ?? 0,
      vipType: json['vipType'] ?? 0,
      avatarImgId: json['avatarImgId'] ?? 0,
      backgroundImgId: json['backgroundImgId'] ?? 0,
      avatarImgId_str: json['avatarImgId_str'] ?? '',
      backgroundImgId_str: json['backgroundImgId_str'] ?? '',
      anchor: json['anchor'] ?? false,
    );
  }
}