/// 指明与其关联的父库
part of '../reducers/theme.dart';

/// 定义一个 Action 类
/// 将该 Action 在 Reducer 中与处理该Action的方法绑定
class RefreshThemeAction {
  RefreshThemeAction(this.themeData);
  final ThemeData themeData;

  /// 定义处理 Action 行为的方法，返回新的 State
  static ThemeData refresh(ThemeData themeData, action) {
    themeData = action.themeData;
    return themeData;
  }
}
