import 'package:finerit_app_flutter/apps/profile/state/profile_shield_user_state.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class BlackListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BlackListPageState();
  }
}
class BlackListPageState extends ShieldUserState<BlackListPage>{
  ShieldUserBaseModel shieldUserBaseModel;
  UserAuthModel userAuthModel;
  @override
  Widget build(BuildContext context) {
    shieldUserBaseModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    return new Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.grey[800],
          ),
          title: Text(
            "勿扰名单",
            style: TextStyle(color: Colors.grey[800]),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body:handle_main_wighet()
    );
  }
}
