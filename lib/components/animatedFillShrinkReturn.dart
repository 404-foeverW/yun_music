import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedFirstItem extends StatefulWidget {
  final Widget child;
  final GlobalKey parentKey;   // 父级 ClipRRect 的 GlobalKey
  final Duration duration;
  final bool autoStart;

  const AnimatedFirstItem({
    super.key,
    required this.child,
    required this.parentKey,
    this.duration = const Duration(milliseconds: 1600),
    this.autoStart = true,
  });

  @override
  State<AnimatedFirstItem> createState() => _AnimatedFirstItemState();
}

class _AnimatedFirstItemState extends State<AnimatedFirstItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final GlobalKey _selfKey = GlobalKey();

  Rect? _selfRectInParent;     // 自身在父级坐标系中的矩形
  Size? _parentSize;
  Matrix4? _parentToLocal;     // 父级坐标 → 自身局部坐标的逆矩阵

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
      if (widget.autoStart) _controller.forward();
    });
  }

  /// 测量第一个图片在父级（ClipRRect）坐标系中的真实矩形
  /// 自动包含内部 Transform.rotate / Transform.translate 的影响
  void _measure() {
    final selfContext = _selfKey.currentContext;
    final parentContext = widget.parentKey.currentContext;
    if (selfContext == null || parentContext == null) return;

    final selfBox = selfContext.findRenderObject() as RenderBox?;
    final parentBox = parentContext.findRenderObject() as RenderBox?;
    if (selfBox == null || parentBox == null) return;

    final matrix = selfBox.getTransformTo(parentBox);
    _selfRectInParent = MatrixUtils.transformRect(
      matrix,
      Offset.zero & selfBox.size,
    );
    _parentSize = parentBox.size;
    _parentToLocal = Matrix4.inverted(matrix);
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final rect = _selfRectInParent;
        final parentSize = _parentSize;
        final invMatrix = _parentToLocal;

        if (rect == null ||
            parentSize == null ||
            invMatrix == null ||
            rect.isEmpty) {
          return child!;
        }

        final t = _controller.value;
        final fillScale = math.max(
          parentSize.width / rect.width,
          parentSize.height / rect.height,
        );
        final parentCenter = parentSize.center(Offset.zero);
        final selfCenter = rect.center;

        double scale;
        double moveProgress;

        if (t < 0.3) {
          // 阶段 1：放大 + 移动到父级中心
          final p = Curves.easeOutCubic.transform(t / 0.3);
          scale = 1 + (fillScale - 1) * p;
          moveProgress = p;
        } else if (t < 0.6) {
          // 阶段 2：占满状态下视觉缩小 15%
          final p = Curves.easeInOut.transform((t - 0.3) / 0.3);
          scale = fillScale * (1 - 0.15 * p);
          moveProgress = 1.0;
        } else {
          // 阶段 3：归位
          final p = Curves.easeInOutCubic.transform((t - 0.6) / 0.4);
          final startScale = fillScale * 0.85;
          scale = startScale + (1 - startScale) * p;
          moveProgress = 1.0 - p;
        }

        // 父级坐标系中的位移 → 转换到图片自身局部坐标系
        final parentOffset = (parentCenter - selfCenter) * moveProgress;
        final localOffset = MatrixUtils.transformPoint(invMatrix, parentOffset);

        return Transform.translate(
          offset: localOffset,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: child!,
          ),
        );
      },
      child: KeyedSubtree(key: _selfKey, child: widget.child),
    );
  }
}