import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webop extends StatefulWidget {
  String url;
  webop(this.url);
  @override
  State<webop> createState() => _webopState();
}

class _webopState extends State<webop> {
  late String finalurl;
  late WebViewController controller;
  @override
  void initState() {
    if (widget.url.toString().contains("http://")) {
      finalurl = widget.url.toString().replaceAll("http://", "https://");
    } else {
      finalurl = widget.url;
    }
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..loadRequest(Uri.parse(finalurl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
