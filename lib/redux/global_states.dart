import 'package:flutter/material.dart';
import 'package:flutter_redux_demo/models/user.dart';
import 'package:redux/redux.dart';

/// 引入Reducer
import 'reducers/reducers.dart';

/// 全局Redux store 的对象，保存State数据
class GlobalStates {
  ///用户信息
  User userInfo;

  ///主题数据
  ThemeData theme;

  ///语言
  Locale locale;

  /// J.W.T
  String authorizationToken;

  // 获取当前是否处于已认证状态
  get authed => authorizationToken.length > 0;

  /// 构造方法
  GlobalStates({
    this.authorizationToken,
    this.locale,
    this.userInfo,
    this.theme,
  });

  // 持久化时，从 JSON 中初始化新的状态
  static GlobalStates fromJson(dynamic json) {
    GlobalStates state = GlobalStates();
    if (json != null) {
      state.authorizationToken =
          json["authorizationToken"] == null ? '' : json["authorizationToken"];
    }
    return state;
  }

  // 更新状态之后，转成 JSON，然后持久化至持久化引擎中
  dynamic toJson() {
    return {
      'authorizationToken': authorizationToken ?? "",
    };
  }
}

/// 创建 Reducer
/// 源码中 Reducer 是一个方法 typedef State Reducer<State>(State state, dynamic action);
/// 我们自定义了 appReducer 用于创建 store
GlobalStates globalReducer(GlobalStates state, action) {
  return GlobalStates(
    // /// 通过自定义 UserReducer 将 GlobalState 内的 userInfo 和 action 关联在一起
    // userInfo: UserReducer(state.userInfo, action),

    // /// 通过自定义 ThemeDataReducer 将 GlobalState 内的 themeData 和 action 关联在一起
    // theme: ThemeReducer(state.theme, action),

    // /// 通过自定义 LocaleReducer 将 GlobalState 内的 locale 和 action 关联在一起
    // locale: LocaleReducer(state.locale, action),
    // /// 通过自定义 LoginReducer 将 GlobalState 内的 locale 和 action 关联在一起
    authorizationToken: LoginReducer(state.authorizationToken, action),
  );
}

final List<Middleware<GlobalStates>> reduxMiddleware = [];
