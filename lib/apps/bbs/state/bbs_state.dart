import 'package:finerit_app_flutter/apps/bbs/components/bbs_card.dart';
import 'package:finerit_app_flutter/apps/components/blank_widget.dart';
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

abstract class BBSState<T extends StatefulWidget> extends PageState{
  BaseStatusModel bbsModel;
  UserAuthModel userAuthModel;
  String type='用户广播';
  Widget get_cart_wighet(int index){
    return BBSCard(index:index);
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
            itemCount: bbsModel.getData()?.length??1,
            itemBuilder: (BuildContext context, int index) {
              return bbsModel.getData()!=null?new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Column(
                  children: <Widget>[
                    get_cart_wighet(index)
                  ],
                ),
              ):Container();
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
    NetUtil.get(Api.BBS_BASE, (data) {
      var itemList = StatusDataList.fromJson(data);
      page=page+1;
      bbsModel.addAll(itemList.data);
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {"type": type,'page':page},
    );
  }
  Future refresh_data(){
    NetUtil.get(Api.BBS_BASE, (data) {
      var itemList = StatusDataList.fromJson(data);
      bbsModel.setData(itemList.data);
      if(!this.mounted){
        return;
      }
      setState(() {
        bbsModel.initData=true;
        loading=true;
        page=2;
      });
    },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
        params: {"type": type,'page':1},
        errorCallBack: (error){
          requestToast(HttpError.getErrorData(error).toString());
          if(!this.mounted){
            return;
          }
          setState(() {
            bbsModel.initData=true;
            loading=true;
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    bbsModel=ScopedModel.of<BaseStatusModel>(context,rebuildOnChange: true);
    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    return new Scaffold(
        body:handle_main_wighet()
    );
  }
}