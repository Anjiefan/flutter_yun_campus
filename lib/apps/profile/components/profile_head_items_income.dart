import 'package:finerit_app_flutter/apps/components/vip_discript_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_level_icon.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_vip_icon.dart';
import 'package:finerit_app_flutter/beans/ranting_data_bean.dart';
import 'package:flutter/material.dart';

class HeadItemsIncome extends StatelessWidget{
  RantingData rantingData;
  HeadItemsIncome({this.rantingData}):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(rantingData.user.headImg),
              radius: 15,
            ),
          ),
          new Text(rantingData.user.nickName,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
          new Container(
            margin: EdgeInsets.only(left: 5),
            child: new LevelIcon(level: rantingData.user.level.levelDesignation,iconsize: 1.1,biglevel: rantingData.user.level.bigLevelDesignation,),
          ),
          new Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                  child: Icon(Icons.attach_money,color: Colors.black45,size: 15,),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 3,right: 10),
                  child: Text(rantingData.sum.toString(),style: TextStyle(color: Colors.black45),),
                ),
                VipDiscriptWidget(levelDesignation: rantingData.user.vipInfo.levelDesignation
                  ,isAnnual: rantingData.user.vipInfo.isAnnual,isOpening: rantingData.user.vipInfo.isOpening,),
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
    );
  }

}