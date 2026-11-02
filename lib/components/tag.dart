import 'package:flutter/material.dart';
import 'package:yun_music/viewmodel/playlist.dart';

class TagInfo {
  int fee;
  int pop;
  fileInfo? sq;
  TagInfo({required this.fee, required this.pop, this.sq});
}

class Tag extends StatefulWidget {
  final TagInfo music;
  // 0 单个 1 多个
  final int type;
  const Tag({super.key, required this.music, required this.type});

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {

  Color defaultFullColor = Color.fromARGB(255, 243, 138, 130);
  Color defaultTextColor = Color.fromARGB(255, 212, 18, 18);
  Color defaultBorderColor = Color.fromARGB(255, 245, 109, 100);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.type == 0 ? _getSingleContent() : _getListContent()
    );
  }

  Widget _getListContent() {
    return Row(
      children: [
        if(widget.music.fee == 8) _tag_space('VIP', defaultFullColor),
        if(widget.music.pop == 100) _tag_fill('正在热播中', defaultFullColor, defaultTextColor),
        if(widget.music.pop > 70) _tag_fill('超${widget.music.pop}%人播放', defaultFullColor, defaultTextColor),
        if(widget.music.sq?.br != 0) _tag_space('SQ', defaultFullColor),
      ],
    );
  }

  Widget _getSingleContent() {
    if(widget.music.fee == 8) {
      return _tag_space('VIP', defaultFullColor);
    }
    if(widget.music.pop == 100) {
      return _tag_fill('正在热播中', defaultFullColor, defaultTextColor);
    }
    if(widget.music.pop > 70) {
      return _tag_fill('超${widget.music.pop}%人播放', defaultFullColor, defaultTextColor);
    }
    if(widget.music.sq?.br != 0) {
      return _tag_space('SQ', defaultFullColor);
    }
    return Container();
  }

  Widget _tag_fill(String text, Color fillcolor, Color textcolor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: fillcolor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textcolor,
          fontSize: 10,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _tag_space(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
        ),
      ),
    );
  }
}