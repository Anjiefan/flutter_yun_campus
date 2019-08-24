import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:finerit_app_flutter/apps/components/gesture_focus_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_base_button_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_describe_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_finer_logo_widget.dart';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_textfield_widget.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class WelcomeNicknameAvatarApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() =>
      WelcomeNicknameAvatarAppState();
}

class WelcomeNicknameAvatarAppState extends State<WelcomeNicknameAvatarApp> {
  final TextEditingController _controller = new TextEditingController();
  MainStateModel model;
  @override
  void dispose() {
    super.dispose();
    if(_controller!=null){
      _controller.dispose();
    }
  }
  @override
  void initState() {
    super.initState();
  }
  bool isLogin=false;
  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if(image==null){
      imageProvider= NetworkImage(
          "https://www.finerit.com/media/head.png");
    }
    else{
      imageProvider=FileImage(image);
    }
    return new ScopedModelDescendant<MainStateModel>(
        builder: (context, widget,MainStateModel model) {
          this.model=model;
          return Scaffold(
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
                  child: new Column(
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
                            Container(
                              margin: EdgeInsets.only(top: 50, right: 20, left: 10),
                              height: 190,
                              alignment: FractionalOffset.topLeft,
                              child: Theme(
                                data: ThemeData(
                                    primaryColor: Colors.grey,
                                    accentColor: Colors.grey,
                                    hintColor: Colors.grey),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: _handleAvatarPicker,
                                        child: Container(
                                          margin: EdgeInsets.only(left: 8),
                                          width: 90.0,
                                          height: 90.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff7c94b6),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(50.0)),
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 4.0,
                                            ),
                                          ),
                                        ),
                                      ),
//                              Container(
//                                margin: EdgeInsets.only(top: 20),
//                                child: Row(
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                  children: <Widget>[
//                                    Expanded(
//                                      child: TextField(
//                                        controller: _controller,
//                                        keyboardType: TextInputType.text,
//                                        cursorColor: Colors.grey,
//                                        maxLines: 1,
//                                        maxLength: 16,
//                                        style: TextStyle(
//                                            color: Colors.grey, fontSize: 20),
//                                        obscureText: false,
//                                        decoration: InputDecoration(
//                                            contentPadding: EdgeInsets.all(7),
//                                            labelText: "设置头像和昵称",
//                                            icon: Icon(Icons.star)),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
                                      WelcomeTextFieldWidget(controller: _controller
                                        ,text: "设置头像和昵称",icon: MyFlutterApp4.mine,maxLength: 11,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            WelcomeBaseButtonWidget(
                              text: isLogin==false?'确定':"校验中"
                              ,callback: isLogin==false?_handleNicknameAndAvatar:null
                              ,bottonColor: isLogin?Colors.grey : FineritColor.login_button,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )


          );
        }
    );

  }

  File image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
    });
  }

  Future _handleNicknameAndAvatar()  async{

    FocusScope.of(context).requestFocus(FocusNode());
    String sessionToken = model.session_token;
    String objectId = model.objectId;
    String phone = model.phone;
    if (_controller.text == ""){
      _controller.text = "Jack";
    }
    setState(() {
      isLogin=true;
    });
    if(image == null){//使用默认图片
      NetUtil.put(Api.REGISTER_NICKNAME_AVATAR+"$objectId/", (data) async {
        NetUtil.get(Api.USER_INFO+model.objectId+'/', (data) async {
          UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
          model.userInfo=userInfo;
          setState(() {
            isLogin=false;
          });
//          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => route == null);
        }, headers: {"Authorization": "Token ${model.session_token}"},errorCallBack: (data){
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
      }, params: {
//        "phone": phone,
        "nick_name": _controller.text,
        "head_img": "https://www.finerit.com/media/head.png"
      }, headers: {"Authorization": "Token $sessionToken"},
          errorCallBack: (data){
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
    }else{//选取了新的图片
      NetUtil.putFile(image, (value) async {
        Map uploadInfo = json.decode(value);
        String realUrl = uploadInfo["url"];
        print("realUrl=$realUrl");
        NetUtil.put(Api.REGISTER_NICKNAME_AVATAR+"$objectId/", (data) async {
          NetUtil.get(Api.USER_INFO+model.objectId+'/', (data) async {
            UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
            model.userInfo=userInfo;

          }, headers: {"Authorization": "Token ${model.session_token}"},errorCallBack: (data){
            try{
              requestToast(HttpError.getErrorData(data).toString());
            }
            catch(e){
              requestToast(HttpError.getListErrorData(data).toString());
            }
          });
        }, params: {
//          "phone": phone,
          "nick_name": _controller.text,
          "head_img": realUrl
        }, headers: {"Authorization": "Token $sessionToken"},errorCallBack: (data){
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
      },);
    }
    setState(() {
      isLogin=false;
    });
    Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => route == null);

  }
  void _handleAvatarPicker() {
    getImage();
  }
}
