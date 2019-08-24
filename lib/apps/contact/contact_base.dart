import 'dart:convert';
import 'dart:io';
import 'package:finerit_app_flutter/apps/components/message_point_widget.dart';
import 'package:finerit_app_flutter/apps/contact/components/contact_user_card_widget.dart';
import 'package:finerit_app_flutter/apps/contact/components/index_bar.dart';
import 'package:finerit_app_flutter/apps/contact/components/suspension_listview.dart';
import 'package:finerit_app_flutter/apps/contact/contact_request_page.dart';
import 'package:finerit_app_flutter/apps/contact/contact_search_friend.dart';
import 'package:finerit_app_flutter/apps/contact/models/contact_model.dart';
import 'package:finerit_app_flutter/apps/im/im_base.dart';
import 'package:finerit_app_flutter/apps/im/im_utils.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/profile_userinfo_page.dart';
import 'package:finerit_app_flutter/beans/friend_data_bean.dart';
import 'package:finerit_app_flutter/beans/friend_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/commons/ui.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactApp extends StatefulWidget {
  GetRequestModel getRequestModel;
  SendRequestModel sendRequestModel;
  FriendModel friendModel;
  MethodChannel platformChannel;
  ContactApp({Key key,this.getRequestModel,this.sendRequestModel,this.friendModel, this.platformChannel}):super(key:key);
  @override
  State<StatefulWidget> createState() => ContactAppState(platformChannel: platformChannel, getRequestModel: getRequestModel,sendRequestModel: sendRequestModel,friendModel: friendModel);
}

class ContactAppState extends State<ContactApp> {
  static const CHANNEL_UNIFIED_INVOKE = const MethodChannel("com.finerit.campus/unified/invoke");
  GetRequestModel getRequestModel;
  SendRequestModel sendRequestModel;
  FriendModel friendModel;
  UserAuthModel userAuthModel;
  PushMessageModel pushMessageModel;
  int _suspensionHeight = 40;
  int _itemHeight = 60;
  String _hitTag = "";
  MethodChannel platformChannel;
  ContactAppState({Key key,this.getRequestModel,this.sendRequestModel,this.friendModel, this.platformChannel}):super();

  String headImg = "";
  String nickName = "";
  @override
  void initState() {
    super.initState();

  }
  bool loading=false;


  Widget _buildSusWidget(String susTag) {
    return Container(
      padding: EdgeInsets.only(left: 15.0),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Text(
            '$susTag',
            textScaleFactor: 1.2,
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(FriendData model) {
    String susTag = model.getSuspensionTag();
    return Container(
      child: Column(
        children: <Widget>[
          Offstage(
            offstage: model.isShowSuspension != true,
            child: _buildSusWidget(susTag),
          ),
          ContactUserCard(user:UserInfoDetail.fromJson(model.friendUser.toJson()) ,height: _itemHeight.toDouble(),callback: (){
//            if(Platform.isIOS){
//              requestToast('聊天功能IOS版本尚未上线，可使用安卓端');
//            }
//            else{
//              platformChannel.invokeMethod("openChatKit", [userAuthModel.objectId, model.friendUser.id]);
//            }
            handle_im_go(context, userAuthModel.objectId,model.friendUser.id,false);
//            Navigator.push(context,
//                MaterialPageRoute(builder: (context) => ImApp.name(userAuthModel.objectId, model.friendUser.id, false))
//            );
//            if(Platform.isIOS){
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => ImApp.name(userAuthModel.objectId, model.friendUser.id, false))
//              );
////                                    requestToast('聊天功能IOS版本尚未上线，可使用安卓端');
//            }
//            else{
//              CHANNEL_UNIFIED_INVOKE.invokeMethod("openChatKit", [userAuthModel.objectId+'～00', model.friendUser.id+'～00']);
//            }
//            Navigator.push(context,
//                MaterialPageRoute(builder: (context) => ImApp.name(userAuthModel.objectId, model.friendUser.id, false))
//            );
          },),
        ],
      ),
    );
  }
  void handle_to_profile_nav(UserInfoDetail user){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileUserPage(statusShouCangModel: StatusShouCangModel()
          ,statusSelfModel: StatusSelfModel(),user: user,),
      ),
    );
  }
  Widget getHeightItems(Icon icon, String name) {
    return new Container(
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                height: 50,
                child: new Row(
                  children: <Widget>[
                    icon,
                    Padding(
                      padding: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: new Text(name, style: TextStyle(color: FineritColor.color1_normal),),
                    )
                  ],
                ),
              ),
              pushMessageModel.addFriendNum!=0?GlobalMessagePoint(
                num: pushMessageModel.addFriendNum,
              ):Container()
            ],
          ),

          new Container(
            margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
            height: 0.5,
            color: const Color(0xffebebeb),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(MainStateModel model) {
    return AppBar(
      title: Text("通讯录", style: FineritStyle.style3,),
      centerTitle: true,
      leading: BackButton(color: Colors.black,),
      backgroundColor: Colors.white,
      actions: <Widget>[
        IconButton(
          tooltip: "添加好友",
          icon: const Icon(MyFlutterApp.create2,size: 15,color: Colors.black),
          color: FineritColor.color1_normal,
          onPressed: _handleAddFriend,
        ),
      ],
    );
  }

  void loadUserFriendData(){
    NetUtil.get(Api.FRIENDS, (data) {
      var itemList = FriendDataList.fromJson(data);
      friendModel.friendList=itemList.data;
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
    );
  }
  void _handle_request_nav(){
    pushMessageModel.addFriendNum=0;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactRequestPage(getRequestModel:getRequestModel,sendRequestModel:sendRequestModel),
      ),
    );
  }
  void _handleAddFriend() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScopedModel(model: ContactSearchUserModel(), child: ContactSearchFriendPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    userAuthModel=model;
    pushMessageModel=model;
    if(loading==false){
      loadUserFriendData();
      loading=true;
    }
    return Scaffold(
      appBar: _buildAppBar(model),
      body: QuickSelectListView(
        data: friendModel.friendList,
        itemBuilder: (context, model){
          return _buildListItem(model);
        },
        isUseRealIndex: true,
        itemHeight: _itemHeight,
        suspensionHeight: _suspensionHeight,
        header: QuickSelectListViewHeader(
            height: 60,
            builder: (context) {
              return Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: _handle_request_nav,
                      child: getHeightItems(
                          Icon(
                            MyFlutterApp.addfriend,
                            size: 20,
                            color: FineritColor.color1_normal,
                          ),
                          '新的朋友'),
                    ),

//                    getHeightItems(Icon(MyFlutterApp.chart, size: 20, color: FineritColor.color1_normal,), '群聊'),
                  ],
                ),
              );
            }),
        indexBarBuilder: (BuildContext context, List<String> tags,
            IndexBarTouchCallback onTouch) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey[300], width: .5)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: IndexBar(
                data: tags,
                itemHeight: 14,
                onTouch: (details) {
                  onTouch(details);
                },
              ),
            ),
          );
        },
        indexHintBuilder: (context, hint) {
          return Container(
            alignment: Alignment.center,
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.blue[700].withAlpha(200),
              shape: BoxShape.circle,
            ),
            child: Text(hint,
                style: TextStyle(color: Colors.white, fontSize: 30.0)),
          );
        },
      ),
    );
  }
}
