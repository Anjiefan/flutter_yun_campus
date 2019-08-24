import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/apps/components/vip_discript_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_level_icon.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_svip_icon.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_vip_icon.dart';
import 'package:finerit_app_flutter/beans/shied_user_data_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HeadItemsBlacklist extends StatefulWidget{
  ShieldUserData shieldUserData;
  HeadItemsBlacklist({Key key,this.shieldUserData}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HeadItemsBlacklistState(shieldUserData: shieldUserData);
  }

}

class HeadItemsBlacklistState extends State<HeadItemsBlacklist>{
  ShieldUserData shieldUserData;
  HeadItemsBlacklistState({this.shieldUserData}):super();
  UserAuthModel userAuthModel;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            child:  BaseUserHead(
              userInfo: shieldUserData.shieldUser,
              radius: 15,
            ),
          ),
          new Text(shieldUserData.shieldUser.nickName,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
          new Container(
            margin: EdgeInsets.only(left: 5),
            child: new LevelIcon(level: shieldUserData.shieldUser.level.levelDesignation,iconsize: 1,color: Colors.lightBlue,),
          ),

          new Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                VipDiscriptWidget(levelDesignation: shieldUserData.shieldUser.vipInfo.levelDesignation
                  ,isAnnual: shieldUserData.shieldUser.vipInfo.isAnnual
                  ,isOpening: shieldUserData.shieldUser.vipInfo.isOpening,),
                Container(width: 3,),
                shieldUserData.isShield?Text('开'):Text('关'),
                new Container(
                  child: Switch(
                    value: shieldUserData.isShield,
                    onChanged:(v){
                      _onchanged(v);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: Colors.lightBlueAccent,
                    activeTrackColor: Colors.grey[300],
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _onchanged(bool v){
    NetUtil.put(
        Api.SHIELDUSERS + shieldUserData.id.toString() + "/",
            (data) async {
              if(data['is_shield']==true){
                requestToast('开启屏蔽');
              }
              else{
                requestToast('关闭屏蔽');
              }
              setState(() {
                shieldUserData.isShield=data['is_shield'];
              });
        },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
        params: {"is_shield": !shieldUserData.isShield},

    );
    setState(() {
      shieldUserData.isShield=!shieldUserData.isShield;
    });
  }
}