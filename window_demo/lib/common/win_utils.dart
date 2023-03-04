// 初始化窗口
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> initWin() async {
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((value) async {
    // 设置窗口大小
    await windowManager.setSize(const Size(400, 500));
    // 设置位置
    await windowManager.setPosition(Offset.zero);
  });
}
