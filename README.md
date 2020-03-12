# flutter_redux_demo
# Flutter全局状态管理和数据持久化

> 如果不知道[Redux](https://www.redux.org.cn/)的自行查看[Redux](https://www.redux.org.cn/)文档。

<a name="JfkfT"></a>
## 依懒包

- [Redux](https://pub.dartlang.org/packages/redux) : JavaScript Redux 的复刻版
- [Flutter Redux](https://pub.dartlang.org/packages/flutter_redux)：类似于 React Redux 一样，让我们在 Flutter 项目中更好的使用 Redux
- [Redux Persist](https://pub.dartlang.org/packages/redux_persist)：Redux 持久化
- [Redux Persist Flutter](https://pub.dartlang.org/packages/redux_persist_flutter)：Flutter Redux Persist 引擎
```yaml
..
dependencies:
  ...
  # Redux 全局状态管理
  flutter_redux: ^0.6.0
  redux: ^4.0.0
  # Redux 数据持久化
  redux_persist: ^0.8.3
  redux_persist_flutter: ^0.8.2

dev_dependencies:
  ...
...
```
<a name="IhGrz"></a>
## 在Flutter中使用Redux
<a name="Nn8EV"></a>
### 创建相关文件和文件夹

> `lib/redux/global_state.dart`：全局状态定义文件。
> `lib/redux/reducers`：所有reducer都将在这里定义。
> `lib/redux/actions`：所有`action`都将在这里定义。
> `lib/redux/middlewares`：所有middleware都将在这里定义，本文没有用到。



`lib/redux/global_state.dart`  文件：
```dart
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

/// 引入Reducer
import 'reducers/reducers.dart';

/// 全局Redux store 的对象，保存State数据
class GlobalStates {
  /// 用户token信息
  String authorizationToken;

  /// 获取当前是否处于已认证状态
  get authed => authorizationToken.length > 0;

  /// 构造方法
  GlobalStates({ this.authorizationToken });
}

/// 创建 Reducer
/// 自定义了 globalReducer 用于创建 store
GlobalStates globalReducer(GlobalStates state, action) {
  return GlobalStates(
    // /// 通过自定义 LoginReducer 将 GlobalState 内的 authorizationToken 和 action 关联在一起
    authorizationToken: LoginReducer(state.authorizationToken, action),
  );
}

// 中间件列表
final List<Middleware<GlobalStates>> reduxMiddleware = [];
```

`lib/redux/reducers/login.dart` 文件：
```dart
import 'package:redux/redux.dart';
/// 关联与login相关的action
part '../actions/login.dart';

/// 定义LoginReducer
final LoginReducer = combineReducers<String>([
  TypedReducer<String, RefreshAuthorizationTokenAction>(
      RefreshAuthorizationTokenAction.refresh),
  		/// 可定义多个action
  		/// ....
]);
```

`lib/redux/actions/login.dart` 文件：
```dart
/// 指定属于哪个主库文件
/// ../reducers/login.dart的子文件
part of '../reducers/login.dart';

/// 定义刷新用户token的action
class RefreshAuthorizationTokenAction {
  RefreshAuthorizationTokenAction({this.authorizationToken = ''});
  final String authorizationToken;
	
  /// 创建刷新token的reducer
  static String refresh(
      String authorizationToken, RefreshAuthorizationTokenAction action) {
    authorizationToken = action.authorizationToken;
    return authorizationToken;
  }
}
```
<a name="AcmDl"></a>
### 使用Redux

`lib/main.dart` 文件：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

/// 引入state、reducer、middleware
import 'package:flutter_redux_demo/redux/global_states.dart';
/// 引入RefreshAuthorizationTokenAction
import 'package:flutter_redux_demo/redux/reducers/login.dart';

void main() {
  /// 初始化全局仓库
  var _store = Store<GlobalStates>(
    globalReducer,
    initialState: GlobalStates(),
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
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: HomePage(title:'Flutter Redux Demo'),
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, @required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 创建更新token的方法
  void _updateToken() {
    String token;
    String oldToken =
        StoreProvider.of<GlobalStates>(context).state.authorizationToken;
    /// 判断没有token就赋值，有就赋值为空
    if (oldToken == null || oldToken.isEmpty) {
      token = "authorizationToken";
    } else {
      token = "";
    }

    /// 通知仓库修改token，修改完成后Redux会通知所有页面更新authorizationToken
    StoreProvider.of<GlobalStates>(context)
        .dispatch(RefreshAuthorizationTokenAction(authorizationToken: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '通过StoreProvider获取数据：',
            ),
            Text(
              StoreProvider.of<GlobalStates>(context)
                      .state
                      .authorizationToken ??
                  '',
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              '通过StoreConnector获取数据：',
            ),
            StoreConnector<GlobalStates, String>(
              converter: (store) => store.state.authorizationToken,
              builder: (context, authorizationToken) {
                return Text(
                  '${authorizationToken ?? ''}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateToken,
        tooltip: '更新Token',
        child: Text('更新Token'),
      ),
    );
  }
}
```

以上就是flutter_redux的使用方法，文件名义以及路径可根据项目需求进行修改以及拆分。
<a name="t1AOH"></a>
## 使用redux_persist实现持久化

> 在上面，已经完成了一个基于 Redux 的同步状态的App，但是当你的App关闭重新打开之外，状态树就会被重置为初始值，这并不理想，我们经常需要一个用户完成登录之后，就可以在一断时间内一直保持这个登录状态，而且有一些数据我们并不希望每次打开App的时候都重新初始化一次，这个时候，可以考虑对状态进行持久化了。

<a name="UW1Zk"></a>
### 更新 `lib/redux/global_state.dart` 文件

```dart
...
class GlobalStates {
  ...
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
...
```
> 这里我们添加了两个方法，一个是静态的 `fromJson` 方法，它将在初始化状态树时被调用，用于从 JSON 中初始化一个新的状态树出来， `toJson` 将被用于持久化，将自身转成 JSON。


<a name="493WK"></a>
### 更新 lib/main.dart 文件

```dart
...
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
void main() async {
  /// 必须先执行WidgetsFlutterBinding.ensureInitialized();
  /// 否则persistor中加载文件中的状态会报错
  WidgetsFlutterBinding.ensureInitialized();
  // 创建一个持久化器
  final persistor = Persistor<GlobalStates>(
    // 使用文件存储，不用引入redux_persist_flutter依赖
    // storage: FileStorage(File("state.json")),
    // 使用redux_persist_flutter进行缓存
    storage: FlutterStorage(),
    serializer: JsonSerializer<GlobalStates>(GlobalStates.fromJson),
  );
  
  // 从 persistor 中加载上一次存储的状态
  final initialState = await persistor.load() ?? GlobalStates();
	/// persistor.createMiddleware() 中间件 会在状态修改后进行持久化缓存（就是写入文件）
  /// 初始化全局仓库
  var _store = Store<GlobalStates>(
    globalReducer,
    middleware: [persistor.createMiddleware()],
    initialState: initialState,
  );
  runApp(MyApp(store: _store));
}
...
```
> 到目前为止已经完成了状态的持久化，重新 `flutter run` 当前应用，即完成了持久化，可以更新token，然后退出应用，再重新打开应用，可以看到上一次的token状态是存在的。

> 注意：也可自己实现`middleware`进行持久化存储，不使用`redux_persist``_flutter`。