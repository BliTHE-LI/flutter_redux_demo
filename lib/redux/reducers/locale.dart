import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

/// 关联主题的action
part '../actions/locale.dart';

/// 语言处理
/// combineReducers方法，用于 Reducer 的拆分。
/// 你只要定义各个子 Reducer 函数，然后用这个方法，将它们合成一个大的 Reducer。
/// 通过 flutter_redux 的 combineReducers，创建 Reducer<State>
final LocaleReducer = combineReducers<Locale>([
  ///将Action，处理Action动作的方法，State绑定
  TypedReducer<Locale, RefreshLocaleAction>(RefreshLocaleAction.refresh),
]);
