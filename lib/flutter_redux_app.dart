import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_redux_demo/redux/global_states.dart';
import 'package:flutter_redux_demo/routers/routers.dart';

class FlutterReduxApp extends StatefulWidget {
  FlutterReduxApp({Key key, @required this.store}) : super(key: key);
  final Store<GlobalStates> store;
  @override
  _FlutterReduxAppState createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp> {
  @override
  Widget build(BuildContext context) {
    /// 使用 flutter_redux 做全局状态共享
    /// 通过 StoreProvider 应用 store
    return StoreProvider<GlobalStates>(
      store: widget.store,
      child: StoreBuilder<GlobalStates>(
        builder: (context, store) {
          return MaterialApp(
            title: 'Flutter Redux Demo',
            theme: store.state.theme,
            // home: RouterConfig.home,
            initialRoute: RouterConfig.initialRoute,
            routes: RouterConfig.routers,
          );
        },
      ),
    );
  }
}
