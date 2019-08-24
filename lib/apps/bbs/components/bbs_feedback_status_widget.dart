//PopupMenuButton

import 'package:finerit_app_flutter/apps/bbs/components/bbs_user_head_wighet.dart';
import 'package:finerit_app_flutter/beans/status_data_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/global_config.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class FeedBackWidgetStatus extends StatefulWidget{
  int index;
  StatusData obj;
  BaseStatusModel bbsModel;
  FeedBackWidgetStatus({
    Key key,
    this.index,
    this.obj,
    this.bbsModel
  }):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return FeedBackWidgetState(index: index,obj: obj,bbsModel: bbsModel,);
  }

}

class FeedBackWidgetState extends State<FeedBackWidgetStatus> {
  UserAuthModel _userAuthModel;
  final TextEditingController _controller = new TextEditingController();
  int index;
  StatusData obj;
  bool focus=true;
  FeedBackWidgetState({
    Key key,
    this.index,
    this.obj,
    this.bbsModel
  }):super();
  BaseStatusModel bbsModel;
  bool loading=false;
  @override
  void dispose() {
    super.dispose();
    if(_controller!=null){
      _controller.dispose();
    }
  }
  @override
  Widget build(BuildContext context) {
    if(loading==false){
      _userAuthModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    if(obj.user.id!=_userAuthModel.objectId){
      return
        PopupMenuButton<String>(
          padding: EdgeInsets.all(0),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black38,
          ),
          onSelected: (String value) {
            switch(value){
              case "减少此类内容":
                handle_dislike_type();
                break;
              case "不感兴趣":
                handle_dislike();
                break;
              case "举报":
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, a, b) => handle_report(context),
                  barrierDismissible: false,
                  barrierLabel: '举报',
                  transitionDuration: Duration(milliseconds: 400),
                );
                break;
              case '复制':
                Clipboard.setData(new ClipboardData(text: obj.text));
                requestToast('复制成功');
            }
          },
          itemBuilder: (BuildContext context) =>
          <PopupMenuItem<String>>[
            const PopupMenuItem(
              value: "减少此类内容",
              child: Text("减少此类内容"),
            ),
            const PopupMenuItem(
              value: "不感兴趣",
              child: Text("不感兴趣"),
            ),
            const PopupMenuItem(
              value: "举报",
              child: Text("举报"),
            ),
            const PopupMenuItem(
              value: "复制",
              child: Text("复制"),
            ),
          ],
        );
    }else{
      return Container();
    }

  }
  void handle_dislike(){
    NetUtil.post(Api.SHIELD_STATUS, (data) async{
      bbsModel.removeByIndex(index);
      requestToast("此条信息将不再可见");
    },
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      params: {"status":obj.id}
    );
  }
  void handle_dislike_type(){
    NetUtil.post(Api.SHIELD_STATUS, (data) async{
      bbsModel.removeByIndex(index);
      requestToast("此类信息将不再可见");
    },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
        params: {"status":obj.id}
    );
  }

  Widget handle_report(var context){
    return AlertDialog(
      title: Text('举报'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: (MediaQuery.of(context).size.height / 2) * 0.6,
        child: Column(

          children: <Widget>[
            UserHead(username: obj.user.nickName
              ,sincePosted: obj.date
              ,headImg: obj.user.headImg,
              userInfo: obj.user,),
            new Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(bottom: 20),
                child: new Text(
//                    obj.status.text,
                    obj.text.length>20?obj.text.substring(0,20)+'...':obj.text,
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
                height: 80,
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
//            showDialog(
//                context: context,
//                barrierDismissible: true,
//                builder: (_) {
//                  return new NetLoading(
//                    requestCallBack: handle_send_reportinfo(context),
//                    outsideDismiss: true,
//                    loadingText: '发送举报信息中...',
//                  );
//
//                });
            handle_send_reportinfo();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
  void  handle_send_reportinfo()  {
    NetUtil.post(Api.REPORT_STATUS, (data) {
      requestToast("举报成功，我们将会积极处理！");
    },
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      params: {'status':obj.id,'text':_controller.text},
        errorCallBack:(data){
          requestToast(HttpError.getErrorData(data).toString());
        }
    );

  }

}

