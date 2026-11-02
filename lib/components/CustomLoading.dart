import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yun_music/store/index.dart';

class CustomLoading extends StatefulWidget {
  final Widget? loadingIcon; // 加载图标
  final List<double> sizes; // 加载图标大小
  final Color? color; // 加载图标颜色
  final double? duration; // 加载图标动画时长
  final Color? backgroundColor;

  const CustomLoading({super.key, this.loadingIcon, this.sizes = const [20, 20], this.color, this.duration, this.backgroundColor});

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading> {

  final deviceinfo = Get.find<DeviceInfoService>();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceinfo.width,
      height: deviceinfo.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
      ),
      child: Align(
        alignment: Alignment.center,
        child: widget.loadingIcon ?? const CircularProgressIndicator(color: Colors.red)
      )
    );
  }
}