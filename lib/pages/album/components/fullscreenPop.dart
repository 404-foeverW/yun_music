import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/store/index.dart';

Future<void> showFullScreenPop(
  BuildContext context, {
  String name = '',
  String content = '',
  String company = '',
  String subType = '',
  String picUlr = '',
}) async {
  final deviceInfo = Get.find<DeviceInfoService>();
  await showDialog<void>(
    useSafeArea: false,
    context: context,
    builder: (context) => Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: Container(
        // padding: EdgeInsets.only(top: deviceInfo.statusBarHeight, bottom: deviceInfo.bottomSafeAreaHeight),
        child: Stack(
          children: [
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Image.network(
                  'https://images.weserv.nl/?url=$picUlr',
                  fit: BoxFit.cover,
                  // 加载中/失败时显示深色占位
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(color: Colors.black);
                  },
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey.withValues(alpha: 0.6), // 顶部深
                      Colors.grey.withValues(alpha: 0.3), // 中间浅
                      Colors.grey.withValues(alpha: 0.85), // 底部更深（衬托控件）
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: deviceInfo.statusBarHeight,
                  bottom: deviceInfo.bottomSafeAreaHeight + 60,
                ),
                child: ListView(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://images.weserv.nl/?url=$picUlr',
                        width: 150,
                        height: 150,
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: [0.1, 0.3, 0.5, 0.7, 1],
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.2),
                            Colors.white,
                            Colors.white.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '发行公司: $company',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '专辑类别: $subType',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 15),
                    Text(
                      content != '' ? content : '暂无专辑简介',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: deviceInfo.bottomSafeAreaHeight+40),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: deviceInfo.statusBarHeight,
              child: IconButton(
                icon: Icon(CupertinoIcons.multiply),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
             Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(bottom: deviceInfo.bottomSafeAreaHeight),
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.5)),
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 2)),
                      backgroundColor: WidgetStateProperty.all(Colors.transparent),
                      side: WidgetStateProperty.all(BorderSide(color: Colors.white)),
                    ),
                    child: Text('保存封面', style: TextStyle(color: Colors.white, fontSize: 12)),
                  )
                )
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
