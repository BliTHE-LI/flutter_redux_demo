import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_demo/redux/global_states.dart';
import 'package:flutter_redux_demo/redux/reducers/reducers.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/";
  final String title;
  HomePage({Key key, @required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _updateToken() {
    String token;
    String oldToken =
        StoreProvider.of<GlobalStates>(context).state.authorizationToken;
    if (oldToken == null || oldToken.isEmpty) {
      token = "authorizationToken";
    } else {
      token = "";
    }

    ///通过 redux 去执行登陆流程
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
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
