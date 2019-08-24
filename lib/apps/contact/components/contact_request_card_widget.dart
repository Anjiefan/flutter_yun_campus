import 'dart:io';

import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/profile_userinfo_page.dart';
import 'package:finerit_app_flutter/beans/friend_request_data_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
class ContactRequestCard extends StatefulWidget{
  int index;
  bool relate;
  ContactRequestCard({
    key
    ,@required this.index,
    this.relate=false
  }):super(key: key);
  @override
  State<StatefulWidget> createState()=>ContactRequestCardState(index: index,relate: relate);
}

class ContactRequestCardState extends State<ContactRequestCard>{
  int index;
  FriendRequestData obj;
  UserAuthModel _userAuthModel;
  FriendRequestBaseModel friendRequestBaseModel;
  bool relate=false;
  bool loading=false;
  ContactRequestCardState({
    key
    ,this.index,
    this.relate
  }):super();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(loading==false){
      friendRequestBaseModel = ScopedModel.of<FriendRequestBaseModel>(context,rebuildOnChange: true);
      _userAuthModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    obj=friendRequestBaseModel.friendRequestList[index];
    Widget expanded_widget=null;
    if(relate==false){
      if(obj.type=='等待处理') {
        expanded_widget=Container(
          padding: EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: Text(obj.type,style: TextStyle(color: Colors.black54)),
        );
      }
      else{
        expanded_widget=Container(
          padding: EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: Text('已${obj.type}',style: TextStyle(color: Colors.black54)),
        );
      }

    }
    else{
      if(obj.type=='等待处理') {
        expanded_widget = Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                child: Text('同意'),
              ),
              onTap: () {
                handle_agree();
              },
            ),
          ],
        );
      }
      else{
        expanded_widget=Container(
          padding: EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: Text('已${obj.type}',style: TextStyle(color: Colors.black54)),
        );
      }
    }
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 10,bottom: 10),
      child: Column(
        children: <Widget>[
          Container(
            height: 6,
            width: MediaQuery.of(context).size.width * 1,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: Row(children: <Widget>[
                  BaseUserHead(
                    userInfo: obj.requestToUser,
                    radius: 25.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(obj.requestToUser.nickName),
                      ),
                      Container(
                        child: Text('已发送验证消息',style: TextStyle(color: Colors.black54),),
                      ),
                    ],
                  ),
                ],),
                onPressed: (){
                  handle_profile_detail_nav(context);
                },
              ),
              Expanded(
                child: expanded_widget,
              )
            ],
          )
        ],
      ),
    );
  }
  void handle_profile_detail_nav(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileUserPage(statusShouCangModel: StatusShouCangModel()
          ,statusSelfModel: StatusSelfModel(),user: UserInfoDetail.fromJson(obj.requestToUser.toJson()),),
      ),
    );
  }
  void handle_agree(){
    NetUtil.get(Api.ACCEPT_FRIEND_REQUEST, (data) async{
      obj.type='同意';
      friendRequestBaseModel.updateRequest(obj, index);
    },
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      params: {'id':obj.id,'type':'同意'}
    );
  }
  void handle_disagree(){
    NetUtil.get(Api.ACCEPT_FRIEND_REQUEST, (data) async{

    },
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"}, params: {'id':obj.id,'type':'拒绝'}
    );
  }

}

