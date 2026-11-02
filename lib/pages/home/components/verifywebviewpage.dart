import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yun_music/utils/Diorequest.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:yun_music/viewmodel/error.dart';

class VerifyWebViewPage extends StatefulWidget {
  final Verify verifyinfo; 
  const VerifyWebViewPage({super.key, required this.verifyinfo});

  @override
  State<VerifyWebViewPage> createState() => _VerifyWebViewPageState();
}

class _VerifyWebViewPageState extends State<VerifyWebViewPage> {
  InAppWebViewController? _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('安全验证'),),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(widget.verifyinfo.url),
          headers: widget.verifyinfo.verifyToken != null ? {'Authorization': 'Bearer ${widget.verifyinfo.verifyToken}'} : null,
        ),
        initialSettings: InAppWebViewSettings(
          userAgent: "NeteaseMusic/9.1.20 (Android 11; Mobile; zh_CN)", 
          javaScriptEnabled: true,
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
            handlerName: "net.nativeRequest",
            callback: (args) async {
              // args 是 H5 端传来的参数列表
              print("收到 net.nativeRequest 调用，参数: $args");
              
              try {
                // 解析并执行请求
                final response = await http.post(Uri.parse(args[0]['url']),
                  headers: args[0]['headers'],
                  body: args[0]['body'],);
                return {
                  "code": response.statusCode,
                  "message": "ok",
                  "data": response.body,
                };
              } catch (e) {
                return {
                  "code": 500,
                  "message": "Native request failed: $e",
                  "data": null,
                };
              }
            },
          );
        },
        shouldOverrideUrlLoading:(controller, navigationAction) async {
          final uri = navigationAction.request.url;
          if (uri == null) return NavigationActionPolicy.ALLOW; // 如果uri为空，则允许加载
          final url = uri.toString();

          print('url');
          print(url);

          // 拦截回调地址，判断验证是否成功
          if (url.startsWith(widget.verifyinfo.url) || url.contains('/verify/success')) {
            // 通知上一页验证成功
            Navigator.pop(context, true);
            return NavigationActionPolicy.CANCEL;
          }

          // 用户取消或失败
          if (url.contains('/verify/cancel')) {
            Navigator.pop(context, false);
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
        onLoadStop:(controller, url) {
          // 有些验证完成后不会跳转，只是页面内容变化
          // 可以在这里检查特定元素或 URL 参数
          if (url != null && url.toString().contains('verify/success')) {
            Navigator.pop(context, true);
          }
        },
      ),
    );
  }
}