// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class LoopText extends StatefulWidget {
  final String text;
  final TextStyle? textstyle;
  final double speed;
  final double gap;
  final double? height;
  final Duration pauseDurantion;
  final double width;
  const LoopText({
    super.key,
    required this.text,
    required this.width,
    this.textstyle,
    this.speed = 30,
    this.gap = 30,
    this.height,
    this.pauseDurantion = const Duration(seconds: 1),
  });

  @override
  State<LoopText> createState() => _LoopTextState();
}

class _LoopTextState extends State<LoopText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _textWidth = 0;
  double _textHeight = 0;
  bool _ready = false;
  bool _disposed = false;
  bool _loopStarted = false;
  bool _needScroll = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() async {
    final tp = TextPainter(
      text: TextSpan(text: widget.text, style: widget.textstyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    _textWidth = tp.width;
    _textHeight = tp.height + 2;
    final distance = _textWidth + widget.gap;
    // print('_textWidth: $_textWidth, distance: $distance');
    _controller.duration = Duration(
      milliseconds: (distance / widget.speed * 1000).round(),
    );
    setState(() {});
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      _ready = true;
    });
  }

  Future<void> _startLoop() async {
    print('start loop');
    // await Future.delayed(Duration(milliseconds: 1000));
    while (!_disposed && mounted) {
      try {
        await _controller.forward(from: 0);
      } on TickerCanceled {
        return;
      }
      if (!mounted || _disposed) return;
      await Future.delayed(widget.pauseDurantion);
      if (!mounted || _disposed) return;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      // return Container(height: widget.height ?? _textHeight, child: _textItem());
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.width),
        child: SizedBox(
          height: widget.height ?? _textHeight,
          child: _textItem(),
        ),
      );
    }
    return Container(
      height: widget.height ?? _textHeight,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final needScroll = constraints.maxWidth < _textWidth;
            _needScroll = needScroll;
            if (!_needScroll) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.width),
                // child: Align(alignment: Alignment.centerLeft, child: _textItem())
                child: _textItem(),
              );
            }
            if (!_loopStarted) {
              _loopStarted = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_disposed) {
                  _startLoop();
                }
              });
            }
            return ClipRect(
              child: OverflowBox(
                maxWidth: double.infinity,
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final offsetX =
                        -_controller.value * (_textWidth + widget.gap);
                    return Transform.translate(
                      offset: Offset(offsetX, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _textItem(),
                          SizedBox(width: widget.gap),
                          _textItem(),
                          SizedBox(width: widget.gap),
                          _textItem(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _textItem() => Text(
    widget.text,
    style: widget.textstyle,
    maxLines: 1,
    overflow: !_ready ? TextOverflow.ellipsis : TextOverflow.visible,
    softWrap: false,
  );
}
