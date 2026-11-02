import 'package:shared_preferences/shared_preferences.dart';
import 'package:yun_music/constant/index.dart';

class TokenMannager {
  Future<SharedPreferences> _getInstance() {
    return SharedPreferences.getInstance();
  }

  String _token = '';
  void init() async {
    final pref = await _getInstance();
    _token = pref.getString(GloablConstans.tokenKey) ?? '';
  }

  Future<void> setToken(String token) async {
    final pref = await _getInstance();
    await pref.setString(GloablConstans.tokenKey, token);
    _token = token;
  }

  String getToken() {
    return _token;
  }

  Future<void> clearToken() async {
    final pref = await _getInstance();
    await pref.remove(GloablConstans.tokenKey);
    _token = '';
  }
}

final tokenMannager = TokenMannager();