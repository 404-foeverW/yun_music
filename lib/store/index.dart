// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class LocalData {
  Future<SharedPreferences> _getInstance() {
    return SharedPreferences.getInstance();
  }

  // 搜索历史
  List<String> searchHistory = [];
  // 设置搜索历史
  Future<void> setSearchHistory({String? value, List<String>? list}) async {
    print(value);
    final pref = await _getInstance();
    if(list != null) {
      searchHistory = list;
    }
    if(searchHistory.contains(value) && value != null) {
      searchHistory.remove(value);
      searchHistory.insert(0, value);
    }else if(value != null) {
      searchHistory.add(value);
    }
    print(searchHistory);
    pref.setStringList('searchHistory', searchHistory);
  }
  // 获取搜索历史
  Future<List<String>> getSearchHistory() async {
    final pref = await _getInstance();
    List<String>? result = pref.getStringList('searchHistory');
    if(result == null) {
      pref.setStringList('searchHistory', []);
      return [];
    }
    return result;
  }
  // 清除搜索历史
  Future<void> clearSearchHistory() async {
    final pref = await _getInstance();
    searchHistory = [];
    pref.setStringList('searchHistory', []);
  }
  // 删除搜索历史
  Future<void> removeSearchHistory(String value) async {
    print(searchHistory);
    if(searchHistory.contains(value)) {
      searchHistory.remove(value);
    }
    print(searchHistory);
    final pref = await _getInstance();
    pref.setStringList('searchHistory', searchHistory);
  }
}