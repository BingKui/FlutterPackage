import 'package:hotkey_manager/hotkey_manager.dart';

// 最小化快捷键
HotKey iMiniKey = HotKey(
  KeyCode.keyK,
  modifiers: [KeyModifier.control],
  scope: HotKeyScope.inapp, // 应用级
);

// 打开快捷键
HotKey iOpenKey = HotKey(
  KeyCode.keyO,
  modifiers: [KeyModifier.control],
  scope: HotKeyScope.system, // 系统级
);
