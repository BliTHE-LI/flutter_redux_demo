import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux_demo/pages/home/index_page.dart';

class RouterConfig {
  static Widget home = HomePage(title: "Flutter Redux Demo");
  static String initialRoute = HomePage.routeName;
  static Map<String, WidgetBuilder> routers = {
    HomePage.routeName: (context) => HomePage(title: "Flutter Redux Demo"),
  };
}
