import 'dart:io';

import 'package:finerit_app_flutter/apps/bbs/components/bbs_card_icon.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_feedback_comment_widget.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_feedback_status_widget.dart';
import 'package:finerit_app_flutter/beans/comment_data_bean.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_user_head_wighet.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BBSDetailCommentCard extends StatefulWidget{
  CommentData obj;
  int index;
  BBSDetailCommentCard({
    key
    ,@required this.obj
    ,this.index
  }):super(key: key);
  @override
  State<StatefulWidget> createState() =>BBSDetailCommentCardState(obj:obj,index: index);

}

class BBSDetailCommentCardState extends State<BBSDetailCommentCard>{
  CommentData obj;
  int index;
  BaseCommentModel _commentModel;
  UserAuthModel _userAuthModel;
  BBSDetailCommentCardState({
    key
    ,@required this.obj
    ,this.index
  }):super();
  @override
  Widget build(BuildContext context) {
    _commentModel = ScopedModel.of<BaseCommentModel>(context,rebuildOnChange: true);
    _userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    obj=_commentModel.commentList[index];
    return new Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 0, bottom: 0),
        padding:EdgeInsets.only(left: 10,top: 12,right: 8),
        child: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                alignment: Alignment.topRight,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    UserHead(username: obj.user.nickName
                      ,sincePosted: obj.date
                      ,headImg: obj.user.headImg,
                      userInfo: obj.user,),
                    Container(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          FeedBackWidgetComment(obj: obj),
                          Text( obj.date, style: new TextStyle(color: Colors.black54,fontSize: 10,),textAlign:TextAlign.right),
                        ],
                      ),
                    ),
                  ],
                  verticalDirection: VerticalDirection.up,

                ),
              ),
              new Container(
                  margin: EdgeInsets.only(left: 5,top: 5),
                  alignment: Alignment.bottomLeft,
                  child: new Text(
                      obj.text.length>100?obj.text.substring(0,100)+'...':obj.text,
                      style: new TextStyle(height: 1.3, color: Colors.black87)
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      child: BBSCardIconWidget(
                          icon: obj.like?FineritIcons.like2_on:FineritIcons.like2,
                          number: obj.likeCount,iconSize: 14
                      ),
                      onTap:(){
                        _handle_like_oprate();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
  void _handle_like_oprate(){
    obj.like=!obj.like;
    if(obj.like){
      obj.likeCount=obj.likeCount+1;
    }
    else{
      obj.likeCount=obj.likeCount-1;
    }
    _commentModel.updateComment(obj, index);
    NetUtil.post(Api.COMMENTS_LIKE, (data) async{
      NetUtil.get(Api.COMMENTS+obj.id.toString()+'/', (data) async{
        obj = CommentData.fromJson(data);
        _commentModel.updateComment(obj, index);
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