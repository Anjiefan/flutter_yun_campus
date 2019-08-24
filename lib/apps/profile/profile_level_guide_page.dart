import 'dart:io';

import 'package:finerit_app_flutter/apps/money/money_base.dart';
import 'package:finerit_app_flutter/apps/money/money_base_ios.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:finerit_app_flutter/style/themes.dart';

import 'profile_vip_dredge_page.dart';
class ProfileLevelGuideApp extends StatefulWidget {
  final String url;
  const ProfileLevelGuideApp({
    Key key,
    @required this.url,
  }):
        assert(url != null),
        super(key:key);
  @override
  State<StatefulWidget> createState() =>ProfileLevelGuideAppState(this.url);
}

class ProfileLevelGuideAppState extends PageState<ProfileLevelGuideApp>{
  final String url;
  ProfileLevelGuideAppState(this.url);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WebviewScaffold(
      url: url,
      appBar: new AppBar(
        centerTitle: true,
        title: const Text('等级 | Vip介绍',style: TextStyle(color:Colors.black87,fontSize: 18,fontWeight: FontWeight.w500),),
        leading: BackButton(
          color: Colors.grey[800],
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Text('开通会员',style: TextStyle(color: Colors.black,fontSize: 16),),
              alignment: Alignment.center,
            ),
            onTap: (){
              Widget appWidget;
              appWidget=VIPDredgePage();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => appWidget,
                ),
              );
            },
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
