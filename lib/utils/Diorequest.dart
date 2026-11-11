// ignore_for_file: avoid_print

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yun_music/constant/index.dart';
import 'package:yun_music/store/TokenMannager.dart';

String getBaseUrl() {
  if (kIsWeb) return GloablConstans.webBaseUrl;
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return GloablConstans.androidBaseUrl;
    default:
      return GloablConstans.iosBaseUrl;
  }
}

final cookieJar = CookieJar();

class Diorequest {
  Dio _dio = Dio();
  Diorequest() {
    _dio.options
      ..baseUrl = getBaseUrl()
      ..headers['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36 Edg/155.0.0.0'
      ..connectTimeout = GloablConstans.connetTimeout
      ..receiveTimeout = GloablConstans.receiveTimeout;
    _setInterceptorManagerCookie();
    _setInterceptor();
  }

  // 保存cookie
  void _setInterceptorManagerCookie() {
    _dio.interceptors.add(CookieManager(cookieJar));
  }

  void _setInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          String token = tokenMannager.getToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          // print('回复请求');
          // print(response);
          if (response.statusCode! >= 200 && response.statusCode! < 300) {
            handler.next(response);
            return;
          }
          // if(response.statusCode == 400) {
          //   handler.next(response);
          //   return;
          // }
          handler.reject(DioException(requestOptions: response.requestOptions));
        },
        onError: (error, handler) {
          print('错误请求');
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              message: error.response?.data is Map
                  ? (error.response!.data['message'] ?? '请求失败')
                  : (error.message ?? '网络异常'),
            ),
          );
        },
      ),
    );
  }

  get(String url, {Map<String, dynamic>? params}) {
    return _handleResponse(_dio.get(url, queryParameters: params));
  }

  post(String url, {Map<String, dynamic>? params}) {
    return _handleResponse(_dio.post(url, data: params));
  }

  _handleResponse(Future<Response<dynamic>> task) async {
    try {
      Response<dynamic> res = await task;
      // print('回复数据');
      // print(res);
      final data = res.data as Map<String, dynamic>;
      // print('修改数据1');
      // print(data);
      if (data['code'] == GloablConstans.successCode || data['status'] == GloablConstans.successCode) {
        // print('返回数据');
        // print(data['data'] ?? data['result'] ?? data);
        return data['data'] ?? data['result'] ?? data;
      }
      // if(data['code'] == '-462') {
      //   _handleVerifyResponse(data['data']);
      //   return;
      // }
      throw DioException(
        requestOptions: res.requestOptions,
        message: data['body']['message'] ?? '请求失败',
      );
    } catch (e) {
      rethrow;
    }
  }

  // _handleVerifyResponse(Map<String, dynamic> res) async {
  //   print('验证操作');
  //   Verify verify = Verify.fromJson(res);
  //   final success = await Navigator.push<bool>(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => VerifyWebViewPage(verifyinfo: verify),
  //     ),
  //   );
  //   if (success == true) {
  //     // 验证成功，继续后续操作，比如重新请求原接口
  //     print('验证成功');
  //   } else {
  //     print('用户取消或验证失败');
  //   }
  // }
}

final diorequest = Diorequest();
