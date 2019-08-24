
import 'package:finerit_app_flutter/apps/profile/components/profile_head_items.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_horizontal_divider_widget.dart';
import 'package:finerit_app_flutter/beans/Invite_data_list_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class TeamState<T extends StatefulWidget> extends PageState{
  InviteBaseModel inviteBaseModel;
  UserAuthModel userAuthModel;
  String type='1';
  Widget get_cart_wighet(int index){
    return HeadItems(user: inviteBaseModel.inviteDataList[index].invite,);
  }
  Widget handle_main_wighet(){
    return Container(
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
            padding:EdgeInsets.all(0),
            itemCount: inviteBaseModel.inviteDataList.length,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Column(
                  children: <Widget>[
                    get_cart_wighet(index),
                    HorizontalDivider()
                  ],
                ),
              );
            }),
        onRefresh: ()  {
          refresh_data();
        },
        loadMore: ()  {
          load_more_data();
        },
      ),
    );
  }
  Future load_more_data(){
    NetUtil.get(Api.TEAM_INVITE, (data) {
      var itemList = InviteDataList.fromJson(data);
      page=page+1;
      inviteBaseModel.addInviteDataAlls(itemList.data);
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'page':page,'type':type},
    );
  }
  Future refresh_data(){
    NetUtil.get(Api.TEAM_INVITE, (data) {
      var itemList = InviteDataList.fromJson(data);
      page=2;
      inviteBaseModel.inviteDataList=itemList.data;
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'type':type,'page':1},
    );
  }
  @override
  Widget build(BuildContext context) {
    inviteBaseModel=ScopedModel.of<InviteBaseModel>(context,rebuildOnChange: true);
    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    return new Scaffold(
        body:handle_main_wighet()
    );
  }
}