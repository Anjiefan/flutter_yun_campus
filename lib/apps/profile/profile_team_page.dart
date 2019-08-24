import 'package:finerit_app_flutter/apps/components/vip_discript_widget.dart';
import 'package:finerit_app_flutter/apps/components/web.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_self_tab.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_team_tab.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/profile_team_send.dart';
import 'package:finerit_app_flutter/beans/team_info_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:finerit_app_flutter/commons/dicts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/profile_head_items.dart';
import 'components/profile_horizontal_divider_widget.dart';
import 'components/proflie_vip_icon.dart';

class ProfileTeamPage extends StatefulWidget{
  UserInfoDetail user;
  InviteBaseFirst inviteBaseFirst;
  InviteBaseSecond inviteBaseSecond;
  ProfileTeamPage({Key key
    ,this.user,this.inviteBaseFirst,this.inviteBaseSecond}):super(
      key:key
  );
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileTeamPageState(
        user: user,
        inviteBaseSecond: inviteBaseSecond,
        inviteBaseFirst: inviteBaseFirst
    );
  }

}

class ProfileTeamPageState extends State<ProfileTeamPage> with SingleTickerProviderStateMixin{
  static const CHANNEL_SHARE=
  const MethodChannel("com.finerit.campus/share/invoke");
  UserAuthModel userAuthModel;
  TeamBaseModel teamBaseModel;
  InviteBaseFirst inviteBaseFirst;
  InviteBaseSecond inviteBaseSecond;
  UserInfoModel userInfoModel;
  TabController _tabController;
  ProfileTeamPageState({Key key,this.inviteBaseFirst,this.inviteBaseSecond,
    this.user}):super();
  UserInfoDetail user;
  String user_id;
  bool loading=false;
  bool hasFather=false;
  TextEditingController controller=TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
    if(controller!=null){
      controller.dispose();
    }
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
      userInfoModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      teamBaseModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loadTeamData();
      loading=true;
    }
    if(teamBaseModel.teamInfo==null){
      hasFather=false;
    }
    else if(teamBaseModel.teamInfo.data.length==0){
      hasFather=false;
    }
    else{
      hasFather=true;
    }
    // TODO: implement build
    return Scaffold(
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
                  Positioned(
                    top: 30,
                    right: 0,
                    child:Row(
                      children: <Widget>[
                        Container(
                          child: FlatButton.icon(onPressed:(){ _handle_guide_detail('yin_liu', '引流指南');}, icon: Icon(Icons.camera,color: Colors.white,), label: Text('引流指南',style: TextStyle(color: Colors.white),),),
                        ),
                        Container(
                          child: FlatButton.icon(onPressed: _handle_share, icon: Icon(Icons.share,color: Colors.white,), label: Text('邀请队友',style: TextStyle(color: Colors.white),),),
                        ),
                      ],
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
                        NetworkImage(userInfoModel.userInfo.headImg),
                        backgroundColor: Colors.white,
                        radius: 58,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 150,
                    top: 22,
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            userInfoModel.userInfo.nickName,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          margin: EdgeInsets.only(right: 10),
                        ),
//                        GestureDetector(
//                          child: Icon(Icons.camera,color: Colors.white,),
//                          onTap: (){
//                            _handle_guide_detail('yin_liu', '引流指南');
//                          },
//                        ),
//                        GestureDetector(
//                          child: Text("引流指南",style: TextStyle(fontSize: 13,color: Colors.white),),
//                          onTap: (){
//                            _handle_guide_detail('yin_liu', '引流指南');
//                          },
//                        )
                      ],
                    ),

                  ),
                  Positioned(
                    left: 150,
                    top: 60,
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "${userInfoModel.userInfo.level?.levelDesignation}",
                            style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18),
                          ),
                          margin: EdgeInsets.only(right: 10),
                        ),
                        GestureDetector(
                          child: Icon(Icons.notifications_active),
                          onTap: (){
                            handle_nav_profile_send();
                          },
                        ),
                        GestureDetector(
                          child: Text("团队通知",style: TextStyle(fontSize: 13),),
                          onTap: (){
                            handle_nav_profile_send();
                          },
                        )

                      ],
                    ),

                  ),
                  Positioned(
                    left: 105,
                    top: 78,
                    child:VipDiscriptWidget(levelDesignation: "${userInfoModel.userInfo.vipInfo?.levelDesignation}"
                      ,isAnnual: userInfoModel.userInfo.vipInfo.isAnnual,isOpening: userInfoModel.userInfo.vipInfo.isOpening,),

                  ),
                ],
              ),

              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 5,top: 10,left: 15),
                child: new Text("我的邀请者",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
              ),
              Container(
                alignment: Alignment.center,
                height: 70,
                width: MediaQuery.of(context).size.width-30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:
                  [BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 0),
                      blurRadius: 6.0,
                      spreadRadius: 2.0),],
                ),
                child: hasFather==false?Container(
                  padding: EdgeInsets.only(left: 25,right: 25),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:  TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: '填写邀请人的邀请码',
                            contentPadding: EdgeInsets.all(5),
                            errorBorder:UnderlineInputBorder(
                              borderSide:
                              BorderSide( width: 0.5,color: Colors.white),

                            ),
                            disabledBorder:UnderlineInputBorder(
                              borderSide:
                              BorderSide( width: 0.5,color: Colors.white),

                            ),
                            enabledBorder:UnderlineInputBorder(
                              borderSide:
                              BorderSide( width: 0.5,color: Colors.white),

                            ),
                            focusedBorder:UnderlineInputBorder(
                              borderSide:
                              BorderSide( width: 0.8,color: Colors.white),

                            ),
                            border:UnderlineInputBorder(
                              borderSide:
                              BorderSide(width: 0.5,color: Colors.white),

                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(left: 8,right: 8,top: 6,bottom: 6),
                          child: Text('确定'),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow:
                            [BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 0),
                                blurRadius: 6.0,
                                spreadRadius: 1.0),],
                          ),
                        ),
                        onTap: (){
                          handle_init_father_invite();
                        },
                      )

                    ],
                  ),
                )
                    :new Container(
                  child: HeadItems(user: teamBaseModel.teamInfo.data[0].user,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width*0.1
                    ,right: MediaQuery.of(context).size.width*0.1),
                child: new TabBar(
                    indicatorColor: Colors.lightBlueAccent,
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.black38,
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: new EdgeInsets.only(bottom: 0.0),
                    tabs: <Widget>[
                      Tab(text: '一级队员(${teamBaseModel.teamInfo?.firstNum??0})人',),
                      Tab(text: '二级队员(${teamBaseModel.teamInfo?.secondNum??0})人',),
                    ]),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.2
                    ))
                ),
              ),
              Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height-370,
                    child: new TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        ScopedModel<InviteBaseModel>(
                          model:inviteBaseFirst,
                          child: ProfileFirstTab(),
                        ),
                        ScopedModel<InviteBaseModel>(
                          model:inviteBaseSecond,
                          child: ProfileSecondTab(),
                        ),
                      ],
                    )
                ),
              ),



            ],
          ),
        )


    );
  }
  void handle_nav_profile_send(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSend(),
      ),
    );
  }
  void loadTeamData(){
    NetUtil.get(Api.TEAM, (data) {
      teamBaseModel.teamInfo=TeamInfo.fromJson(data);
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
    );
  }
  void handle_init_father_invite(){
    if(controller.text==''){
      requestToast('邀请码不可为空');
      return;
    }
    NetUtil.post(Api.TEAM, (data) {
      controller.clear();
      NetUtil.get(Api.TEAM, (data) {
        teamBaseModel.teamInfo=TeamInfo.fromJson(data);
      },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      );
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'user':controller.text},
    );
  }
  Future _handle_share() async{
    var event=await CHANNEL_SHARE.invokeMethod("doShare",[userAuthModel.objectId]);
    if(event=="-1"){
      print("转发失败");
      return ;
    }
    String task=Dicts.TASK_STARE_CHIVE[event];
    if(task==null){
      return ;
    }
    NetUtil.get(Api.SHARE, (data) {
      print(data);
      print("分享成功！");
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {"taskid":task},
    );
  }
  void _handle_guide_detail( String type, String title) {
    print(type);
    NetUtil.get(Api.GUIDE_GATHER, (data) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebApp(
              url: data['url'],
              appBar: new AppBar(
                title: Text(
                  title,
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                leading: BackButton(
                  color: Colors.grey[800],
                ),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  Container(
                    child: FlatButton.icon(
                      onPressed: () async {
                        if (await canLaunch(data['url'])) {
                          await launch(data['url']);
                        } else {
                          throw 'Could not launch ${data['url']}';
                        }
                      },
                      icon: Icon(
                        Icons.language,
                        color: Colors.black,
                      ),
                      label: Text(
                        '浏览器打开',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );
    },
        params: {'type': type},
        headers: {"Authorization": "Token ${userAuthModel.session_token}"});
  }
}
