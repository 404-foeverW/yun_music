// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yun_music/api/login.dart';
import 'package:yun_music/pages/home/components/verifywebviewpage.dart';
import 'package:yun_music/utils/index.dart';
import 'package:yun_music/viewmodel/error.dart';
import 'package:yun_music/viewmodel/index.dart';

// 验证码输入
class FormCode extends StatefulWidget {
  final Function setVisible;
  final TextEditingController controller;
  final TextEditingController phoneController;
  // final Function(Function callback)? getCode;
  // final bool issend;

  const FormCode({
    super.key,
    required this.setVisible,
    required this.controller,
    required this.phoneController,
  });

  @override
  State<FormCode> createState() => _FormCodeState();
}

class _FormCodeState extends State<FormCode> {
  // TextEditingController codeController = TextEditingController();
  Timer? _timer;
  int _seconds = 0;
  void _startCountdown() {
    _seconds = 60;
    setState(() {});
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        _seconds--;
        setState(() {});
      } else {
        _timer?.cancel();
        _issend = false;
        setState(() {});
      }
    });
  }

  bool _issend = false;
  _getCode() async {
    try {
      print(widget.controller.text);
      if (widget.phoneController.text.isEmpty) {
        Toastutil.showToast(context, '请输入手机号');
        return;
      }
      print('发送验证码');
      bool res = await getLoginCode({"phone": widget.phoneController.text});
      print('获得数据');
      print(res);
      _issend = res;
      // _issend = true;
      setState(() {});
      if (_issend) {
        _startCountdown();
      }
    } catch (e) {
      // print((e as DioException).response);
      final dynamic res = (e as DioException).response?.data;
      // print(res['code']);
      handleVerifyResponse(res['data']);
      Toastutil.showToast(context, (e as DioException).message);
    }
  }

  Future<void> handleVerifyResponse(Map<String, dynamic> res) async {
    print('验证操作');
    Verify verify = Verify.fromJson(res);
    final success = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyWebViewPage(verifyinfo: verify),
      ),
    );
    if (success == true) {
      // 验证成功，继续后续操作，比如重新请求原接口
      print('验证成功');
    } else {
      print('用户取消或验证失败');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // void getCode() {
  //   if(widget.issend) {

  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IntrinsicHeight(
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 216, 204, 204),
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        '验证码',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 148, 146, 146),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Color.fromARGB(255, 148, 146, 146),
                      thickness: 1,
                      width: 10,
                      indent: 16, // 顶部缩进
                      endIndent: 16, // 底部缩进
                    ),
                    Expanded(
                      child: Focus(
                        onFocusChange: (value) {
                          if (value) {
                            widget.setVisible(true);
                            print('code 获得焦点，键盘即将弹出');
                          } else {
                            widget.setVisible(false);
                            print('code 失去焦点，键盘即将收起');
                          }
                        },
                        child: TextFormField(
                          controller: widget.controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请填写验证码';
                            }
                            if (value.length != 4) {
                              return '请输入正确的验证码';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: '请输入验证码',
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 57, 56, 56),
                              fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: _issend ? null : _getCode,
                // onPressed: _getCode,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(0, 50),
                  backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                  foregroundColor: const Color.fromARGB(255, 245, 245, 245),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                ),
                child: Text(
                  _issend ? '${_seconds}秒后重试' : '获取验证码',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
