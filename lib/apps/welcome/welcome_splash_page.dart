import 'package:finerit_app_flutter/apps/welcome/welcome_nickname_avatar_page.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SplashApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashAppState();
}

class SplashAppState extends State<SplashApp> {
  final PageController _pageController = PageController();
  UserInfoModel userInfoModel;
  bool ifLogin = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainStateModel>(
      builder: (context, widget, UserAuthModel model) {
        userInfoModel =
            ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
        ifLogin = model.isLogin;
        return Scaffold(
          body: PageView(
            children: <Widget>[
              Stack(children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset("assets/welcome/cover1.png"))
              ]),
              Stack(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset("assets/welcome/cover2.png")),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 60,
                    bottom: 15,
                    child: Container(
                      width: 120,
                      height: 40,
                      child: InkWell(
                        onTap: () {
                          _handleEnter(model);
                        },
                        child:new Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4.0), //只是为了给 Text 加一个内边距，好看点~
                          child: Text(
                            "进入云智校",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                          decoration: BoxDecoration(
                            color:Colors.lightBlueAccent,
                            boxShadow:
                            [BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 0),
                                blurRadius: 6.0,
                                spreadRadius: 2.0),],
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            controller: _pageController,
          ),
        );
      },
    );
  }

  void _handleEnter(UserAuthModel model) {
    model.isFirst=false;
    print("_handleEnter");
    if (ifLogin == null) {
      print("ifLogin=null");
      return;
    }
    if (model.objectId != null &&
        model.password != null &&
        userInfoModel.userInfo == null) {
      //未初始化信息
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeNicknameAvatarApp(),
        ),
      );
    }
    if (ifLogin &&
        model.objectId != null &&
        model.password == null &&
        userInfoModel.userInfo == null) {
      //未设置密码
      Navigator.of(context).pushReplacementNamed('/welcome');
    }

    if (ifLogin) {
      if (model.state == CommonPageStatus.RUNNING &&
          userInfoModel.userInfo != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (model.state == CommonPageStatus.RUNNING && !ifLogin) {
        Navigator.of(context).pushReplacementNamed('/welcome');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }
}
