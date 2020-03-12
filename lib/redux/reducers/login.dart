import 'package:redux/redux.dart';
part '../actions/login.dart';

final LoginReducer = combineReducers<String>([
  TypedReducer<String, RefreshAuthorizationTokenAction>(
      RefreshAuthorizationTokenAction.refresh),
]);
