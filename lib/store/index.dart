import 'dart:ui';

import 'package:get/state_manager.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class CommonData extends GetxController {
  // 最新歌曲表单
  List<RecommendMusicNL> recommendMusicNL = [];

  void setRecommendMusicNL(List<RecommendMusicNL> data) {
    recommendMusicNL = data;
  }

  List<RecommendMusicNL> getRecommendMusicNL() {
    return recommendMusicNL;
  }

  // 当前tabbar页面
  int currentTabbarIndex = 0;

  void setCurrentTabbarIndex(int index) {
    currentTabbarIndex = index;
  }

  int getCurrentTabbarIndex() {
    return currentTabbarIndex;
  }
}

class DeviceInfoService extends GetxService {
  late final double width; // 屏幕宽度
  late final double height; // 屏幕高度
  late final double statusBarHeight; // 状态栏高度
  late final double bottomSafeAreaHeight; // 获取底部安全区高度
  late final double keyboardHeight; // 获取键盘高度
  late final double devicePixelRatio; // 获取设备像素比

  Future<DeviceInfoService> init() async {
    _readSystemInfo();
    return this;
  }

  void _readSystemInfo() {
    final view = PlatformDispatcher.instance.views.first;
    final dpr = view.devicePixelRatio;
    devicePixelRatio = dpr;

    width = view.physicalSize.width / dpr;
    height = view.physicalSize.height / dpr;
    statusBarHeight = view.padding.top / dpr;
    bottomSafeAreaHeight = view.padding.bottom / dpr;
    keyboardHeight = view.viewInsets.bottom / dpr;
  }
}