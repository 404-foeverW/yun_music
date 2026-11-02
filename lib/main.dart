import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/router/index.dart';
import 'package:yun_music/store/index.dart';
import 'package:yun_music/store/musicplay.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Get.putAsync<DeviceInfoService>(() async {
    final service = DeviceInfoService();
    await service.init();
    return service;
  }, permanent: true);
  await Get.putAsync<MusicPlayer>(() async {
    final service = MusicPlayer();
    await service.init();
    return service;
  }, permanent: true);
  runApp(getRouterWidgets());
}