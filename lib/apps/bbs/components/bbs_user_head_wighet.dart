import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/apps/components/vip_discript_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_level_icon.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_svip_icon.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_vip_icon.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/profile_userinfo_page.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';

class UserHead extends StatelessWidget{
  UserHead({Key key,this.username,this.sincePosted,this.headImg,this.userInfo}):super(key:key);
  String username;
  String sincePosted;
  String headImg;
  UserInfoBrief userInfo;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Expanded(
        child:
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BaseUserHead(
              userInfo: userInfo,
              radius: 22.0,
            ),
            new Container(
              child:
              new FittedBox(
                child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 2,right: 2,bottom: 0,top: 0),
                            child: Text("  " + username  , style: new TextStyle(color: Colors.black87,fontWeight: FontWeight.w500)),
                          ),
                          VipDiscriptWidget(levelDesignation: userInfo.vipInfo.levelDesignation
                            ,isAnnual: userInfo.vipInfo.isAnnual,isOpening: userInfo.vipInfo.isOpening,),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,top: 2),
                        child: new LevelIcon(level: userInfo.level.levelDesignation
                          ,iconsize: 1,color: Colors.lightBlue,biglevel: userInfo.level.bigLevelDesignation),
                      ),

                    ],
                    crossAxisAlignment:CrossAxisAlignment.start
                ),
              ),
              padding: EdgeInsets.only(),
            ),

          ],
        )
    );
  }
  void handle_profile_detail_nav(BuildContext context){
    UserInfoDetail user;
    user=UserInfoDetail.fromJson(userInfo.toJson());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileUserPage(statusShouCangModel: StatusShouCangModel()
          ,statusSelfModel: StatusSelfModel(),user: user,),
      ),
    );
  }
}