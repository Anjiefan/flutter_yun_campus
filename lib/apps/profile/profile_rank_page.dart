import 'package:finerit_app_flutter/apps/profile/components/profile_head_card.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/profile_userinfo_page.dart';
import 'package:finerit_app_flutter/beans/ranting_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'components/profile_head_items.dart';
import 'components/profile_head_items_income.dart';
import 'components/profile_horizontal_divider_widget.dart';

class RankPage extends StatelessWidget{
  RantingBaseModel rantingBaseModel;
  UserAuthModel userAuthModel;
  List threeRantingDataList;
  List rantingDataList;
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    rantingBaseModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    if(loading==false){
      loadEarnRantingData();
      loading=true;
    }
    if(rantingBaseModel.rantingDataList.length<3){
      threeRantingDataList=rantingBaseModel.rantingDataList;
      rantingDataList=[];
    }
    else{
      threeRantingDataList=rantingBaseModel.rantingDataList.sublist(0,3);
      rantingDataList=rantingBaseModel.rantingDataList.sublist(3);
    }
    return Scaffold(
      appBar: new AppBar(
        leading: BackButton(
          color: Colors.grey[800],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("收入排行" ,style: TextStyle(color: Colors.grey[800])),
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.lightBlueAccent,
                    Colors.white,
                  ]),
            ),
            child: Column(
              children: <Widget>[
                new Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        margin:EdgeInsets.only(top: 15,right: MediaQuery.of(context).size.width/2-50-100,left: 10),
                        child: Text("实时排行",style: TextStyle(fontSize: 18,color: Colors.white,)),
                        width: 100,
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 10),
                        child: new Icon(
                          MyFlutterApp4.rank,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  height: 100,
                ),
                new Container(
                  padding: EdgeInsets.only(bottom: 10),
                  color: Colors.transparent,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top:30),
                        child: new HeadCard(rantingData: threeRantingDataList.length>1?threeRantingDataList[1]:null,rank: 2,),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:0),
                        child: new HeadCard(rantingData:threeRantingDataList.length>0?threeRantingDataList[0]:null,rank: 1,),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:30),
                        child: new HeadCard(rantingData: threeRantingDataList.length>2?threeRantingDataList[2]:null,rank: 3,),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: new ListView.builder(
              itemCount: rantingDataList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                   GestureDetector(
                     child:  Container(
                       child: HeadItemsIncome(rantingData: rantingDataList[index],),
                       color: Color.fromARGB(0, 255, 255, 255),
                     ),
                     onTap: (){
                       handle_profile_detail_nav(context,rantingDataList[index].user);
                     },
                   ),
                    HorizontalDivider(width: MediaQuery.of(context).size.width,),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
  void handle_profile_detail_nav(BuildContext context,var userInfo){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileUserPage(statusShouCangModel: StatusShouCangModel()
          ,statusSelfModel: StatusSelfModel(),user: UserInfoDetail.fromJson(userInfo.toJson())),
      ),
    );
  }
  void loadEarnRantingData(){
    NetUtil.get(Api.EARN_RANTING, (data) {
      var itemList = RantingDataList.fromJson(data);
      rantingBaseModel.rantingDataList=itemList.data;
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {
        'ordering':'-sum'
      }
    );
  }
}