import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/ui.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/icons/icons_route2.dart';
import 'package:finerit_app_flutter/icons/icons_route3.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class DrawerHeader extends StatelessWidget{
  String headImg;
  String nickName;
  DrawerHeader({
    key
    ,@required this.headImg
    ,@required this.nickName
  }):super(key: key);
  @override
  Widget build(BuildContext context) {
    return new UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlueAccent,
              Colors.lightBlue,
            ]),
      ),
      accountName: new Text(
        " "+nickName,
      ),
      accountEmail: new Text(
        "",
      ),
      currentAccountPicture: BaseUserHead(radius: 36,),
      onDetailsPressed: () {},
    );
  }
}

class CommonDrawer extends StatefulWidget{
  CommonDrawer({
    Key key,
  }):super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommonDrawerState();
  }
}


class CommonDrawerState extends State<CommonDrawer>{
  bool loading=false;
  UserAuthModel userAuthModel;
  MainStateModel model;
  CommonDrawerState({
    key
  }):super();
  Future initMoneyInfo() async {
    NetUtil.get(Api.USER_INFO+userAuthModel.objectId+'/', (data) {
      UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
      model.userInfo=userInfo;
    }, headers: {"Authorization": "Token ${userAuthModel.session_token}"});
  }
  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainStateModel>(
        builder: (context, widget,MainStateModel model){

          if(loading==false){
            userAuthModel=model;
            this.model=model;
            initMoneyInfo();
            loading=true;
          }
          return new ListView(padding: const EdgeInsets.only(), children: <Widget>[
            DrawerHeader(headImg: model.userInfo != null ? model.userInfo.headImg : ""
              ,nickName: model.userInfo != null ? model.userInfo.nickName: ""),
            new ListTile(
              leading: new CircleAvatar(
                  child: new Icon(FineritIcons.wallet2,size: 30,),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black),
              title: new Text('我的钱包'),
              subtitle: new Text("当前余额：${model.userInfo != null ?model.userInfo.money:0.0} 凡尔币"),
              onTap: ()  {
                handleMoney(context,userAuthModel);
              },
            ),
            new ListTile(
                leading: new CircleAvatar(
                    child: new Icon(MyFlutterApp3.unlock),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black),
                title: new Text('修改密码'),
                onTap: () async {
//                  Navigator.pushNamed(context, "/changepassword");
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/changepassword", (route) => route == null);
                }
            ),
            new ListTile(
                leading: new CircleAvatar(
                    child: new Icon(MyFlutterApp3.alteruser),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black),
                title: new Text('切换账号'),
                onTap: () async {
                  await model.logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/welcome", (route) => route == null);
                }
            ),
          ]);
        }
    );


  }
}