import 'package:finerit_app_flutter/apps/bbs/bbs_replay_2.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_attention.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_card_icon.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_feedback_comment_widget.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_reply_replay_flat_button.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_report_widget.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_user_head_wighet.dart';
import 'package:finerit_app_flutter/apps/bbs/model/bbs_model.dart';
import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/apps/components/vip_discript_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_level_icon.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_svip_icon.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_vip_icon.dart';
import 'package:finerit_app_flutter/beans/comment_data_bean.dart';
import 'package:finerit_app_flutter/beans/reply_comment_data.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/global_config.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CommentCard extends StatefulWidget{
  int index;
  int type=0;
  void Function(CommentData obj) callback;
  void Function(ReplyCommentData obj,CommentData base_obj) childCallback;
  CommentCard({
    key
    ,@required this.index,
    this.type=0,
    this.callback,
    this.childCallback
  }):super(key: key);
  @override
  State<StatefulWidget> createState()=>CommentCardState(index: index,type: type,callback: callback,childCallback: childCallback);
}

class CommentCardState extends State<CommentCard>{
  CommentData obj;
  int index;
  int type=0;
  UserAuthModel _userAuthModel;
  void Function(ReplyCommentData obj,CommentData base_obj) childCallback;
  BaseCommentModel _commentdModel;
  final TextEditingController _controller = new TextEditingController();
  bool loading=false;
  void Function(CommentData obj) callback;
  List<Widget> widgets=[];
  CommentCardState({
    key
    ,@required this.index,
    this.type,
    this.callback,
    this.childCallback
  }):super();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_controller!=null){
      _controller.dispose();
    }
  }
  @override
  Widget build(BuildContext context) {
    _commentdModel = ScopedModel.of<BaseCommentModel>(context,rebuildOnChange: true);
    if(loading==false){
      _userAuthModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);

      loading=true;
    }
    obj =_commentdModel.commentList[index];
    build_reply_comment();
    return new Container(
            color: Colors.white,
            margin: const EdgeInsets.only( bottom:3.0),
            child: new FlatButton(
              onPressed: (){
                if(widget.callback!=null){
                  widget.callback(obj);
                }
              },
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        alignment: Alignment.topCenter,
                        child: BaseUserHead(
                          userInfo: obj.user,
                          radius: 18.0,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 8,bottom: 8 ),
                          child: Column(
                            children: <Widget>[
                              Row(

                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 2,right: 2,bottom: 0,top: 0),
                                    child: Text("  " + obj.user.nickName  , style: new TextStyle(color: Colors.black87)),
                                  ),
                                    LevelIcon(level: obj.user.level.levelDesignation
                                      ,iconsize: 1,color: Colors.lightBlue,biglevel: obj.user.level.bigLevelDesignation,),
                                    Container(width: 2,),
                                  VipDiscriptWidget(levelDesignation: obj.user.vipInfo.levelDesignation
                                    ,isAnnual: obj.user.vipInfo.isAnnual,isOpening: obj.user.vipInfo.isOpening,),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: BBSReportWidget(obj: obj,),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10,top: 4),
                                alignment: Alignment.centerLeft,
                                child: Text(obj.text,style: TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w400),),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 15),
                        alignment: Alignment.topRight,
                        child: Text( obj.date, style: new TextStyle(color: Colors.black54,fontSize: 10,),textAlign:TextAlign.right),
                      ),
                      Expanded(
                        child: Container(
                          child: GestureDetector(
                            child: BBSCardIconWidget(
                                icon: obj.like?Icons.favorite:FineritIcons.like,
                                number: obj.likeCount,iconSize: 12
                            ),
                            onTap:(){
                              _handle_like_oprate();
                            },
                          ),
                        ),
                      )


                    ],
                  ),
                  obj.reply_num>0?Container(
                    width: 750,
                    child: Divider(
                      height: 6,
                    ),
                  ):Container(),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      children: widgets,
                    ),
                  ),
                  obj.reply_num>3?GestureDetector(
                    child:Container(
                      alignment: Alignment.centerRight,
                      child: Text("查看更多${obj.reply_num}评论",style: TextStyle(color: Colors.lightBlue,fontWeight: FontWeight.w500),),
                    ),
                    onTap: (){
                      handle_reply2_nav();
                    },
                  ):Container(),
                ],
              ),
            )
        );

  }
  void handle_reply2_nav(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScopedModel<BaseCommentModel>(
            model: _commentdModel
            , child: ReplyPage2(commentData: obj,index: index,)),
      ),
    );
  }
  void build_reply_comment(){
    widgets=[];
    for(int i=0;i<obj.replyCommentCommentRelate.length;i++){
      widgets.add(ReplyButton(
        obj:obj.replyCommentCommentRelate[i],
        index:i,
        likeCallBack: _handle_like_reply_oprate,childCallback: childCallback,
        base_obj:obj,
      ));
    }
  }
  void _handle_like_oprate(){
    obj.like=!obj.like;
    if(obj.like){
      obj.likeCount=obj.likeCount+1;
    }
    else{
      obj.likeCount=obj.likeCount-1;
    }
    _commentdModel.updateComment(obj, index);
    NetUtil.post(Api.COMMENTS_LIKE, (data) async{
      NetUtil.get(Api.COMMENTS+obj.id.toString()+'/', (data) async{
        obj = CommentData.fromJson(data);
        _commentdModel.updateComment(obj, index);
        //TODO 界面显示数据
      },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      );
    },
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      params: {'comment':obj.id.toString()}
    );

  }

  void _handle_like_reply_oprate(int index){
    ReplyCommentData _obj=obj.replyCommentCommentRelate[index];
    _obj.like=!_obj.like;
    if(_obj.like){
      _obj.likeCount=_obj.likeCount+1;
    }
    else{
      _obj.likeCount=_obj.likeCount-1;
    }
    obj.replyCommentCommentRelate[index]=_obj;
    setState(() {
      obj=obj;
    });
    _commentdModel.updateComment(obj, this.index);
    NetUtil.post(Api.REPLAY_COMMENTS_LIKE, (data) async{
      NetUtil.get(Api.COMMENTS+obj.id.toString()+'/', (data) async{
        obj = CommentData.fromJson(data);
        _commentdModel.updateComment(obj, this.index);
        //TODO 界面显示数据
      },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      );
    },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
        params: {'comment':_obj.id.toString()}
    );

  }
}