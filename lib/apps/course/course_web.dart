import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
class CourseWebApp extends StatefulWidget {
  final String url;
  const CourseWebApp({
    Key key,
    @required this.url,
  }):
        assert(url != null),
        super(key:key);
  @override
  State<StatefulWidget> createState() =>CourseWebState(this.url);
}

class CourseWebState extends PageState<CourseWebApp>{
  final String url;
  CourseWebState(this.url);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WebviewScaffold(
      url: url,
      appBar: new AppBar(
        title: const Text('代课系统',style: TextStyle(color:Colors.black),),
        centerTitle: true,
        leading: BackButton(
          color: Colors.grey[800],
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Container(
            child: FlatButton.icon(
              onPressed: () async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch ${url}';
                }
              },
              icon: Icon(
                Icons.language,
                color: Colors.black,
              ),
              label: Text(
                '浏览器打开',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
//          IconButton(icon: Icon(Icons.language,color: Colors.black,), onPressed: () async {
//            if (await canLaunch(url)) {
//              await launch(url);
//            } else {
//              throw 'Could not launch $url';
//            }
//          }
//          )
        ],
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
