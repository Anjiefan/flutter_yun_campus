import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/apps/components/vip_discript_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_level_icon.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_vip_icon.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/profile_userinfo_page.dart';
import 'package:finerit_app_flutter/beans/invite_data_bean.dart';
import 'package:finerit_app_flutter/beans/team_info_data_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:flutter/material.dart';

class HeadItems extends StatelessWidget{
  UserInfoBrief user;
  HeadItems({this.user}):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Container(
        color: Color.fromARGB(0, 255, 255, 255),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            new Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: BaseUserHead(
                  userInfo: user,
                  radius: 15,
                )
            ),
            new Text(user.nickName,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
            new Container(
              margin: EdgeInsets.only(left: 5),
              child: new LevelIcon(level: user.level.levelDesignation,iconsize: 1.2,biglevel: user.level.bigLevelDesignation,),
            ),
            new Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  VipDiscriptWidget(levelDesignation: user.vipInfo.levelDesignation
                    ,isAnnual: user.vipInfo.isAnnual,isOpening: user.vipInfo.isOpening,),
                  Container(
                    margin: EdgeInsets.only(left: 6,right: 6),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: (){
        handle_profile_detail_nav(context);
      },
    );
  }
  void handle_profile_detail_nav(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileUserPage(statusShouCangModel: StatusShouCangModel()
          ,statusSelfModel: StatusSelfModel(),user: UserInfoDetail.fromJson(user.toJson()),),
      ),
    );
  }
}