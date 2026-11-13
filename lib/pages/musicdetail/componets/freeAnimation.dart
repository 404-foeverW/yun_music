import 'package:flutter/material.dart';

class FreeAnimation extends StatefulWidget {
  const FreeAnimation({super.key});

  @override
  State<FreeAnimation> createState() => _FreeAnimationState();
}

class _FreeAnimationState extends State<FreeAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  static const double _squareSize = 25.0; // 初始正方形边长
  static const double _expandedWidth = 75.0; // 最终长方形宽度

  static const Color defaultColor = Colors.white; // 初始颜色
  static const Color targetColor = Color.fromRGBO(211, 211, 211, 1); // 最终颜色

  Color _color = defaultColor; // 初始颜色
  bool _show = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    Future.delayed(const Duration(seconds: 2), () async {
      await _controller.forward();
      if (!mounted) return;
      setState(() {
        _color = targetColor;
        _show = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final width =
              _squareSize + _animation.value * (_expandedWidth - _squareSize);
          return SizedBox(
            width: width,
            height: _squareSize,
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: width,
                    height: _squareSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: _color, width: 1),
                    ),
                  ),
                ),
                if (!_show)
                  Positioned(
                    right: width - _squareSize,
                    top: 0,
                    child: Container(
                      width: _squareSize,
                      // width: width,
                      height: _squareSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border(
                          right: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '免',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: defaultColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_show)
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: _squareSize,
                        child: const Center(
                          child: Text(
                            '免',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: defaultColor,
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: targetColor,
                        width: 1,
                        thickness: 1,
                        indent: 6,
                        endIndent: 6,
                      ),
                      Expanded(
                        child: Text(
                          '续时长',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: targetColor),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
