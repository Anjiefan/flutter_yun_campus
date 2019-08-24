import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:scoped_model/scoped_model.dart';

class WelcomeContractApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WelcomeContractAppState();
}

class WelcomeContractAppState extends PageState<WelcomeContractApp> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  UserAuthModel _userAuthModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterWebViewPlugin.onDestroy.listen((_) => null);
  }

  @override
  Widget build(BuildContext context) {
    _userAuthModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    return WillPopScope(
      onWillPop: () {
      },
      child: WebviewScaffold(
        url: "https://www.finerit.com/media/xieyi.html",
        appBar: AppBar(
          leading: Text(""),
          centerTitle: true,
          title: Text(
            "请仔细阅读协议",
            style: TextStyle(color: Colors.grey[800]),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _userAuthModel.prefs.setBool('is_read_licence', true);
                Navigator.pop(context);
              },
              child: Text("我同意"),
            )
          ],
          backgroundColor: Colors.white,
        ),
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        withJavascript: true,
        initialChild: Container(
          alignment: Alignment.topCenter,
          child: new EasyRefresh(
            autoLoad: true,
            firstRefresh:true,
            key: easyRefreshKey,
            refreshHeader: MaterialHeader(
              key: headerKey,
            ),
            refreshFooter: MaterialFooter(
              key: footerKey,
            ),
            child: new ListView.builder(
              //ListView的Item
                itemCount: 0,
                itemBuilder: (BuildContext context, int index) {
                  return Container();
                }),
            onRefresh: ()  {
            },
            loadMore: ()  {
            },
          ),
        ),
      ),
    );
  }

  @override
  Future load_more_data() {
    // TODO: implement load_more_data
    return null;
  }

  @override
  Future refresh_data() {
    // TODO: implement refresh_data
    return null;
  }
}
