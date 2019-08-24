

import 'package:finerit_app_flutter/apps/bbs/state/bbs_state.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MessageSystemPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MessageSystemPageState();
}

class MessageSystemPageState extends BBSState<MessageSystemPage> {
  String type='系统广播';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bbsModel=ScopedModel.of<BaseStatusModel>(context,rebuildOnChange: true);
    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    return new Scaffold(
      appBar:  AppBar(
        leading: BackButton(
          color: Colors.grey[800],
        ),
        centerTitle: true,
        title: Text("系统消息", style: FineritStyle.style3,),
        backgroundColor: Colors.white,
      ),
        body:handle_main_wighet()
    );
  }
}