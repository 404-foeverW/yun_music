import 'package:yun_music/constant/index.dart';
import 'package:yun_music/utils/Diorequest.dart';

// 获取验证码
Future<bool> getLoginCode(Map<String, dynamic> params) async {
  bool res = await diorequest.get(LoginApiUrl.getCode, params: params);
  return res;
}

// 验证码登录
Future<bool> getLoginByCode(Map<String, dynamic> params) async {
  bool res = await diorequest.get(LoginApiUrl.codeLogin, params: params);
  return res;
}

// 游客登陆
