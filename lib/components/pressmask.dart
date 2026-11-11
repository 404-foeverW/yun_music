import 'package:flutter/material.dart';

class PressMask extends StatefulWidget {
  final Widget child;
  final Color maskColor; // 遮罩颜色
  final double maskOpacity; // 遮罩强度
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PressMask({
    super.key,
    required this.child,
    this.maskColor = Colors.white,
    this.maskOpacity = 0.4,
    this.borderRadius,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<PressMask> createState() => _PressMaskState();
}

class _PressMaskState extends State<PressMask> {
  bool _pressed = false;

  void _update(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _update(true),
      onTapUp: (_) => _update(false),
      onTapCancel: () => _update(false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedOpacity(
        opacity: _pressed ? 0.5 : 1,
        duration: const Duration(milliseconds: 100),
        child: ClipRRect(child: widget.child),
      ),
    );
  }
}
