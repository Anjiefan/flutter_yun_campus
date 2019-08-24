import 'package:finerit_app_flutter/apps/bbs/state/bbs_state.dart';
import 'package:finerit_app_flutter/apps/components/blank_widget.dart';
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

class ProfileGuangboPage extends StatefulWidget {
  ProfileGuangboPage({Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() => ProfileGuangboPageState();
}

class ProfileGuangboPageState extends BBSState<ProfileGuangboPage> {
  ProfileGuangboPageState():super();
  @override
  Widget build(BuildContext context) {
    bbsModel=ScopedModel.of<BaseStatusModel>(context,rebuildOnChange: true);
    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    return new Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.grey[800],
          ),
          centerTitle: true,
          title: Text(
            "我的公告",
            style: TextStyle(color: Colors.grey[800]),
          ),
          backgroundColor: Colors.white,

        ),
        body:handle_main_wighet()
    );
  }
  Future load_more_data(){
    NetUtil.get(Api.BBS_BASE, (data) {
      var itemList = StatusDataList.fromJson(data);
      page=page+1;
      bbsModel.addAll(itemList.data);
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'user':userAuthModel.objectId,'page':page},
    );
  }
  Future refresh_data(){
    NetUtil.get(Api.BBS_BASE, (data) {
      var itemList = StatusDataList.fromJson(data);
      if(itemList.data.length!=0){

        bbsModel.setData(itemList.data);
      }
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
        params: {'user':userAuthModel.objectId,'page':1},
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

}