import 'package:flutter_redux_demo/models/user.dart';
import 'package:redux/redux.dart';

/// 关联用户的action
part '../actions/user.dart';

/// 用户信息处理
/// combineReducers方法，用于 Reducer 的拆分。
/// 你只要定义各个子 Reducer 函数，然后用这个方法，将它们合成一个大的 Reducer。
/// 通过 flutter_redux 的 combineReducers，创建 Reducer<State>
final UserReducer = combineReducers<User>([
  ///将Action，处理Action动作的方法，State绑定
  TypedReducer<User, UpdateUserAction>(UpdateUserAction.update),
]);
