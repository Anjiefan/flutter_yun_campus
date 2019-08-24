
import 'package:finerit_app_flutter/apps/bbs/bbs_replay.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/beans/status_data_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileJianlueStatusCard extends  StatelessWidget{
  StatusData obj;
  UserAuthModel _userAuthModel;
  ProfileJianlueStatusCard({Key key,this.obj}):super();
  @override
  Widget build(BuildContext context) {
    _userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    // TODO: implement build
    return GestureDetector(
      child: Container(
        color: Color.fromARGB(0, 255, 255, 255),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
              child:new Row(
                children: <Widget>[
                  Text(obj.text.length>20?obj.text.substring(0,20)+'...':obj.text,),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Divider(color: Colors.grey),
            ),
          ],
        ),
      ),
      onTap: (){
        _handle_detail_status(context);
      },
    );
  }
  void _handle_detail_status(var context){
    ProfileCommonStatusModel profileCommonStatusModel=ProfileCommonStatusModel();
    profileCommonStatusModel.setData([obj]);
    NetUtil.post(Api.STATUS_BROWSE, (data){
      NetUtil.get(Api.BBS_BASE+obj.id.toString()+'/', (data) {

        var _obj = StatusData.fromJson(data);
        profileCommonStatusModel.update(_obj, 0);
        //TODO 界面显示数据
      },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      );
    },headers: {"Authorization": "Token ${_userAuthModel.session_token}"}
        ,params: {'status':obj.id},errorCallBack: (){});

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=>
            ScopedModel<BaseStatusModel>(
              model: profileCommonStatusModel,
              child: ReplyPage(bbsDetailItem: obj,index:0),
            )
    ));
  }

}
