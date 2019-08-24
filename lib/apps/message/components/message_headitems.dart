import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/apps/components/vip_discript_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_level_icon.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_vip_icon.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';
import 'package:flutter/material.dart';

class MesHeadItems extends StatelessWidget{
  UserInfoBrief user;
  MesHeadItems({Key key,this.user}):super(key:key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Expanded(
        child:
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              child:  BaseUserHead(
                userInfo: user,
                radius: 18,
              ),
            ),
            new Container(
              child:
              Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 2,right: 2,bottom: 0,top: 0),
                          child: Text("  " + user.nickName  , style: new TextStyle(color: Colors.black87,fontWeight: FontWeight.w500)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5,top: 2),
                          child:VipDiscriptWidget(levelDesignation: user.vipInfo.levelDesignation
                            ,isAnnual: user.vipInfo.isAnnual,isOpening: user.vipInfo.isOpening,),


                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,top: 2),
                      child: new LevelIcon(level: user.level.levelDesignation,iconsize: 1,biglevel: user.level.bigLevelDesignation,),
                    ),

                  ],
                  crossAxisAlignment:CrossAxisAlignment.start
              ),
              padding: EdgeInsets.only(),
            ),

          ],
        )
    );
  }
}