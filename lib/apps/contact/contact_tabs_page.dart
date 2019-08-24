import 'package:finerit_app_flutter/apps/contact/state/contact_request_state.dart';
import 'package:flutter/material.dart';
class GetRequestTab extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => GetRequestTabState();
}

class SendRequestTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SendRequestTabState();
}




class GetRequestTabState extends ContactRequestState<GetRequestTab> {
  bool relate=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

class SendRequestTabState extends ContactRequestState<SendRequestTab>{
  bool relate=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}




