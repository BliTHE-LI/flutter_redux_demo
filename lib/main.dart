import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_demo/routers/routers.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

import 'package:flutter_redux_demo/redux/global_states.dart';

void main() async {
  /// 必须先执行WidgetsFlutterBinding.ensureInitialized();
  /// 否则persistor中加载文件中的状态会报错
  WidgetsFlutterBinding.ensureInitialized();
  // 创建一个持久化器
  final persistor = Persistor<GlobalStates>(
    // 使用文件存储
    // storage: FileStorage(File("state.json")),
    // // Use shared preferences
    // FlutterStorage(location: FlutterSaveLocation.sharedPreferences);
    // // Use document file
    // FlutterStorage(location: FlutterSaveLocation.documentFile);
    storage: FlutterStorage(),
    // Or use other serializers
    serializer: JsonSerializer<GlobalStates>(GlobalStates.fromJson),
    // transforms: Transforms(
    //   onLoad: [
    //     (state) {
    //       print("persistor onLoad $state");
    //       return state;
    //     }
    //   ],
    //   onSave: [
    //     (state) {
    //       print("persistor onSave");
    //       return state;
    //     }
    //   ],
    // ),

    // // 限制保存到磁盘的间隔以防止过多写入。 应该将此值保持较低，以防止数据丢失。
    // throttleDuration: Duration(seconds: 2),
  );
  // 从 persistor 中加载上一次存储的状态
  final initialState = await persistor.load() ??
      GlobalStates(
        userInfo: null,
        locale: Locale("zh", "CN"),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      );

  /// 初始化全局仓库
  var _store = Store<GlobalStates>(
    globalReducer,
    middleware: [persistor.createMiddleware()],
    initialState: initialState,
  );
  runApp(MyApp(store: _store));
}

class MyApp extends StatelessWidget {
  MyApp({Key key, @required this.store}) : super(key: key);
  final Store<GlobalStates> store;
  @override
  Widget build(BuildContext context) {
    /// 使用 flutter_redux 做全局状态共享
    /// 通过 StoreProvider 应用 store
    return StoreProvider<GlobalStates>(
      store: store,
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
