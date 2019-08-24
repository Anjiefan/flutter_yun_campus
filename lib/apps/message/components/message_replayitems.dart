import 'package:finerit_app_flutter/apps/bbs/bbs_replay.dart';
import 'package:finerit_app_flutter/apps/bbs/model/bbs_model.dart';
import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_horizontal_divider_widget.dart';
import 'package:finerit_app_flutter/beans/comment_data_bean.dart';
import 'package:finerit_app_flutter/beans/community_message_data_bean.dart';
import 'package:finerit_app_flutter/beans/status_data_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/community_constant.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:finerit_app_flutter/apps/bbs/bbs_replay_2.dart';
import 'message_headitems.dart';

class ReplayItems extends StatelessWidget{
  CommunityMessageData communityMessageData;
  void Function(CommunityMessageData communityMessageData) callback;
  UserInfoModel userInfoModel;
  UserAuthModel userAuthModel;
  ReplayItems({Key key,this.communityMessageData,this.callback}):super(key:key);
  @override
  Widget build(BuildContext context) {
    userInfoModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    return new Column(
      children: <Widget>[
        Container(
          
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                alignment: Alignment.topRight,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    MesHeadItems(user: communityMessageData.relateUser),
                    Container(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text( communityMessageData.date, style: new TextStyle(color: Colors.black54,fontSize: 10,),textAlign:TextAlign.right),
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
                      communityMessageData.relateContent,
                      style: new TextStyle(height: 1.3, color: Colors.black87)
                  )
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 10,right: 10,top: 10),
        ),
        GestureDetector(
          onTap: (){
            handle_type_nav(context);
          },
          child: new Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 15,right: 15,top: 5),
            padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
            width: MediaQuery.of(context).size.width-20,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BaseUserHead(
                  userInfo:UserInfoBrief.fromJson(userInfoModel.userInfo.toJson()),
                  radius: 15,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Row(

                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 2,right: 2,bottom: 0,top: 0),
                              child: Text("  " + userInfoModel.userInfo.nickName  , style: new TextStyle(color: Colors.black87)),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8,top: 4),
                          alignment: Alignment.centerLeft,
                          child: Text(communityMessageData.myContent,style: TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w400),),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Container(
          padding: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              communityMessageData.replyId!=null?GestureDetector(
                child: Text("回复",style: TextStyle(color: Colors.black87,fontSize: 14 ),),
                onTap:(){
                  if(callback!=null){
                    callback(communityMessageData);
                  }
                }
              ):Container(),
            ],
          ),
        ),
        new HorizontalDivider(),
      ],
    );
  }
  void handle_type_nav(BuildContext context){

    switch(communityMessageData.type){
      case CommunityConstant.COLLECT:
        handle_status_nav(context);
        break;
      case CommunityConstant.LIKE:
        handle_comment_nav(context);
        break;
      case CommunityConstant.COMMENT:
//        handle_status_nav(context);
        handle_comment_nav(context);
        break;
      case CommunityConstant.REPLY_COMMENT:
        handle_comment_nav(context);
        break;
    }
  }
  void handle_comment_nav(BuildContext context){
    TemporaryCommentModel temporaryCommentModel=TemporaryCommentModel();
    NetUtil.get(Api.COMMENTS+communityMessageData.relateId.toString()+'/', (data) async{
      CommentData obj = CommentData.fromJson(data);
      temporaryCommentModel.commentList=[obj];
      //TODO 界面显示数据
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScopedModel<BaseCommentModel>(
            model: temporaryCommentModel
            , child: ReplyPage2(commentData: null,index: 0,)),
      ),
    );
  }
  void handle_status_nav(BuildContext context){
    TemporaryStatusModel temporaryStatusModel=TemporaryStatusModel();
    NetUtil.get(Api.BBS_BASE+communityMessageData.relateId.toString()+'/', (data) async{
      var _obj = StatusData.fromJson(data);
      List<StatusData> statuList=[_obj];
      temporaryStatusModel.setData(statuList);

    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
    );
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=>
            ScopedModel<BaseStatusModel>(
              model: temporaryStatusModel,
              child: ReplyPage(bbsDetailItem: null,index:0,comment: true,),
            )
    ));
  }
}