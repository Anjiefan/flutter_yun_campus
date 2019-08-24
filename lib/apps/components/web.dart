import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
class WebApp extends StatefulWidget {
  final String url;
  final PreferredSizeWidget appBar;
  const WebApp({
    Key key,
    @required this.url,
    this.appBar
  }):
        assert(url != null),
        super(key:key);
  @override
  State<StatefulWidget> createState() =>WebState(appBar: this.appBar,url: this.url);
}

class WebState extends PageState<WebApp>{
  final String url;
  final PreferredSizeWidget appBar;
  WebState({this.appBar,this.url});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WebviewScaffold(
      url: url,
      appBar: appBar,
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
