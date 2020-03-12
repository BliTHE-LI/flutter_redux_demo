part of '../reducers/locale.dart';

class RefreshLocaleAction {
  RefreshLocaleAction(this.locale);
  final Locale locale;

  static Locale refresh(Locale locale, RefreshLocaleAction action) {
    locale = action.locale;
    return locale;
  }
}
