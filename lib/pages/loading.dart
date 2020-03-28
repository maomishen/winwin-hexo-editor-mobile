import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/services.dart';

import 'user/login.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with AfterLayoutMixin<LoadingPage> {
  @override
  void afterFirstLayout(BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return WillPopScope(
        child: LoginPage(),
        onWillPop: () async {
          print('background by back button');
          return await AndroidBackTop.backDeskTop();
        },
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AndroidBackTop {
  //初始化通信管道-设置退出到手机桌面
  static const String CHANNEL = "android_back_desktop";
  //设置回退到手机桌面
  static Future<bool> backDeskTop() async {
    final platform = MethodChannel(CHANNEL);
    //通知安卓返回,到手机桌面
    try {
      final bool out = await platform.invokeMethod('backDesktop');
      if (out) debugPrint('返回到桌面');
    } on PlatformException catch (e) {
      debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
      print(e.toString());
    }
    return Future.value(false);
  }
}
