// 初始化窗口
import 'dart:ui';

import 'package:window_manager/window_manager.dart';

Future<void> initWin() async {
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((value) async {
    await windowManager.setSize(const Size(400, 400));
  });
}
