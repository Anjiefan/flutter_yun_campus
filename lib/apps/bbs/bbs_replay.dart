import 'package:finerit_app_flutter/apps/bbs/components/bbs_comments_card.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_detail_word_card.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_reply_comment_card.dart';
import 'package:finerit_app_flutter/apps/bbs/model/bbs_model.dart';
import 'package:finerit_app_flutter/beans/comment_data_bean.dart';
import 'package:finerit_app_flutter/beans/comment_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/reply_comment_data.dart';
import 'package:finerit_app_flutter/beans/status_data_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/experience_constant.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
class ReplyPage extends StatefulWidget {
  StatusData bbsDetailItem;
  bool comment;
  int index;
  ReplyPage(
      {
        key,
        @required this.bbsDetailItem
        ,this.index
        ,this.comment=false
      }):super(key:key);
  @override
  ReplyPageState createState() => new ReplyPageState(bbsDetailItem: bbsDetailItem,index: index,comment: comment);
}

class ReplyPageState extends PageState<ReplyPage> {
  PanelController _pc = new PanelController();
  final TextEditingController _controller = new TextEditingController();
  StatusData bbsDetailItem;
  BaseCommentModel _commentdModel;
  BaseStatusModel _bbsModel;
  UserAuthModel _userAuthModel;
  bool loading=false;
  int index;
  int page=1;
  FocusNode myFocusNode;
  CommentData comment_obj;
  ReplyCommentData reply_obj;
  int repayPage=1;
  bool comment=false;
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  ReplyPageState(
      {
        key,
        @required this.bbsDetailItem
        ,this.comment
        ,this.index
      }):super();
  @override
  void dispose() {
    super.dispose();
    if(_controller != null){
      _controller.dispose();
    }
  }
  @override
  void initState() {
    super.initState();
    _commentdModel=CommentModel();
    myFocusNode = FocusNode();

  }
  @override
  Widget build(BuildContext context) {
    _userAuthModel= ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    _bbsModel = ScopedModel.of<BaseStatusModel>(context,rebuildOnChange: true);
    String reply_username;
    try{
      bbsDetailItem=_bbsModel.getData()[index];
      reply_username=bbsDetailItem.user.nickName;
      if(reply_obj!=null){
        reply_username=reply_obj.user.nickName;
      }
      else if(comment_obj!=null){
        reply_username=comment_obj.user.nickName;
      }
    }
    catch(e){
      print('error');
    }

    return ScopedModel<BaseCommentModel>(
      child:new Scaffold(
        appBar: new AppBar(
          leading: BackButton(color: Colors.black,),
          title: Text("内容详情", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body:bbsDetailItem!=null?Stack(
          children: <Widget>[
            GestureDetector(
              child:  new EasyRefresh(
                firstRefresh:true,
                autoLoad: true,
                key: easyRefreshKey,
                refreshHeader: MaterialHeader(
                  key: headerKey,
                ),
                refreshFooter: MaterialFooter(
                  key: footerKey,
                ),
                child: Column(
                  children: <Widget>[
                    BBSDetailWordCard(obj: bbsDetailItem,index: index,),
                    new Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top:2,bottom: 2,left: 4),
                                child: Text('所有评论',style: TextStyle(color: Colors.black54),textAlign: TextAlign.left,),
                              ),
                            ),

                          ],
                        )
                    ),
                  ]..addAll(comments_builder(_commentdModel.commentList?.length??0))..add(Container(
                    height: 50,
                  )),
                ),

                onRefresh: () async {
                  refresh_data();
                },
                loadMore: () async {
                  load_more_data();
                },
              ),
              onTap: (){
                if(!this.mounted){
                  return;
                }
                setState(() {
                  FocusScope.of(context).requestFocus(FocusNode());
                });
              },
            ),
            new Positioned(
              bottom: 0,
              left:0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                  decoration: new BoxDecoration(
                      boxShadow:[new BoxShadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                      ),],
                      color: Colors.white,
                      border: Border(top: BorderSide(width: 0.3, color: Colors.black))
                  ),
//一级回复************************************************************************
                  child:Column(
                    children: <Widget>[
                      new Offstage(
                          offstage: false,
                          child:
                          new Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  new Theme(
                                    data: ThemeData(
                                      hintColor: Colors.black12,
                                    ),
                                    child:
                                    new Container(
                                      margin: EdgeInsets.only(left: 7,right: 7,bottom: 4,top: 4),
                                      padding: EdgeInsets.only(top: 5,bottom: 7,left: 5,right: 5),
                                      decoration: new BoxDecoration(
                                        border: new Border.all(width: 1.0, color: Colors.black12),
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
                                      ),
                                      height:  35,
                                      width: MediaQuery.of(context).size.width*0.8,
                                      child:TextField(
                                        controller: _controller,
                                        autofocus: false,
                                        focusNode: myFocusNode,
                                        decoration: new InputDecoration.collapsed(
                                          hintText: '回复用户【${reply_username}】',
                                        ),
                                        cursorColor:Colors.lightBlue,
                                        style:TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(top: 7,bottom: 7),
                                      child: GestureDetector(
                                          child: Container(
                                            width: 80,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(left: 0,right: 8),
                                            padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom:5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20.0),
                                              color: Colors.lightBlueAccent,
                                            ),
                                            child: Text("发送",style: TextStyle(color: Colors.white),),
                                          ),
                                          onTap: (){
                                            if(comment_obj==null){
                                              _handle_send_comment();
                                            }
                                            else{
                                              _handle_send_reply_comment();
                                            }

                                          }),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          )
                      ),
                    ],
//*********************************************************************************
                  )
              ),
            ),
          ],
        ):Container(),
      ),
      model: _commentdModel,
    );
  }
//  _handle_send_reply_comment(commentId);
  void set_reply_comment_id(ReplyCommentData obj,CommentData base_obj){
    reply_obj=obj;
    comment_obj=base_obj;
    if(!this.mounted){
      return;
    }
    setState(() {

    });
    FocusScope.of(context).requestFocus(myFocusNode);
  }
  List<Widget> comments_builder(int length){
    List<Widget> widgets=[];
    for(int i=0;i<length;i++){
      widgets.add(CommentCard(index: i,callback: set_comment_id,childCallback: set_reply_comment_id,));
    }
    return widgets;
  }
  void set_comment_id(CommentData obj){
    comment_obj=obj;
    reply_obj=null;
    if(!this.mounted){
      return;
    }
    setState(() {

    });
    FocusScope.of(context).requestFocus(myFocusNode);
  }
  Future refresh_data(){
    NetUtil.get(Api.COMMENTS, (data){
      _commentdModel.commentList= CommentList.fromJson(data).data;
      if(!this.mounted){
        print("lost");
        return;
      }
      setState(() {
        loading=true;
      });
      page=2;
    },
      params: {'status':bbsDetailItem.id,'page':1,'ordering':'-date'},
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
    );
  }
  Future load_more_data(){
    NetUtil.get(Api.COMMENTS, (data) async{
      _commentdModel.addAllComments(CommentList.fromJson(data).data);
      if(!this.mounted){
        return;
      }
      setState(() {

      });
      page=page+1;
    },
      params: {'status':bbsDetailItem.id,'page':page,'ordering':'-date'},
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
    );
  }


  void _handle_send_comment(){
    FocusScope.of(context).requestFocus(FocusNode());
    if(!this.mounted){
      return;
    }
    setState(() {
      comment=false;
    });
    String text=_controller.text;
    _controller.clear();
    NetUtil.post(Api.COMMENTS, (data) {
      requestToast("评论成功");
      int id=data['id'];
      NetUtil.get(Api.COMMENTS+id.toString()+'/', (data) {
        _commentdModel.addBeginComment(CommentData.fromJson(data));
        NetUtil.get(Api.BBS_BASE+bbsDetailItem.id.toString()+'/', (data) {
          StatusData _bbsDetailItem=StatusData.fromJson(data);
          bbsDetailItem=_bbsDetailItem;
          _bbsModel.update(bbsDetailItem,index);
        },
          headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
        );
      },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      );
      NetUtil.get(Api.ADD_EXPERIENCE, (data) {
        requestToast(data['info']);
      },
          headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
          params: {
            'event_type':ExperienceConstant.SEND_COMMENT,
            'event_id':id,
            'user_id':_userAuthModel.objectId
          }
      );
    },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
        params: {"text": text, "status": bbsDetailItem.id});

  }

  void _handle_send_reply_comment(){
    FocusScope.of(context).requestFocus(FocusNode());
    if(!this.mounted){
      return;
    }
    setState(() {
      comment=false;
    });
    String text=_controller.text;
    _controller.clear();
    Map<String, dynamic> params={'text':text};
    params['reply_comment']=reply_obj?.id??'';
    params['comment']=comment_obj?.id??'';
    NetUtil.post(Api.REPLY_COMMENTS, (data) {

      requestToast("评论成功");
      _controller.clear();
      int id=data['id'];
      NetUtil.get(Api.REPLY_COMMENTS+id.toString()+'/', (data) {
        comment_obj.replyCommentCommentRelate.insert(0,ReplyCommentData.fromJson(data));
        setState(() {
          comment_obj=null;
          reply_obj=null;
        });
      },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      );
      NetUtil.get(Api.ADD_EXPERIENCE, (data) {
        requestToast(data['info']);
      },
          headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
          params: {
            'event_type':ExperienceConstant.SEND_COMMENT,
            'event_id':id,
            'user_id':_userAuthModel.objectId
          }
      );
      //TODO 界面显示数据
    },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
        params: params);

  }

}

