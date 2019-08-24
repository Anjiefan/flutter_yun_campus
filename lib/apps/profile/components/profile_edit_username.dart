import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class EditUserName extends StatelessWidget{
  UserInfoModel userInfoModel;
  TextEditingController controller;
  void Function(String nickname) callback;
  String nickname;
  EditUserName({this.nickname,this.callback,this.controller});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userInfoModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    return Scaffold(
      appBar: new AppBar(
        leading: BackButton(
          color: Colors.grey[800],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("修改昵称", style: TextStyle(color: Colors.grey[800])),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top:18,right: 10),
              child: Text("完成",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black87),),
            ),
            onTap: (){
              if(callback!=null){
                if(controller.text!=''){
                  callback(controller.text);
                }
                else{
                  callback(nickname);
                }
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: new Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text("昵称：",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
          ),
          Expanded(child: Container(
            height: 30,
            margin: EdgeInsets.only(top: 12,left: 5,right: 10,bottom: 10),
            padding: EdgeInsets.only(top: 3,left: 5,right: 5,bottom: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1,color: Colors.black12),

            ),
            child: TextField(
              maxLines:1,
              autofocus:true,
              cursorColor:Colors.lightBlue,
              controller: controller,
              style:TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w300),
              decoration: InputDecoration.collapsed(

                hintText: '${nickname}',
                hintStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w300)
              ),
            ),
          ),)
        ],
      ),
    );
  }
}