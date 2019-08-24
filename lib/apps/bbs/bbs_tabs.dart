import 'package:finerit_app_flutter/apps/bbs/state/bbs_state.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class BBSSystemTab extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => BBSSystemTabState();
}

class BBSCommonTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BBSCommonTabState();
}




class BBSSystemTabState extends BBSState<BBSSystemTab> {
  String type='系统广播';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

class BBSCommonTabState extends BBSState<BBSCommonTab>{

  String type='用户广播';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}




