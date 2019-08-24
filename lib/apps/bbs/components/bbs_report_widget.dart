

import 'package:finerit_app_flutter/apps/bbs/components/bbs_user_head_wighet.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/global_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BBSReportWidget extends StatefulWidget{
  //type为1表示一级评论，2为二级评论
  int type;
  var obj;
  BBSReportWidget({Key key,this.obj,this.type=1}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BBSReportWidgetState(obj: obj,type:type);
  }

}

class BBSReportWidgetState extends State<BBSReportWidget>{
  var obj;
  int type;
  final TextEditingController _controller = new TextEditingController();
  UserAuthModel userAuthModel;
  BBSReportWidgetState({Key key,this.obj,this.type}):super();
  @override
  Widget build(BuildContext context) {
    userAuthModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    return GestureDetector(
      child: Container(
        child: Text('举报',style: TextStyle(
            fontSize: 10,
            color: Colors.black54
        ),
        ),
        padding: EdgeInsets.only(left: 5),
      ),
      onTap: (){
        handle_report(context);
      },
    );
  }
  void handle_report(BuildContext context){
    showGeneralDialog(
      context: context,
      pageBuilder: (context, a, b) => _handle_report(context),
      barrierDismissible: false,
      barrierLabel: '举报',
      transitionDuration: Duration(milliseconds: 400),
    );
  }
  Widget _handle_report(var context){

    return AlertDialog(
      title: Text('举报',style: TextStyle(fontSize: 16),),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("用户:"+obj.user.nickName,),
            new Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(bottom: 5),
                child: new Text("内容："+ (obj.text.length>20?obj.text.substring(0,20)+'...':obj.text),
                    style: new TextStyle(height: 1.3, color: GlobalConfig.font_color)
                )

            ),
            new Theme(

              data: ThemeData(
                hintColor: Colors.black12,
              ),
              child:
              new Container(
                decoration: new BoxDecoration(
                  border: new Border.all(width: 2.0, color: Colors.black12),
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                ),
                height: 70,
                width: MediaQuery.of(context).size.width*1,
                child:TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: new InputDecoration.collapsed(
                    hintText: '举报原因...',
                  ),
                  cursorColor:Colors.black38,
                  style:TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('确认'),
          onPressed: () async {
            handle_send_reportinfo();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
  void  handle_send_reportinfo()  {
    NetUtil.post(type==1?Api.REPORT_COMMENTS:Api.REPORT_REPLY_COMMENTS, (data) {
      requestToast("举报成功，我们将会积极处理！");
    },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
        params: {'comment':obj.id,'text':_controller.text},
        errorCallBack:(data){

          requestToast(HttpError.getErrorData(data).toString());
        }
    );

  }
}