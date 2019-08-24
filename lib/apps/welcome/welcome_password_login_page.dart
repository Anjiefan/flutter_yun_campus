
import 'package:finerit_app_flutter/apps/components/gesture_focus_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_base_button_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_describe_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_finer_logo_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_password_textfield_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/welcome_sms_login_page.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/icons_route2.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class WelcomePasswordLoginApp extends StatefulWidget {
  final String phone;

  @override
  State<StatefulWidget> createState() => WelcomePasswordLoginAppState(phone: phone);

  WelcomePasswordLoginApp({Key key, @required this.phone}) : super(key: key);
}

class WelcomePasswordLoginAppState extends State<WelcomePasswordLoginApp> {
  final TextEditingController controller = new TextEditingController();
  final String phone;
  bool _obscureText = true;
  MainStateModel model;
  WelcomePasswordLoginAppState({Key key, @required this.phone}) : super();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(controller!=null){
      controller.dispose();
    }
  }
  bool isLogin=false;
  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainStateModel>(

        builder: (context, widget,MainStateModel model) {
          this.model=model;
          return
            Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Colors.white,
              body:GestureDetector(
                onTap: (){
                  if(!this.mounted){
                    return;
                  }
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                child: Container(
                  color: Color.fromARGB(0, 255, 255, 255),
                  child: new Stack(
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
                            WelcomePasswordTextFieldWidget(controller: controller
                              ,icon: MyFlutterApp2.lock
                              ,text: "密码",maxLength: 16,),
                            Container(
                              margin: EdgeInsets.only(right: 45,top: 12),
                              child: InkWell(
                                onTap: _handleVerifyCodeLogin,
                                child: Align(
                                    alignment: FractionalOffset.topRight,
                                    child:
                                    Text("验证码登录", style: TextStyle(color: Colors.black87))),
                              ),
                            ),
                            WelcomeBaseButtonWidget(
                              text: isLogin==false?'确定':"校验中"
                              ,callback: isLogin==false?_handleLogin:null
                              ,bottonColor: isLogin?Colors.grey : FineritColor.login_button,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
    );

  }

  Future _handleLogin() async{
    FocusScope.of(context).requestFocus(FocusNode());
    String text=controller.text;
    setState(() {
      isLogin=true;
    });
    NetUtil.post(Api.LOGIN_URL, (data) async {
      model.password=text;
      model.phone=phone;
      model.objectId=data["objectId"];
      model.login(data["session_token"]);
      setState(() {
        isLogin=false;
      });
      NetUtil.get(Api.USER_INFO+model.objectId+'/', (data) {
        UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
        model.userInfo=userInfo;

      }, headers: {"Authorization": "Token ${model.session_token}"}
          ,errorCallBack: (){
            try{
              requestToast(HttpError.getErrorData(data).toString());
            }
            catch(e){
              requestToast(HttpError.getListErrorData(data).toString());
            }
            setState(() {
              isLogin=false;
            });
          });
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => route == null);
    }, params: {'password': text, 'phone_num': phone},errorCallBack: (data){
      try{
        requestToast(HttpError.getErrorData(data).toString());
      }
      catch(e){
        requestToast(HttpError.getListErrorData(data).toString());
      }
      setState(() {
        isLogin=false;
      });
    });
  }


  void _handleVerifyCodeLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomeCodeLoginApp(phone: phone,),
      ),
    );
  }
}
