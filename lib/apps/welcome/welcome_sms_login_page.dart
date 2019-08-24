import 'dart:async';
import 'package:finerit_app_flutter/apps/components/gesture_focus_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_base_button_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_describe_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_finer_logo_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_textfield_widget.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class WelcomeCodeLoginApp extends StatefulWidget {
  final String phone;

  @override
  State<StatefulWidget> createState() => WelcomeCodeLoginAppState(phone: phone);

  WelcomeCodeLoginApp({Key key, @required this.phone}) : super(key: key);
}

class WelcomeCodeLoginAppState extends State<WelcomeCodeLoginApp> {
  final String phone;
  TextEditingController controller=TextEditingController();
  WelcomeCodeLoginAppState({Key key, @required this.phone}) : super();

  Timer _countdownTimer;
  String _codeCountdownStr = '获取验证码';
  int _countdownNum = 59;
  bool isSent = false;
  MainStateModel model;
  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
      _codeCountdownStr = '${_countdownNum--}秒重新获取';
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr = '${_countdownNum--}秒重新获取';
          } else {
            isSent = false;
            _codeCountdownStr = '获取验证码';
            _countdownNum = 59;
            _countdownTimer.cancel();
            _countdownTimer = null;
          }
        });
      });
    });
  }

  // 不要忘记在这里释放掉Timer
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainStateModel>(

        builder: (context, widget,MainStateModel model) {
          this.model=model;
          return Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Colors.white,
              body:GestureDetector(
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
                            WelcomeTextFieldWidget(text: '手机验证码'
                              ,changeCallback: _handleVerifyCode
                              ,icon: MyFlutterApp4.iphone,maxLength: 6,
                                controller:controller),

                            WelcomeBaseButtonWidget(
                                callback:  _handleSend
                                ,bottonColor:isSent ? Colors.grey : FineritColor.login_button
                                ,text:_codeCountdownStr),
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
              )
          );
        }
    );

  }

  void _handleSend() {
    NetUtil.put(Api.LOGIN_CODE_URL, (data){
      requestToast('验证码已发送');
    }, params: {
      "phone_num": phone
    },);
    setState(() {
      isSent = true;
    });
    reGetCountdown();
  }

  void _handleVerifyCode(String text) {

    if (text.length != 6) {
      return;
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      print("verfying...");
      String code = text;
      NetUtil.post(Api.LOGIN_URL, (data) async {
        model.phone=phone;
        model.objectId=data["objectId"];
        model.login(data["session_token"]);
        NetUtil.get(Api.USER_INFO+model.objectId+'/', (data) async {
          UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
          model.userInfo=userInfo;
        }, headers: {"Authorization": "Token ${model.session_token}"},);
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => route == null);

      }, params: {'code': code, 'phone_num': phone},);

    }
  }
}