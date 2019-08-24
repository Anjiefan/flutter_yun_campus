import 'package:finerit_app_flutter/apps/components/gesture_focus_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_base_button_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_describe_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_finer_logo_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_textfield_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/welcome_contract_page.dart';
import 'package:finerit_app_flutter/apps/welcome/welcome_password_login_page.dart';
import 'package:finerit_app_flutter/apps/welcome/welcome_password_register_page.dart';
import 'package:finerit_app_flutter/apps/welcome/welcome_register_page.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/permissions.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class WelcomeBaseApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WelcomeBaseAppState();
}

class WelcomeBaseAppState extends State<WelcomeBaseApp> {
  final TextEditingController _controller = new TextEditingController();
  bool loading=false;
  UserAuthModel _userAuthModel;
  MainStateModel model;
  @override
  void initState() {
    super.initState();
    try{
      FinerPermission.requestWriteExternalStoragePermission();
    }
    catch(e){
    }
  }
  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
  }
  bool isLogin=false;
  @override
  Widget build(BuildContext context) {

    if(loading==false){
      _userAuthModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      model= ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      _handle_to_agree_protocol();
      loading=true;
    }
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body:GestureDetector(
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
                      WelcomeTextFieldWidget(controller: _controller
                        ,text: "手机号码",icon: MyFlutterApp4.iphone,maxLength: 11,),
                      new Container(
                        child: GestureDetector(
                          child: Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(right: 45,top: 12),
                              child:
                              Text("游客登陆", style: TextStyle(color: Colors.black87))),
                          onTap:  _handleLogin,
                        ),
                      ),
                      WelcomeBaseButtonWidget(
                          text: isLogin==false?'确定':"校验中"
                          ,callback: isLogin==false?_handleConfirm:null
                      ,bottonColor: isLogin?Colors.grey : FineritColor.login_button,),

                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.only(bottom: 20),
                          alignment: Alignment.bottomCenter,
                          child:  Text("未注册手机号用户登陆将会默认注册成为App用户"
                            ,style: TextStyle(color: Colors.black38,fontSize: 12),),
                        ),
                      )
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
  Future _handleLogin() async {
    NetUtil.post(Api.LOGIN_URL, (data) async {
      model.password='suibianle00';
      model.phone='13000000001';
      model.objectId=data["objectId"];
      model.login(data["session_token"]);
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => route == null);
      NetUtil.get(Api.USER_INFO+model.objectId+'/', (data) {
        UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
        model.userInfo=userInfo;
      }, headers: {"Authorization": "Token ${model.session_token}"});
    }, params: {'password': 'suibianle00', 'phone_num': '13000000001'}, );

  }
  Future<bool> _handleConfirm() async {
    FocusScope.of(context).requestFocus(FocusNode());
    String phone = _controller.text;
    if (phone == "") {
      requestToast("请输入手机号");
      return false;
    }
    setState(() {
      isLogin=true;
    });
    NetUtil.get(Api.VALIDATE_PHONE_URL + phone + "/", (data) {
      setState(() {
        isLogin=false;
      });
      if (data["info"] == "fail") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeRegisterApp(phone: phone),
          ),
        );
        return true;
      } else if (data["info"] == "success") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomePasswordLoginApp(phone: phone),
          ),
        );
        return true;
      } else if (data["info"] == "not real success") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomePasswordRegisterApp(phone: phone),
          ),
        );
        return true;
      }

      return true;
    },errorCallBack: (data){
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

  void _handle_to_agree_protocol(){
    WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          bool value=_userAuthModel.prefs.get('is_read_licence');
          if (value == null || value == false) {
            showGeneralDialog(
              context: context,
              pageBuilder: (context, a, b) => AlertDialog(
                title: Text("提示"),
                content: Text("您还没有同意用户协议，请您阅读后同意才可使用软件！"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeContractApp(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              barrierDismissible: false,
              barrierLabel: '举报',
              transitionDuration: Duration(milliseconds: 400),
            );

          }
        }
    );
  }

}
