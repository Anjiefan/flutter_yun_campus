import 'dart:io';

import 'package:finerit_app_flutter/apps/home/components/home_message_point_widget.dart';
import 'package:finerit_app_flutter/apps/im/im_base.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/profile_blacklist_page.dart';
import 'package:finerit_app_flutter/apps/profile/profile_collect_page.dart';
import 'package:finerit_app_flutter/apps/profile/profile_edit_info_page.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/icons/icons_route3.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';

import 'components/profile_column_widget.dart';
import 'components/profile_horizontal_divider_widget.dart';

class Settings extends StatelessWidget{
  MainStateModel model;
  StatusShouCangModel statusShouCangModel;

  int fankuiNum=0;
  @override
  Widget build(BuildContext context) {
    model = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: Text("应用设置",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black87),),
        leading: BackButton(color: Colors.black,),
      ),
      body: Column(
        children: <Widget>[

          ProfileCommenWidget(
            icon: MyFlutterApp4.addfriend,
            text: '勿扰名单',
            callback: (){
              _handle_blacklist_nav(context);
            },
          ),
          ProfileCommenWidget(
            icon: FineritIcons.write1,
            text: '编辑资料',
            callback: (){
              _handle_edit_user(context);
            },
          ),
          ProfileCommenWidget(
            icon: MyFlutterApp3.unlock,
            text: '修改密码',
            callback: () async {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/changepassword", (route) => route == null);
            },
          ),


        ],
      ),
    );
  }
  void _handle_edit_user(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserInfoPage(),
      ),
    );
  }

  void _handle_blacklist_nav(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlackListPage(),
        )
    );
  }
}