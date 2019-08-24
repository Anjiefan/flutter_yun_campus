import 'dart:async';

import 'package:finerit_app_flutter/apps/components/gesture_focus_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_base_button_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_describe_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_finer_logo_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_password_textfield_widget.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/net_utils2.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/net_load.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/icons_route2.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePasswordChangeOverApp extends StatefulWidget {
  String code;
  @override
  State<StatefulWidget> createState() =>
      WelcomePasswordChangeOverAppState(code: code);
  WelcomePasswordChangeOverApp({Key key,this.code}):super(key:key);

}

class WelcomePasswordChangeOverAppState
    extends State<WelcomePasswordChangeOverApp> {
  final TextEditingController _controller = new TextEditingController();
  bool _obscureText = true;
  String code;
  MainStateModel model;
  WelcomePasswordChangeOverAppState({
        this.code}):super();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_controller!=null){
      _controller.dispose();
    }
  }
  bool isLogin=false;
  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainStateModel>(

        builder: (context, widget,MainStateModel model) {
          this.model=model;
          return Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Colors.white,
              body: GestureDetector(
                child: Container(
                  color: Color.fromARGB(0, 255, 255, 255),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: FractionalOffset.topCenter,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 24),
                              alignment: FractionalOffset.topLeft,
                              height: 20,
                              child: Container(),
                            ),
                            WelcomeFinerLogoWidget(),
                            WelcomeDescribeWidget(),
                            WelcomePasswordTextFieldWidget(controller: _controller
                              ,icon: MyFlutterApp2.lock
                              ,text: "密码",maxLength: 16,),
                            WelcomeBaseButtonWidget(
                                text: isLogin==false?'确定':"校验中"
                                ,callback: isLogin==false?_handleInitPassword:null
                              ,bottonColor: isLogin?Colors.grey : FineritColor.login_button,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  if(!this.mounted){
                    return;
                  }
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
              ),

          );
        }
    );

  }

  Future _handleInitPassword() async {
    String sessionToken = model.session_token;
    String objectId = model.objectId;
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isLogin=true;
    });
    NetUtil.put(
      Api.REGISTER_URL + objectId + "/",
          (data) async {
        await model.logout();
        requestToast('修改密码成功，请重新登陆！');
        setState(() {
          isLogin=false;
        });
        Navigator.pushNamedAndRemoveUntil(
            context, "/welcome", (route) => route == null);
      },
      headers: {"Authorization": "Token $sessionToken"},
      params: {"password": _controller.text,"code":code},
        errorCallBack: (data){
          setState(() {
            isLogin=false;
          });
          try{
            requestToast(HttpError.getErrorData(data).toString());
          }
          catch(e){
            requestToast(HttpError.getListErrorData(data).toString());
          }
        }

    );
    print("handle login");

  }

}
