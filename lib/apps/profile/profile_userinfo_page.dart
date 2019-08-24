import 'dart:io';

import 'package:finerit_app_flutter/apps/bbs/components/bbs_user_head_wighet.dart';
import 'package:finerit_app_flutter/apps/components/vip_discript_widget.dart';
import 'package:finerit_app_flutter/apps/im/im_base.dart';
import 'package:finerit_app_flutter/apps/im/im_utils.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_self_tab.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_svip_icon.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/global_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import 'components/proflie_vip_icon.dart';
import 'profile_edit_info_page.dart';

class ProfileUserPage extends StatefulWidget{
  StatusShouCangModel statusShouCangModel;
  StatusSelfModel statusSelfModel;
  UserInfoDetail user;

  ProfileUserPage({Key key
    ,this.statusShouCangModel
    ,this.statusSelfModel
    ,this.user}):super(
      key:key
  );
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileUserPageState(
        statusShouCangModel: statusShouCangModel,
        statusSelfModel: statusSelfModel,
        user: user
    );
  }

}

class ProfileUserPageState extends State<ProfileUserPage> with SingleTickerProviderStateMixin{
  StatusShouCangModel statusShouCangModel;
  StatusSelfModel statusSelfModel;
  static const CHANNEL_UNIFIED_INVOKE = const MethodChannel("com.finerit.campus/unified/invoke");
  UserAuthModel userAuthModel;
  TabController _tabController;
  final TextEditingController _controller = new TextEditingController();
  ProfileUserPageState({Key key,this.statusShouCangModel
    ,this.statusSelfModel
    ,this.user}):super();
  UserInfoDetail user;
  String user_id;
  bool loading=false;
  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    if(_controller!=null){
      _controller.dispose();
    }
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }
  @override
  Widget build(BuildContext context) {

    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      user_id=user.id;
      init_userinfo();
      loading=true;
    }
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body:Container(
          child: Column(
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.lightBlueAccent,
                  ),
                  Positioned(
                    top: 30,
                    left: 0,
                    child: BackButton(color: Colors.white,),
                  ),
                  userAuthModel.objectId!=user.id?new Positioned(
                    top: 40,
                    right: 5,
                    child:  PopupMenuButton<String>(
                      padding: EdgeInsets.all(0),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      onSelected: (String value) {
                        switch(value){
                          case "举报":
                            handle_report_user();
//                            if(user.id==userAuthModel.objectId){
//                              requestToast('无法举报自己');
//                              return;
//                            }
//                            handle_report();
                            break;
                          case '屏蔽':
                            handle_shield_user();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<String>>[
                        const PopupMenuItem(
                          value: "举报",
                          child: Text("举报"),
                        ),
                        const PopupMenuItem(
                          value: "屏蔽",
                          child: Text("屏蔽"),
                        ),

                      ],
                    ),
                  ):new Positioned(
                      top: 40,
                      right: 10,
                      child:  GestureDetector(
                        child: new Container(
                          padding: EdgeInsets.only(bottom: 2),
                          alignment: Alignment(0, 0),
                          child: Text("编辑资料",style: TextStyle(fontSize: 14,color: Colors.lightBlueAccent),),
                          width: 70,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                        ),
                        onTap: (){
                          _handle_edit_user();
                        },
                      )
                  ),
                ],
              ),
              new Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        color: Colors.lightBlueAccent,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 35,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundImage:
                        NetworkImage(user.headImg),
                        backgroundColor: Colors.white,
                        radius: 58,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 150,
                    top: 22,
                    child: Text(
                      user.nickName,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Positioned(
                    left: 150,
                    top: 60,
                    child: new Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            user.level.levelDesignation,
                            style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18),
                          ),
                          margin: EdgeInsets.only(right: 5),
                        ),
                        Text("${user.id.substring(0,4)}****",style: new TextStyle(fontSize: 12),),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            padding: EdgeInsets.only(bottom: 2.5,top: 1,left: 2.5,right: 1.5),
                            child: new Text(" 复制邀请码 ",style: TextStyle(color: Colors.black26,fontSize: 10)),
                            decoration: new BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onTap: handle_copy_id,
                        )
                      ],
                    ),

                  ),
                  Positioned(
                    left: 105,
                    top: 78,
                    child:
                    VipDiscriptWidget(levelDesignation: user.vipInfo.levelDesignation
                      ,isAnnual: user.vipInfo.isAnnual,isOpening: user.vipInfo.isOpening,),
                  ),

                ],
              ),
              new Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width*0.2
                    ,right: MediaQuery.of(context).size.width*0.2),
                child: new TabBar(
                    indicatorColor: Colors.lightBlueAccent,
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.black38,
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: new EdgeInsets.only(bottom: 0.0),
                    tabs: <Widget>[
                      Tab(text: '公告',),
                      Tab(text: '收藏',),
                    ]),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.4
                    ))
                ),
              ),
              new Container(
                  height: MediaQuery.of(context).size.height-330,
                  child: new TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      ScopedModel<BaseStatusModel>(
                        model:statusSelfModel,
                        child: ProfileShoucangTab(userid: user_id,),
                      ),
                      ScopedModel<BaseStatusModel>(
                        model:statusShouCangModel,
                        child: ProfileGuangboTab(userid: user_id,),
                      ),
                    ],
                  )
              ),
              Expanded(
                  child:
//                user.id==userAuthModel.objectId?
                  new Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 20,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(top: BorderSide(
                                  color: Colors.grey,
                                  width: 0.3
                              ))
                          ),
                          padding: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  width: 120,
                                  margin: EdgeInsets.only(right: 20),
                                  padding: EdgeInsets.only(bottom: 5),
                                  alignment: Alignment.center,
                                  child: Text("添加好友",style: TextStyle(color: Colors.white,fontSize: 20),),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                                onTap: (){
                                  handle_add_friend_request();
                                },
                              ),

                              GestureDetector(
                                child: Container(
                                  width: 120,
                                  padding: EdgeInsets.only(bottom: 5),
                                  alignment: Alignment.center,
                                  child: Text("发送消息",style: TextStyle(color: Colors.white,fontSize: 20),),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                                onTap: (){
                                  if(user.id==userAuthModel.objectId){
                                    requestToast('无法和自己聊天');
                                    return;
                                  }
                                  handle_im_go(context, userAuthModel.objectId,user.id,false);
//                                  Navigator.push(context,
//                                      MaterialPageRoute(builder: (context) => ImApp.name(userAuthModel.objectId, user.id, false))
//                                  );
//                                  if(Platform.isIOS){
//                                    Navigator.push(context,
//                                        MaterialPageRoute(builder: (context) => ImApp.name(userAuthModel.objectId, user.id, false))
//                                    );
//
////                                    requestToast('聊天功能IOS版本尚未上线，可使用安卓端');
//                                  }
//                                  else{
//                                    CHANNEL_UNIFIED_INVOKE.invokeMethod("openChatKit", [userAuthModel.objectId+'～00', user.id+'～00']);
//                                  }


//                                  CHANNEL_UNIFIED_INVOKE.invokeMethod("openChatKit", [userAuthModel.objectId, user.id]);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
//                      :Container(),
              ),


            ],
          ),
        )


    );
  }
  void handle_add_friend_request(){
    NetUtil.post(Api.FRIEND_REQUESTS, (data) {
      requestToast('请求成功，等待对方回复');
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'request_to_user': user.id},
    );
  }
  void init_userinfo(){
    NetUtil.get(Api.USER_INFO+user_id+'/', (data) {
      UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
      if(!this.mounted){
        return;
      }
      setState(() {
        user=userInfo;
      });
    }, headers: {"Authorization": "Token ${userAuthModel.session_token}"});
  }
  void handle_report_user(){
    if(user.id==userAuthModel.objectId){
      requestToast('我举报我自己？主人三思呀');
      return;
    }
    showGeneralDialog(
      context: context,
      pageBuilder: (context, a, b) => handle_report(),
      barrierDismissible: false,
      barrierLabel: '举报',
      transitionDuration: Duration(milliseconds: 400),
    );

  }
  void _handle_edit_user(){
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserInfoPage(),
      ),
    );

  }
  Widget handle_report(){
    return AlertDialog(
      title: Text('举报'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: (MediaQuery.of(context).size.height / 2) * 0.4,
        child: Column(

          children: <Widget>[
            UserHead(username: user.nickName
              ,sincePosted: ''
              ,headImg: user.headImg,
              userInfo: UserInfoBrief.fromJson(user.toJson()),),
            new Theme(

              data: ThemeData(
                hintColor: Colors.black12,
              ),
              child:
              new Container(

                decoration: new BoxDecoration(
                  border: new Border.all(width: 2.0, color: Colors.black12),
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                ),
                height: 80,
                width: MediaQuery.of(context).size.width*1,
                child:TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: new InputDecoration.collapsed(
                    hintText: '举报原因...',
                  ),
                  cursorColor:Colors.black38,
                  style:TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('确认'),
          onPressed: () async {
            handle_send_reportinfo();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
  void handle_shield_user(){
    if(user.id==userAuthModel.objectId){
      requestToast('我屏蔽我自己？？？您疯了8');
      return;
    }
    NetUtil.post(
      Api.SHIELDUSERS,
          (data) async {
      },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'shield_user':user.id},

    );
  }

  void  handle_send_reportinfo()  {
    NetUtil.post(Api.REPORT_USER, (data) {
      _controller.clear();
      requestToast("举报成功，我们将会积极处理！");
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'report_user':user.id,'text':_controller.text},
    );

  }
  void handle_copy_id(){
    requestToast("复制邀请码成功");
    Clipboard.setData(new ClipboardData(text: user.id));
  }
}
