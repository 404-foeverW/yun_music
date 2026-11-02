import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yun_music/viewmodel/index.dart';

// 获取设备信息
DeviceInfo getDeviceInfo(BuildContext context) {
  // 获取屏幕宽度
  double width = MediaQuery.of(context).size.width;
  // 获取屏幕高度
  double height = MediaQuery.of(context).size.height;
  // 获取状态栏高度
  double statusBarHeight = MediaQuery.of(context).padding.top;
  // 获取底部安全区高度
  double bottomSafeAreaHeight = MediaQuery.of(context).padding.bottom;
  // 获取键盘高度
  double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

  return DeviceInfo.fromJson({
    'width': width,
    'height': height,
    'statusBarHeight': statusBarHeight,
    'bottomSafeAreaHeight': bottomSafeAreaHeight,
    'keyboardHeight': keyboardHeight
  });
}

// 获取省略文本
String getEllipsisText(String text, int startIndex, int endIndex) {
  if(startIndex < 0 || endIndex < 0) {
    return text;
  }
  if (text.length <= endIndex) {
    endIndex = text.length;
  }
  if (startIndex > endIndex) {
    startIndex = endIndex;
  }
  int ellipsisnum = max(endIndex - startIndex, 4);
  String targetText = text.substring(startIndex, endIndex);
  RegExp regExp = RegExp(targetText);
  String result = text.replaceAll(regExp, '*' * ellipsisnum);
  return result;
}

class Toastutil {
  // 显示提示
  static Duration duration = Duration(milliseconds: 1000);
  static bool showLoading = false;
  static void showToast(BuildContext context, String? msg) {
    if(Toastutil.showLoading) {
      return;
    }
    Toastutil.showLoading = true;
    Future.delayed(duration, () {
      Toastutil.showLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 120,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        // 设置显示形式：悬浮状态
        behavior: SnackBarBehavior.floating,
        content: Text(msg ?? '', textAlign: TextAlign.center,),
        duration: duration,
      )
    );
  }
}

// 计算播放量
String getPlayCount(int playCount) {
  if(playCount < 10000000) {
    return '$playCount';
  } else if(playCount < 100000000) {
    return '${(playCount / 10000).toStringAsFixed(0)}万';
  } else {
    return '${(playCount / 100000000).toStringAsFixed(0)}亿';
  }
}
// 获取年月日或时间
String getDateTime(int time, {bool isTime = false}) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(time);
  if(isTime) {
    return '${dateTime.hour}:${dateTime.minute}';
  } else {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}

// 将hex颜色值转换为Color对象
Color hexToColor(String hex) {
  hex = hex.replaceFirst('#', '');
  if (hex.length == 6) hex = 'FF$hex';   // 6 位补全透明度
  return Color(int.parse(hex, radix: 16));
}

// 根据基础色生成相近但可清晰区分的颜色
// [index] 用于生成多个不同变体（1、2、3...）
Color generateSimilarColor(Color base, {int index = 1}) {
  final hsl = HSLColor.fromColor(base);

  // 亮度调整：暗色调亮、亮色调暗、中间色往暗调
  double newLightness;
  if (hsl.lightness < 0.45) {
    newLightness = (hsl.lightness + 0.3 * index).clamp(0.15, 0.85);
  } else if (hsl.lightness > 0.65) {
    newLightness = (hsl.lightness - 0.25 * index).clamp(0.15, 0.85);
  } else {
    newLightness = (hsl.lightness - 0.25 * index).clamp(0.15, 0.85);
  }

  // 色相轻微偏移（保持同色系）
  final newHue = (hsl.hue + 15.0 * index) % 360;

  // 饱和度略降，避免过于刺眼
  final newSat = (hsl.saturation * 0.85).clamp(0.1, 0.95);

  return hsl
      .withHue(newHue)
      .withLightness(newLightness)
      .withSaturation(newSat)
      .toColor();
}

// 颜色加深
Color darken(Color base, double amount) {
  final hsl = HSLColor.fromColor(base);
  return hsl
      .withLightness((hsl.lightness - amount).clamp(0.05, 1.0))
      .toColor();
}