import 'package:finerit_app_flutter/apps/bbs/components/bbs_card_icon.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_reply_replay_flat_button.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_report_widget.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_user_head_wighet.dart';
import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/beans/reply_comment_data.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/global_config.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ReplyCommentCard extends StatefulWidget{
  int index;
  int type=0;

  void Function(ReplyCommentData i) callback;
  ReplyCommentCard({
    key
    ,@required this.index,
    this.type=0,
    this.callback
  }):super(key: key);
  @override
  State<StatefulWidget> createState()=>ReplyCommentCardState(index: index,type: type,callback: callback);
}

class ReplyCommentCardState extends State<ReplyCommentCard>{
  ReplyCommentData obj;
  int index;
  int type=0;
  UserAuthModel _userAuthModel;
  BaseReplyComment _commentdModel;

  final TextEditingController _controller = new TextEditingController();
  bool loading=false;
  void Function(ReplyCommentData i) callback;
  ReplyCommentCardState({
    key
    ,@required this.index,
    this.type,
    this.callback
  }):super();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    _commentdModel = ScopedModel.of<BaseReplyComment>(context,rebuildOnChange: true);
    if(loading==false){
      _userAuthModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    obj =_commentdModel.relayCommentList[index];
    return new Container(
        color: Colors.white,
        margin: const EdgeInsets.only( bottom:3.0),
        padding: EdgeInsets.only(top: 5),
        child: new FlatButton(
          onPressed: (){
            if(widget.callback!=null){
              widget.callback(obj);
            }
          },
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BaseUserHead(
                    userInfo: obj.user,
                    radius: 18.0,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 8,right: 2,bottom: 0,top: 0),
                                child: (obj.user.nickName.length>=8)?
                                Text(obj.user.nickName, style: new TextStyle(color: Colors.black87,fontSize: 12)):
                                Text("" + obj.user.nickName, style: new TextStyle(color: Colors.black87,fontSize: 13)),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 0,right: 0,bottom: 0,top: 2),
                                child: Icon(
                                  Icons.arrow_right,
                                  size: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 0,right: 0,bottom: 0,top: 0),
                                child: (obj.replyedUser.length>=8)
                                    ?Text(obj.replyedUser, style: new TextStyle(color: Colors.black87,fontSize: 12)):
                                    Text("" + obj.replyedUser, style: new TextStyle(color: Colors.black87,fontSize: 13)),
                              ),
                              Expanded(
                                child:  Container(
                                  alignment: Alignment.centerRight,
                                  child: BBSReportWidget(obj: obj,type: 2,),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8),
                          alignment: Alignment.centerLeft,
                          child: Text(obj.text,style: TextStyle(color: Colors.black87,fontSize: 14,fontWeight: FontWeight.w400),),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Container(
                    alignment: Alignment.topRight,
                    child: Text( obj.date, style: new TextStyle(color: Colors.black54,fontSize: 10,),textAlign:TextAlign.right),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        child: BBSCardIconWidget(
                            icon: obj.like?FineritIcons.like2_on:FineritIcons.like2,
                            number: obj.likeCount,iconSize: 12
                        ),
                        onTap:(){
                          _handle_like_reply_oprate();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );

  }
  void _handle_like_reply_oprate(){
    obj.like=!obj.like;
    if(obj.like){
      obj.likeCount=obj.likeCount+1;
    }
    else{
      obj.likeCount=obj.likeCount-1;
    }
    setState(() {
      obj=obj;
    });
    NetUtil.post(Api.REPLAY_COMMENTS_LIKE, (data) async{
      NetUtil.get(Api.REPLY_COMMENTS+obj.id.toString()+'/', (data) async{
        obj = ReplyCommentData.fromJson(data);
        _commentdModel.updateComment(obj, this.index);
        //TODO 界面显示数据
      },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      );
    },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
        params: {'comment':obj.id.toString()}
    );

  }
}