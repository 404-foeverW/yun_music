import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yun_music/api/login.dart';
import 'package:yun_music/pages/login/components/FormCode.dart';
import 'package:yun_music/pages/login/components/FormPhone.dart';
import 'package:yun_music/pages/login/components/Notice.dart';
import 'package:yun_music/pages/login/components/SumbitButton.dart';
import 'package:yun_music/utils/index.dart';
import 'package:yun_music/viewmodel/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _visible = true;
  void setVisible() {
    setState(() {
      _visible = !(_codeFocus || _phoneFocus);
    });
  }

  bool _codeFocus = false;
  void setCodeFocus(bool value) {
    _codeFocus = value;
    setVisible();
  }

  bool _phoneFocus = false;
  void setPhoneFocus(bool value) {
    _phoneFocus = value;
    setVisible();
  }

  @override
  Widget build(BuildContext context) {
    SvgPicture logo = SvgPicture.asset(
      'lib/assets/icon/icon_wyy.svg',
      width: 100,
      height: 100,
    );
    final DeviceInfo deviceInfo = getDeviceInfo(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 228, 225, 1),
              Color.fromRGBO(248, 248, 255, 1),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: deviceInfo.height * 0.3,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: logo,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FormComponent(
                  setCodeFocus: setCodeFocus,
                  setPhoneFocus: setPhoneFocus,
                ),
                SizedBox(height: 100),
                Container(
                  margin: EdgeInsets.only(
                    bottom: deviceInfo.bottomSafeAreaHeight,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          '登录遇到问题',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text('|', style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          '以其他账号登录',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 登录列表
class LoginListItem extends StatefulWidget {
  const LoginListItem({super.key});

  @override
  State<LoginListItem> createState() => _LoginListItemState();
}

class _LoginListItemState extends State<LoginListItem> {
  @override
  Widget build(BuildContext context) {
    final SvgPicture logUser = SvgPicture.asset(
      'lib/assets/icon/user-round.svg',
      width: 30,
      height: 30,
    );

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: const Color.fromARGB(255, 193, 191, 191),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          // ClipOval(child: logUser),
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color.fromARGB(255, 156, 154, 154),
            child: logUser,
          ),
          Expanded(
            child: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '背景牌',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  getEllipsisText('19973314343', 3, 7),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(5),
            ),
            child: Text(
              '登录',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// 提交表单
class FormComponent extends StatefulWidget {
  final Function setCodeFocus;
  final Function setPhoneFocus;

  const FormComponent({
    super.key,
    required this.setCodeFocus,
    required this.setPhoneFocus,
  });

  @override
  State<FormComponent> createState() => _FormComponentState();
}

class _FormComponentState extends State<FormComponent> {
  bool boolSure = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // void sumbitPhone() {
  //   bool isVaildete = _formKey.currentState!.validate();
  //   if (!isVaildete) return;
  //   if (!boolSure) {
  //     Toastutil.showToast(context, '请同意协议');
  //     return;
  //   }
  // }

  void onChanged(value) {
    setState(() {
      boolSure = value ?? false;
    });
  }

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  // bool _issend = false;
  // void _getCode(Function callback) async {
  //   print('发送验证码');
  //   if(_phoneController.text.isEmpty) {
  //     Toastutil.showToast(context, '请输入手机号');
  //     return;
  //   }
  //   print('发送验证码');
  //   bool res = await getLoginCode();
  //   _issend = res;
  //   setState(() {});
  //   if (_issend) {
  //     callback();
  //   }
  // }

  void _toLogin() async {
    try {
      bool isVaildete = _formKey.currentState!.validate();
      if (!isVaildete) return;
      if (!boolSure) {
        Toastutil.showToast(context, '请同意协议');
        return;
      }
      bool res = await getLoginByCode({
        'phone': _phoneController.text,
        'captcha': _codeController.text,
      });
      if(res) {}
    } catch (e) {
      Toastutil.showToast(context, (e as DioException).message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        children: [
          FormPhone(
            setVisible: widget.setPhoneFocus,
            controller: _phoneController,
          ),
          FormCode(
            setVisible: widget.setCodeFocus,
            controller: _codeController,
            phoneController: _phoneController,
          ),
          SumbitButton(toLogin: _toLogin),
          SizedBox(height: 5),
          Notice(boolSure: boolSure, onChanged: onChanged),
        ],
      ),
    );
  }
}
