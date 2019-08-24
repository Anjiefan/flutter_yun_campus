//  import 'dart:convert';
//import 'dart:io';
//
//import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
//import 'package:finerit_app_flutter/commons/api.dart';
//import 'package:finerit_app_flutter/commons/net_utils.dart';
//import 'package:finerit_app_flutter/models/base_model.dart';
//import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:scoped_model/scoped_model.dart';
//class EditUserInfoPage extends StatefulWidget{
//  @override
//  State<StatefulWidget> createState() {
//    return EditUserInfoPageState();
//  }
//
//}
//
//
//class EditUserInfoPageState extends State<EditUserInfoPage> {
//  UserAuthModel userAuthModel;
//  UserInfoModel userInfoModel;
//  TextEditingController _controller = new TextEditingController();
//  File image;
//
//  Future getImage() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    setState(() {
//      this.image = image;
//    });
//  }
//  @override
//  Widget build(BuildContext context) {
//    userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
//    userInfoModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
//    ImageProvider imageProvider;
//    if(image==null){
//      imageProvider= NetworkImage(
//          userInfoModel.userInfo.headImg);
//    }
//    else{
//      imageProvider=FileImage(image);
//    }
//    return Scaffold(
//
//import 'components/profile_edit_Items.dart';
//import 'components/profile_column_widget.dart';
//import 'components/profile_edit_username.dart';
//import 'components/profile_head_items.dart';
//import 'components/profile_head_items_income.dart';
//import 'components/profile_horizontal_divider_widget.dart';
//
//class EditUserInfo extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return EditUserInfoState();
//  }
//}
//
//class EditUserInfoState extends State<EditUserInfo>{
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return new Scaffold(
//
//      appBar: new AppBar(
//        leading: BackButton(
//          color: Colors.grey[800],
//        ),
//        backgroundColor: Colors.white,
//        centerTitle: true,
//        title: Text("编辑资料", style: TextStyle(color: Colors.grey[800])),
//        actions: <Widget>[
//          GestureDetector(
//            child: Container(
//              margin: EdgeInsets.only(top:18,right: 10),
//              child: Text("完成",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black87),),
//            ),
//            onTap: (){
//              _handleNicknameAndAvatar();
//              Navigator.pop(context);
//            },
//          )
//        ],
//      ),
//      body: Container(
//        child: Column(
//          children: <Widget>[
//
//            Container(height: 50,),
//            new Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                GestureDetector(
//                  child: Container(
//                    margin: EdgeInsets.only(top: 15,bottom: 5),
//                    child:
//                    CircleAvatar(
//                      radius: 40,
//                      backgroundImage: imageProvider,
//                    )
//                    ,
//                  ),
//                  onTap: (){
//                    getImage();
//                  },
//                ),
//              ],
//            ),
//            new Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                GestureDetector(
//                  child: Container(
//                    child: Text("上传头像",
//                      style: TextStyle(
//                        decoration: TextDecoration.underline,
//                        color: Colors.black,
//                        fontWeight: FontWeight.w500,
//                        fontSize: 20,
//                      ),
//                    ),
//                  ),
//                  onTap: (){
//                    getImage();
//                  },
//                )
//              ],
//            ),
//            Container(height: 30,),
//            new Container(
//              width: 280,
//              child:
//              new Row(
//                children: <Widget>[
//                  Container(
//                    margin: EdgeInsets.only(left: 7),
//                    child: Text("昵称：",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
//                  ),
//                  Expanded(child: Container(
//                    height: 30,
//                    margin: EdgeInsets.only(top: 12,left: 5,right: 10,bottom: 10),
//                    padding: EdgeInsets.only(top: 3,left: 5,right: 5,bottom: 7),
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.circular(8),
//                      border: Border.all(width: 1,color: Colors.black12),
//
//                    ),
//                    child: TextField(
//                      controller: _controller,
//                      maxLines:1,
//                      autofocus:true,
//                      cursorColor:Colors.lightBlue,
//                      style:TextStyle(color: Colors.black54),
//                      decoration: InputDecoration.collapsed(
//                        hintText: userInfoModel.userInfo.nickName,
//                      ),
//                    ),
//                  ),)
//                ],
//              ),
//
//            GestureDetector(
//              child: EditItems(text:"上传头像",headimg: true,),
////              onTap: ,
//            ),
//            GestureDetector(
//              onTap: _handle_name,
//              child: EditItems(text:"修改昵称",headimg: false,),
//
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Future _handleNicknameAndAvatar()  async{
//
//    FocusScope.of(context).requestFocus(FocusNode());
//    String sessionToken = userAuthModel.session_token;
//    String objectId = userAuthModel.objectId;
//    if (_controller.text == ""){
//      _controller.text = userInfoModel.userInfo.nickName;
//    }
//    if(image == null){//使用默认图片
//      NetUtil.put(Api.USER_INFO+"$objectId/", (data) async {
//        NetUtil.get(Api.USER_INFO+userAuthModel.objectId+'/', (data) async {
//          UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
//          userInfoModel.userInfo=userInfo;
//        }, headers: {"Authorization": "Token ${userAuthModel.session_token}"});
//      }, params: {
//        "nick_name": _controller.text,
//        "head_img": userInfoModel.userInfo.headImg
//      }, headers: {"Authorization": "Token $sessionToken"});
//    }else{//选取了新的图片
//      NetUtil.putFile(image, (value) async {
//        Map uploadInfo = json.decode(value);
//        String realUrl = uploadInfo["url"];
//        print("realUrl=$realUrl");
//        NetUtil.put(Api.REGISTER_NICKNAME_AVATAR+"$objectId/", (data) async {
//          NetUtil.get(Api.USER_INFO+userAuthModel.objectId+'/', (data) async {
//            UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
//            userInfoModel.userInfo=userInfo;
//
//          }, headers: {"Authorization": "Token ${userAuthModel.session_token}"});
//        }, params: {
//          "nick_name": _controller.text,
//          "head_img": realUrl
//        }, headers: {"Authorization": "Token $sessionToken"});
//      });
//    }
//
//  }
//}
//
//  void _handle_name(){
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => EditUserName(),
//      ),
//    );
//  }
//}
//
