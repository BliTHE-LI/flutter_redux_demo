part of '../reducers/login.dart';

class RefreshAuthorizationTokenAction {
  RefreshAuthorizationTokenAction({this.authorizationToken = ''});
  final String authorizationToken;

  static String refresh(
      String authorizationToken, RefreshAuthorizationTokenAction action) {
    authorizationToken = action.authorizationToken;
    return authorizationToken;
  }
}
