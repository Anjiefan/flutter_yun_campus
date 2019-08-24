import 'package:finerit_app_flutter/apps/bbs/components/bbs_card.dart';
import 'package:finerit_app_flutter/apps/components/blank_widget.dart';
import 'package:finerit_app_flutter/apps/contact/components/contact_request_card_widget.dart';
import 'package:finerit_app_flutter/beans/friend_request_data_bean.dart';
import 'package:finerit_app_flutter/beans/friend_request_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/status_data_list_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class ContactRequestState<T extends StatefulWidget> extends PageState{
  FriendRequestBaseModel friendRequestBaseModel;
  UserAuthModel userAuthModel;
  bool relate=false;
  Widget get_cart_wighet(int index){
    return ContactRequestCard(index:index,relate: relate,);
  }
  Widget handle_main_wighet(){
    return Container(
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
            itemCount: friendRequestBaseModel.friendRequestList.length,
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
  Future load_more_data(){
    NetUtil.get(Api.FRIEND_REQUESTS, (data) {
      var itemList = FriendRequestDataList.fromJson(data);
      page=page+1;
      friendRequestBaseModel.friendRequestList.addAll(itemList.data);
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {"relate": relate,'page':page},
    );
  }
  Future refresh_data(){
    NetUtil.get(Api.FRIEND_REQUESTS, (data) {
      var itemList = FriendRequestDataList.fromJson(data);
      friendRequestBaseModel.friendRequestList=itemList.data;
      if(!this.mounted){
        return;
      }
      setState(() {
        page=2;
      });
    },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
        params: {"relate": relate,'page':1},
        );
  }
  @override
  Widget build(BuildContext context) {
    friendRequestBaseModel=ScopedModel.of<FriendRequestBaseModel>(context,rebuildOnChange: true);
    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    return new Scaffold(
        body:handle_main_wighet()
    );
  }
}