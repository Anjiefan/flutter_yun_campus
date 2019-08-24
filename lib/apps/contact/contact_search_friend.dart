
import 'package:finerit_app_flutter/apps/contact/components/contact_user_card_widget.dart';
import 'package:finerit_app_flutter/apps/contact/models/contact_model.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_list_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:finerit_app_flutter/style/global_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactSearchFriendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ContactSearchFriendPageState();
}

class ContactSearchFriendPageState extends PageState<ContactSearchFriendPage> {
  UserAuthModel userAuthModel;
  ContactSearchUserModel contactSearchUserModel;
  final TextEditingController _controller = new TextEditingController();
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    if(loading==false){
      contactSearchUserModel=ScopedModel.of<ContactSearchUserModel>(context,rebuildOnChange: true);
      loading=true;
    }

    return Scaffold(
      appBar: new AppBar(
        leading: BackButton(color: Colors.grey[800],),
        backgroundColor: Colors.white,
        title: new TextField(
          controller: _controller,
          autofocus: true,
          decoration: new InputDecoration.collapsed(
              hintText: "手机号/昵称搜索",
              hintStyle: new TextStyle(color: GlobalConfig.font_color)
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(MyFlutterApp.search,color: Colors.black,size: 30,),
            onPressed: (){
              _handle_search_press();
            },
          )
        ],
      ),
      body: handle_main_wighet(),
    );
  }
  void _handle_search_press(){
    refresh_data();
  }
  Widget get_cart_wighet(int index){
    return ContactUserCard(user: contactSearchUserModel.userinfoList[index],);
  }
  Widget handle_main_wighet(){
    return Container(
      child: new EasyRefresh(
        autoLoad: true,
        firstRefresh:false,
        key: easyRefreshKey,
        refreshHeader: MaterialHeader(
          key: headerKey,
        ),
        refreshFooter: MaterialFooter(
          key: footerKey,
        ),
        child: new ListView.builder(
          //ListView的Item
            itemCount: contactSearchUserModel.userinfoList.length,
            itemBuilder: (BuildContext context, int index) {
              return new Column(
                children: <Widget>[
                  get_cart_wighet(index),
                  Container(
                    height: 2,
                  )
                ],
              );
            }),
        onRefresh: () async {
          refresh_data();
        },
        loadMore: () async {
          load_more_data();
        },
      ),
    );
  }
  @override
  Future load_more_data() {
    NetUtil.get(Api.USER_INFO, (data) {
      var itemList = UserInfoDetailList.fromJson(data);
      _controller.clear();
      page=page+1;
      contactSearchUserModel.userinfoList.addAll(itemList.data);
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {"search": _controller.text,'page':page},
    );
  }

  @override
  Future refresh_data() {
    NetUtil.get(Api.USER_INFO, (data) {
      _controller.clear();
      var itemList = UserInfoDetailList.fromJson(data);
      contactSearchUserModel.userinfoList=itemList.data;
      if(!this.mounted){
        return;
      }
      setState(() {
        page=2;
      });
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {"search": _controller.text,'page':1},
    );
  }
}