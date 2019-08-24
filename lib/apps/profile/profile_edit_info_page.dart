import 'dart:convert';
import 'dart:io';

import 'package:finerit_app_flutter/apps/profile/components/profile_head_card.dart';
import 'package:finerit_app_flutter/beans/ranting_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/icons_route3.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

import 'components/profile_edit_Items.dart';
import 'components/profile_column_widget.dart';
import 'components/profile_edit_username.dart';
import 'components/profile_head_items.dart';
import 'components/profile_head_items_income.dart';
import 'components/profile_horizontal_divider_widget.dart';

class EditUserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditUserInfoState();
  }
}

class EditUserInfoState extends State<EditUserInfoPage>{
  UserAuthModel userAuthModel;
  UserInfoModel userInfoModel;
  TextEditingController _controller = new TextEditingController();
  String nickname;
  File image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_controller!=null){
      _controller.dispose();
    }
  }
  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    userInfoModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    if(nickname==null){
      nickname=userInfoModel.userInfo.nickName;
    }
    if(image==null){
      imageProvider= NetworkImage(
          userInfoModel.userInfo.headImg);
    }
    else{
      imageProvider=FileImage(image);
    }
    return new Scaffold(
      appBar: new AppBar(
        leading: BackButton(
          color: Colors.grey[800],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("编辑资料", style: TextStyle(color: Colors.grey[800])),
        actions: <Widget>[
          GestureDetector(
            child:Container(
              margin: EdgeInsets.only(top:18,right: 10),
              child: Text("完成",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black87),),
            ),
            onTap: (){
              _handleNicknameAndAvatar();
              Navigator.maybePop(context);
            },
          )

        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: EditItems(text:"上传头像",headimg: true,imageProvider:imageProvider),
              onTap: () async {
                await getImage();
              },
            ),
            GestureDetector(
              onTap: _handle_name,
              child: EditItems(text:"修改昵称",headimg: false,nickname: nickname,),
            ),
            GestureDetector(
              onTap: (){
                requestToast("当前版本暂不支持更改绑定的手机号");
              },
              child: EditItems(text:"手机号",headimg: false,nickname: userInfoModel.userInfo.phone,),
            ),
          ],
        ),
      ),
    );
  }
  void _handle_name(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserName(controller: _controller,callback: handle_name_callback
          ,nickname: userInfoModel.userInfo.nickName,),
      ),
    );
  }
  void handle_name_callback(String nickname){
    setState(() {
      this.nickname=nickname;
    });
  }
  Future _handleNicknameAndAvatar()  async{

    FocusScope.of(context).requestFocus(FocusNode());
    String sessionToken = userAuthModel.session_token;
    String objectId = userAuthModel.objectId;
    if (nickname == ""){
      requestToast("昵称不能为空");
      return ;
    }
    if(image == null){//使用默认图片
      NetUtil.put(Api.USER_INFO+"$objectId/", (data) async {
        NetUtil.get(Api.USER_INFO+userAuthModel.objectId+'/', (data) async {
          UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
          userInfoModel.userInfo=userInfo;

        }, headers: {"Authorization": "Token ${userAuthModel.session_token}"});
      }, params: {
        "nick_name": nickname,
        "head_img": userInfoModel.userInfo.headImg
      }, headers: {"Authorization": "Token $sessionToken"});
    }else{//选取了新的图片
      NetUtil.putFile(image, (value) async {
        Map uploadInfo = json.decode(value);
        String realUrl = uploadInfo["url"];
        print("realUrl=$realUrl");
        NetUtil.put(Api.REGISTER_NICKNAME_AVATAR+"$objectId/", (data) async {
          NetUtil.get(Api.USER_INFO+userAuthModel.objectId+'/', (data) async {
            UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
            userInfoModel.userInfo=userInfo;

          }, headers: {"Authorization": "Token ${userAuthModel.session_token}"});
        }, params: {
          "nick_name": nickname,
          "head_img": realUrl
        }, headers: {"Authorization": "Token $sessionToken"});
      });
    }

  }
}
