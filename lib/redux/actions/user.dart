part of '../reducers/user.dart';

class UpdateUserAction {
  UpdateUserAction({this.userInfo});
  final User userInfo;

  static User update(User userInfo, UpdateUserAction action) {
    userInfo = action.userInfo;
    return userInfo;
  }
}
