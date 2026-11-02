// 提交按钮
import 'package:flutter/material.dart';

class SumbitButton extends StatefulWidget {
  final Function()? toLogin;
  const SumbitButton({super.key, required this.toLogin});

  @override
  State<SumbitButton> createState() => _SumbitButtonState();
}

class _SumbitButtonState extends State<SumbitButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.toLogin,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: const Color.fromARGB(255, 233, 35, 20),
        foregroundColor: Colors.red,
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
      ),
      child: Text('一键登录', style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}