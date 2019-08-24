import 'package:finerit_app_flutter/apps/bbs/components/bbs_card.dart';
import 'package:finerit_app_flutter/apps/components/blank_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_head_items_blacklist.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_horizontal_divider_widget.dart';
import 'package:finerit_app_flutter/beans/shied_user_list_bean.dart';
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

abstract class ShieldUserState<T extends StatefulWidget> extends PageState{
  ShieldUserBaseModel shieldUserBaseModel;
  UserAuthModel userAuthModel;
  Widget get_cart_wighet(int index){
    return HeadItemsBlacklist(shieldUserData: shieldUserBaseModel.shieldUserList[index],);
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
            itemCount: shieldUserBaseModel.shieldUserList.length,
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
    NetUtil.get(Api.SHIELDUSERS, (data) {
      var itemList = ShieldUserDataList.fromJson(data);
      page=page+1;
      shieldUserBaseModel.addShieldUserAlls(itemList.data);
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'page':page},
    );
  }
  Future refresh_data(){
    NetUtil.get(Api.SHIELDUSERS, (data) {
      var itemList = ShieldUserDataList.fromJson(data);
      page=2;
      shieldUserBaseModel.shieldUserList=itemList.data;
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'page':1},
    );
  }
  @override
  Widget build(BuildContext context) {
    shieldUserBaseModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    return new Scaffold(

        body:handle_main_wighet()
    );
  }
}