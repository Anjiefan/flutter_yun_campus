import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
class ImApp extends StatefulWidget {
  final String fromUserId;
  final String toUserId;
  final bool isFeedback;
  String url;


  ImApp.name(this.fromUserId, this.toUserId, this.isFeedback){
    url = "https://im.finerit.com/#!/login/"+ fromUserId + "~00" +"/" + toUserId + "~00";ps:
//    url = "https://www.baidu.com";
    print("im_Url=" + url);
  }

  @override
  State<StatefulWidget> createState() =>ImAppState(this.url, this.isFeedback);
}

class ImAppState extends PageState<ImApp>{
  final String url;
  final bool isFeedback;
  ImAppState(this.url, this.isFeedback);
  @override
  Widget build(BuildContext context) {

    return WebviewScaffold(
      url: url,
      appBar: new AppBar(
        title: isFeedback?const Text('客服',style: TextStyle(color:Colors.black),):
        const Text('聊天',style: TextStyle(color:Colors.black),),
        centerTitle: true,
        leading: BackButton(
          color: Colors.grey[800],
        ),
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
