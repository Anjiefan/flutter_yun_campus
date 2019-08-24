

import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/profile_userinfo_page.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BaseUserHead extends StatelessWidget{
  double radius;
  UserInfoBrief userInfo;
  UserInfoModel userInfoModel;
  bool isBoss=false;
  BaseUserHead({this.radius,
  this.userInfo}):super();
  @override
  Widget build(BuildContext context) {
    userInfoModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    if(userInfo!=null){
      isBoss=userInfo.isSystem;
    }
    else{
      isBoss=userInfoModel.userInfo.isSystem;
    }

    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment(0, 0),
            child: CircleAvatar(
                backgroundImage: new NetworkImage(userInfo!=null?userInfo.headImg:userInfoModel.userInfo?.headImg??''),
                radius: radius
            ),
          ),
          isBoss?Positioned(
            bottom: 0,
            left: 0,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.amber,
              child: Icon(
                FineritIcons.safe,
                color: Colors.white,
                size: 11,
              ),
            ),
          ):Container(),
        ],
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
          ,statusSelfModel: StatusSelfModel(),user: userInfo!=null?UserInfoDetail.fromJson(userInfo.toJson()):userInfoModel.userInfo,),
      ),
    );
  }
}

