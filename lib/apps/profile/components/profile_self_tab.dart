import 'package:finerit_app_flutter/apps/bbs/state/bbs_state.dart';
import 'package:finerit_app_flutter/apps/components/blank_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_jianlue_status_widget.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/beans/status_data_list_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:scoped_model/scoped_model.dart';
class ProfileGuangboTab extends StatefulWidget {
  String userid;
  ProfileGuangboTab({Key key,this.userid}):super(key:key);
  @override
  State<StatefulWidget> createState() => ProfileGuangboState(userid: userid);
}

class ProfileShoucangTab extends StatefulWidget {
  String userid;
  ProfileShoucangTab({Key key,this.userid}):super(key:key);
  @override
  State<StatefulWidget> createState() => ProfileShoucangState(userid: userid);

}




class ProfileGuangboState extends BBSState<ProfileGuangboTab> {
  String userid;
  ProfileGuangboState({this.userid}):super();
  Widget get_cart_wighet(int index){
    return ProfileJianlueStatusCard(obj:bbsModel.getData()[index]);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bbsModel=ScopedModel.of<BaseStatusModel>(context,rebuildOnChange: true);
    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      refresh_data();
    }
    if(loading==true&&bbsModel.initData==null){
      loading=false;
    }
    return handle_main_wighet();
  }
  Future load_more_data(){
    NetUtil.get(Api.BBS_BASE, (data) {
      var itemList = StatusDataList.fromJson(data);
      page=page+1;
      bbsModel.addAll(itemList.data);
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'user_collect':userid,'page':page},
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
      });
    },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
        params: {'user_collect':userid,'page':1},
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
        onRefresh: () async {
          refresh_data();
        },
        loadMore: () async {
          load_more_data();
        },
      ),
    );
  }

}

class ProfileShoucangState extends BBSState<ProfileShoucangTab>{
  ProfileShoucangState({this.userid}):super();
  String userid;
  Widget get_cart_wighet(int index){
    return ProfileJianlueStatusCard(obj:bbsModel.getData()[index]);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bbsModel=ScopedModel.of<BaseStatusModel>(context,rebuildOnChange: true);
    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      refresh_data();
    }
    if(loading==true&&bbsModel.initData==null){
      loading=false;
    }
    return handle_main_wighet();
  }
  Future load_more_data(){
    NetUtil.get(Api.BBS_BASE, (data) {
      var itemList = StatusDataList.fromJson(data);
      page=page+1;
      bbsModel.addAll(itemList.data);
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'user':userid,'page':page},
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
      });
    },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
        params: {'user':userid,'page':1},
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
        onRefresh: () async {
          refresh_data();
        },
        loadMore: () async {
          load_more_data();
        },
      ),
    );
  }

}




