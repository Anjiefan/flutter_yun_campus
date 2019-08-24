import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/apps/components/vip_discript_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_head_items.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_level_icon.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_vip_icon.dart';
import 'package:finerit_app_flutter/beans/ranting_data_bean.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:flutter/material.dart';

class HeadCard extends StatelessWidget{
  RantingData rantingData;
  int rank;
  HeadCard({this.rantingData,this.rank}):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      width: 110,
      height: 160,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200],width: 1,style: BorderStyle.solid),
        boxShadow:
        [BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 0),
            blurRadius: 3.0,
            spreadRadius: 1.0),],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          rantingData==null?Container(
            margin: EdgeInsets.only(top: 5),
            child: CircleAvatar(
              radius: 20,
              child: Image(image: AssetImage("assets/fire.png")
              ),
            ),
          ):Container(
            margin: EdgeInsets.only(top: 5),
            child: BaseUserHead(userInfo: rantingData.user,),
          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 3),
                child: Text(rantingData!=null?rantingData.user.nickName:"暂无",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black87),),
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              rantingData!=null?Container(
                margin: EdgeInsets.only(left:3,top: 3),
                child: LevelIcon(level: rantingData.user.level.levelDesignation
                  ,iconsize: 0.7,color: Colors.lightBlue,biglevel: rantingData.user.level.bigLevelDesignation,),
              ):Container(
                margin: EdgeInsets.only(left:3,top: 3),
              ),
              rantingData!=null?Container(
                margin: EdgeInsets.only(left: 3,top: 3),
                child: VipDiscriptWidget(levelDesignation: rantingData.user.vipInfo.levelDesignation
                  ,isAnnual: rantingData.user.vipInfo.isAnnual,isOpening: rantingData.user.vipInfo.isOpening,),
              ):Container(
                margin: EdgeInsets.only(left:3,top: 3),
              ),
            ],
          ),
          Container(
            child: Divider(height: 10,color: Colors.grey[200]),
            margin: EdgeInsets.only(bottom: 5),
          ),
          new Container(
              margin: EdgeInsets.only(top:0,bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FineritIcons.money,
                    size: 18,
                    color: Colors.black87,
                  ),
                  Container(width: 2,),
                  Text(rantingData!=null?rantingData.sum:'0'+" ",style:TextStyle(fontSize: 22,fontWeight: FontWeight.w300,color: Colors.black87)),
                ],
              )
          ),
          new Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("第",style: TextStyle(color: Colors.black87),),
                  Text(rank.toString(),style:TextStyle(fontSize: 18,color: Colors.lightBlue,)),
                  Text("名",style: TextStyle(color: Colors.black87),),
                ],
              )
          ),
        ],
      ),
    );
  }
}