import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:system_windows/system_windows.dart';

void main() {
  // 主入口，运行app
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 定义
  var systemWindows = SystemWindows();

  // 创建判断是否展示
  var windowsToShow = List<Window>.empty();
  var ticks = 0;

  var hasScreenRecordingPermissions = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      // 获取所有 active 的应用
      final activeApps = await systemWindows.getActiveApps();

      if (Platform.isMacOS) {
        // 判断是否有录制屏幕的权限，没有权限会申请权限
        hasScreenRecordingPermissions = await systemWindows.hasScreenRecordingPermission();
      } else {
        hasScreenRecordingPermissions = true;
      }
      // 所有窗口列表
      final wl = activeApps.map((w) => Window(w.name, w.title, w.isActive, 0, 0)).toList();

      if (windowsToShow.isEmpty) {
        windowsToShow = wl;
      }

      for (var element in wl) {
        if (element.isActive) {
          final activeWindow = windowsToShow.firstWhere((window) => window.name == element.name);

          activeWindow.previousActivityForce = activeWindow.activityForce;
          activeWindow.activityForce = activeWindow.activityForce + 100;
        }
      }
      setState(() => ticks = ticks + 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30.0),
              const Text(
                'system_windows',
                style: TextStyle(fontSize: 28.0),
              ),
              const SizedBox(height: 20.0),
              const Text(
                '这个插件允许你在你的桌面上获取关于打开的应用程序的数据来做一些很酷的事情，就像下面的例子 🔥',
                style: TextStyle(fontSize: 18.0, color: Colors.black54),
              ),
              const SizedBox(height: 30.0),
              if (Platform.isMacOS) ...[
                Text(
                  '具有屏幕录制权限: $hasScreenRecordingPermissions',
                ),
                const SizedBox(height: 30.0),
              ],
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: windowsToShow.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            TweenAnimationBuilder<int>(
                              tween: IntTween(
                                begin: windowsToShow[index].previousActivityForce,
                                end: windowsToShow[index].activityForce,
                              ),
                              duration: const Duration(milliseconds: 1000),
                              builder: (context, value, widget) => Expanded(
                                flex: value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  height: 40.0,
                                ),
                              ),
                            ),
                            TweenAnimationBuilder<int>(
                              tween: IntTween(
                                begin: windowsToShow[index].activityForce,
                                end: ticks - windowsToShow[index].activityForce,
                              ),
                              duration: const Duration(milliseconds: 1000),
                              builder: (context, value, widget) => Expanded(
                                flex: value,
                                child: Container(
                                  height: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 55.0, top: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name: ${windowsToShow[index].name}"),
                                Text("Title: ${windowsToShow[index].title}"),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Window {
  Window(
    this.name,
    this.title,
    this.isActive,
    this.activityForce,
    this.previousActivityForce,
  );

  String name;
  String title;
  bool isActive;
  int activityForce;
  int previousActivityForce;
}
