// 协议
import 'package:flutter/material.dart';

class Notice extends StatefulWidget {
  final bool boolSure;
  final Function(bool?) onChanged;
  const Notice({super.key, required this.boolSure, required this.onChanged});

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            fillColor: WidgetStateProperty.resolveWith<Color>((
              Set<WidgetState> states,
            ) {
              if (!widget.boolSure) {
                return Colors.white;
              }
              return Colors.black;
            }),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: CircleBorder(),
            value: widget.boolSure,
            onChanged: widget.onChanged,
          ),
          RichText(
            text: TextSpan(
              text: '我已阅读并同意',
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: '《用户协议》',
                  style: TextStyle(color: Colors.blue),
                ),
                TextSpan(
                  text: '、',
                  style: TextStyle(color: Colors.blue),
                ),
                TextSpan(
                  text: '《隐私政策》',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}