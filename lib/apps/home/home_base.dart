import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:finerit_app_flutter/apps/bbs/bbs_base.dart';
import 'package:finerit_app_flutter/apps/bbs/model/bbs_model.dart';
import 'package:finerit_app_flutter/apps/components/common_drawer_widget.dart';
import 'package:finerit_app_flutter/apps/contact/contact_base.dart';
import 'package:finerit_app_flutter/apps/contact/models/contact_model.dart';
import 'package:finerit_app_flutter/apps/course/course_base.dart';
import 'package:finerit_app_flutter/apps/course/course_guide.dart';
import 'package:finerit_app_flutter/apps/home/components/home_message_point_widget.dart';
import 'package:finerit_app_flutter/apps/home/job_web_app_base.dart';
import 'package:finerit_app_flutter/apps/message/message_base.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/profile_base_page.dart';
import 'package:finerit_app_flutter/beans/Invite_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/commuity_message_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/experience_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/friend_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/message_data_bean.dart';
import 'package:finerit_app_flutter/beans/message_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/ranting_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/shied_user_list_bean.dart';
import 'package:finerit_app_flutter/beans/team_info_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/beans/vip_pay_info_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/push_constant.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/database/daos/message_data_dao.dart';
import 'package:finerit_app_flutter/database/database.dart';
import 'package:finerit_app_flutter/database/models/message_data_model.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeApp extends StatefulWidget {
  static const routeName = "/home";

  @override
  State<StatefulWidget> createState() => HomeAppState();
}

class HomeAppState extends State<HomeApp> with SingleTickerProviderStateMixin {
  var _textController = new TextEditingController();
  bool loading = false;
  MainStateModel model;
  static const CHANNEL_PUSH_CONFIRM =
  const EventChannel("com.finerit.campus/push/confirm");

  static const CHANNEL_PUSH_REGISTER =
  const MethodChannel("com.finerit.campus/push/register");

  static const CHANNEL_PUSH_INITIALIZE =
  const MethodChannel("com.finerit.campus/push/initialize");

  /**
   * 后续的全部MethodChannel均使用该Channel
   */
  static const CHANNEL_UNIFIED_INVOKE =
  const MethodChannel("com.finerit.campus/unified/invoke");
  static GlobalKey<ScaffoldState> scaffoldKey;
  int _selectedIndex = 2;

  StatusSystemdModel statusSystemdModel;
  StatusCommonModel statusCommonModel;
  StatusShouCangModel statusShouCangModel;
  StatusSelfModel statusSelfModel;
  FriendModel friendModel;
  InviteBaseFirst inviteBaseFirst;
  InviteBaseSecond inviteBaseSecond;
  List _bodyOptions;
  @override
  void initState() {
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    statusSystemdModel = StatusSystemdModel();
    statusCommonModel = StatusCommonModel();
    statusShouCangModel=StatusShouCangModel();
    statusSelfModel=StatusSelfModel();
    friendModel=FriendModel();
    inviteBaseFirst=InviteBaseFirst();
    inviteBaseSecond=InviteBaseSecond();


    //加载用户信息
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_textController != null) {
      _textController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading == false) {
      model = ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
      _bodyOptions = [

        BBSApp(
          statusSystemdModel: statusSystemdModel,
          statusCommonModel: statusCommonModel,
        ),
        CourseApp(),

        JobWebApp(url: 'https://hwapp.finerit.com/job/qqz_jobs_data/?session_token=${model.session_token}',),
        MessageApp(
          platformChannel: CHANNEL_UNIFIED_INVOKE,
          friendModel: friendModel,
        ),
        ProfileApp(
            statusShouCangModel:statusShouCangModel,
            statusSelfModel:statusSelfModel,
            inviteBaseFirst:inviteBaseFirst,
            inviteBaseSecond:inviteBaseSecond

        ),
      ];
      loadUserInfo();
      loadDetailUserInfo();
      loadUserFriendData();
      loadUserMessage();
      setUserMessageTimer();
      setUserOnlineTimer();
      loadShieldUserData();
      loadEarnRantingData();
      loadCommunityMessage();
      loadInviteData();
      loadTeamData();
      initEarnInfo();
      if(Platform.isIOS){
        initIosShow();
      }
      loading = true;

    }
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: _bodyOptions.elementAt(_selectedIndex),
      ),
      drawer: new Drawer(
          child: CommonDrawer()
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            primaryColor: FineritColor.color1_pressed,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: new TextStyle(color: FineritColor.color1_normal))),
        child:
        new BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Stack(
                  children: <Widget>[
                    Icon(
                        MyFlutterApp4.addressbook
                    ),
                    MessagePointWidget(num: model.friend),
                  ],
                ),
                title: Text('公告',style: TextStyle(fontSize: 12))
            ),
            BottomNavigationBarItem(
                icon: Icon(MyFlutterApp4.playnext), title: Text('代课',style: TextStyle(fontSize: 12))),

            BottomNavigationBarItem(
              icon: Icon(MyFlutterApp4.house),
              title: Text("兼职",style: TextStyle(fontSize: 12)),
            ),
            BottomNavigationBarItem(
                icon: Stack(
                  children: <Widget>[
                    Icon(
                      MyFlutterApp4.message
                    ),
                    MessagePointWidget(num: model.message),
                  ],
                ),
                title: Text('消息',style: TextStyle(fontSize: 12))),
            BottomNavigationBarItem(
                icon: Stack(
                  children: <Widget>[
                    Icon(MyFlutterApp4.mine),
                    MessagePointWidget(num: model.profile,),
                  ],
                ),
                title: Text('我的',style: TextStyle(fontSize: 12))),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
  Future _onItemTapped(int index) async {
    if(!this.mounted){
      return;
    }
    switch(index){
      case 1:
        model.friend=0;
        break;
      case 3:
        model.message=0;
        break;
      case 4:
        model.profile=0;
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }
  _onError(Object error) {}

  _onRegisterError(Object error) {}

  //TODO 处理收到的推送消息
  Future _onPushEvent(Object event) async {
    print("_onPushEvent");
    //接收原生传回的推送字符串（JSON-like）
    String receivedJsonStr = event as String;
    print("receivedJsonStr=" + receivedJsonStr);
    Map receivedJsonMap = json.decode(receivedJsonStr);

    //将Bean转换为数据库需要的Model
    switch(receivedJsonMap['push_type']){
      case PushConstant.MESSAGE_PUSH:
        MessageData messageData = MessageData.fromJson(receivedJsonMap);
        model.addMessageBegin(messageData);
        model.message=1;
        break;
      case PushConstant.ADD_FRIEND:
        model.friend=1;
        model.addFriendNum=model.addFriendNum+1;
        break;
      case PushConstant.INCOME_RANKING:
        model.profile=1;
        model.ranking=1;
        break;

    }


  }
  void loadDetailUserInfo(){
    NetUtil.get(Api.USER_INFO+model.objectId+'/', (data) {
      UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
      model.userInfo=userInfo;

    }, headers: {"Authorization": "Token ${model.session_token}"}
        ,);
  }
  void loadCommunityMessage(){
    NetUtil.get(Api.TEAM, (data) {
      model.teamInfo=TeamInfo.fromJson(data);
    },
      headers: {"Authorization": "Token ${model.session_token}"},
    );
  }
  void loadUserFriendData(){
    NetUtil.get(Api.FRIENDS, (data) {
      var itemList = FriendDataList.fromJson(data);
      friendModel.friendList=itemList.data;
    },
      headers: {"Authorization": "Token ${model.session_token}"},
    );
  }
  void loadTeamData(){
    NetUtil.get(Api.COMMUNITY_MESSAGE, (data) {
      model.communityMessageDataList=CommunityMessageDataList.fromJson(data).data;
    },
      headers: {"Authorization": "Token ${model.session_token}"},
    );
  }
  void loadVipPayData(){
    NetUtil.get(Api.VIP_PAYINFO, (data) {
      model.vipPayInfo=VipPayInfo.fromJson(data);
    },
      headers: {"Authorization": "Token ${model.session_token}"},
    );
  }
  void loadInviteData(){
    NetUtil.get(Api.TEAM_INVITE, (data) {
      var itemList = InviteDataList.fromJson(data);
      inviteBaseFirst.inviteDataList=itemList.data;
    },
      headers: {"Authorization": "Token ${model.session_token}"},
      params: {'type':'1'},
    );
    NetUtil.get(Api.TEAM_INVITE, (data) {
      var itemList = InviteDataList.fromJson(data);
      inviteBaseSecond.inviteDataList=itemList.data;
    },
      headers: {"Authorization": "Token ${model.session_token}"},
      params: {'type':'2'},
    );
  }
  void loadShieldUserData(){
    NetUtil.get(Api.SHIELDUSERS, (data) {
      var itemList = ShieldUserDataList.fromJson(data);
      model.shieldUserList=itemList.data;
    },
      headers: {"Authorization": "Token ${model.session_token}"},
      params: {'page':1},
    );
  }
  void loadEarnRantingData(){
    NetUtil.get(Api.EARN_RANTING, (data) {
      var itemList = RantingDataList.fromJson(data);
      model.rantingDataList=itemList.data;
    },
      headers: {"Authorization": "Token ${model.session_token}"},
      params: {
        'ordering':'-sum'
      }
    );
  }
  void loadUserExperienceData(){
    NetUtil.get(Api.USER_EXPERIENCE, (data) {
      var itemList = ExperienceDataList.fromJson(data);
      model.experienceDataList=itemList.data;
    },
        headers: {"Authorization": "Token ${model.session_token}"},
        params: {
          'ordering':'-date'
        }
    );
  }
  Future loadUserInfo() async {
    if (loading == false) {
      CHANNEL_PUSH_INITIALIZE.invokeMethod("initializeLCPush");
      CHANNEL_PUSH_REGISTER.setMethodCallHandler((handler) {
        if (handler.method == "updateInstallationId") {
          CHANNEL_PUSH_CONFIRM
              .receiveBroadcastStream()
              .listen(_onPushEvent, onError: _onError);
          String installationId = handler.arguments as String;
          print("session_token=${model.session_token}");
          NetUtil.post(Api.UPDATE_USER_INSTALLATION_ID, (data) {
            print("UPDATE_USER_INSTALLATION_ID: $installationId");
          },
              params: {'installation_id': installationId},
              headers: {"Authorization": "Token ${model.session_token}"});
        }
      });
    }
  }
  void loadUserMessage(){
    NetUtil.get(Api.MESSAGES, (data) {
      var itemList = MessageDataList.fromJson(data);
      model.messagedataList=itemList.data;
    },
      headers: {"Authorization": "Token ${model.session_token}"},

    );
  }
  void initIosShow(){
    NetUtil.request(
      'http://114.116.46.204:8003/ifshowpayment3/',
          (data) {
        if(data["info"]=="false"){
          model.ifshowios=false;
        }
        else if(data["info"]=="true"){
          model.ifshowios=true;
        }
      },
      method: "get",
      headers: {"Authorization": "Token ${model.session_token}"},
    );
  }
  void initEarnInfo(){
    NetUtil.get(Api.EARN_SUM, (data) {
      model.setEarnSumData(data['yesterday_sum'], data['day_sum'], data['mouth_sum']);
    }, headers: {"Authorization": "Token ${model.session_token}"});
  }
  void setUserMessageTimer() {
    const period30 = const Duration(seconds:30);
    new Timer.periodic(period30, (Timer t)  {
      loadUserMessage();
      print("load now --");
    });
  }
  void setUserOnlineTimer() {
    const period30 = const Duration(hours: 1);
    new Timer.periodic(period30, (Timer t)  {
      get_online_experience();
    });
  }
  void get_online_experience(){
    NetUtil.get(Api.USER_ONLINE, (data) {
      requestToast(data['info']);
    }, headers: {"Authorization": "Token ${model.session_token}"});
  }
}
