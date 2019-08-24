import 'package:finerit_app_flutter/apps/bbs/components/bbs_detail_comment_card.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_reply_comment_card.dart';
import 'package:finerit_app_flutter/apps/bbs/model/bbs_model.dart';
import 'package:finerit_app_flutter/beans/comment_data_bean.dart';
import 'package:finerit_app_flutter/beans/reply_comment_data.dart';
import 'package:finerit_app_flutter/beans/reply_comment_list_bean.dart';
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
class ReplyPage2 extends StatefulWidget {
  CommentData commentData;
  int index;
  ReplyPage2(
      {
        key,
        @required this.commentData
        ,this.index
      }):super(key:key);
  @override
  ReplyPage2State createState() => new ReplyPage2State(commentData: commentData
      ,index: index
     );
}

class ReplyPage2State extends PageState<ReplyPage2> {
  BaseReplyComment _replyCommentdModel;
  BaseCommentModel _commentdModel;
  UserAuthModel _userAuthModel;
  int repayPage=1;
  CommentData commentData;
  FocusNode myFocusNode;

  ReplyCommentData reply_obj;
  int index;
  ReplyPage2State({this.commentData,this.index,}):super();
  final TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _replyCommentdModel=ReplyCommentModel();
    myFocusNode = FocusNode();
  }
  @override
  void dispose() {
    super.dispose();
    if(_controller != null){
      _controller.dispose();
    }
  }
  @override
  Widget build(BuildContext context) {
    _userAuthModel= ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    _commentdModel = ScopedModel.of<BaseCommentModel>(context,rebuildOnChange: true);
    String reply_username;
    try{
      commentData=_commentdModel.commentList[index];
      reply_username=commentData.user.nickName;
      if(reply_obj!=null){
        reply_username=reply_obj.user.nickName;
      }
    }
    catch(e){
      print('error');
    }
//    String reply_username=commentData.user.nickName;


    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        leading: BackButton(color: Colors.black,),
        title: Text("回复详情", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),),
        backgroundColor: Colors.white,
      ),
      body:commentData!=null?Stack(
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
                  BBSDetailCommentCard(obj: commentData,index: index,),
                  new Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top:2,bottom: 2,left: 4),
                              child: Text('所有回复',style: TextStyle(color: Colors.black54),textAlign: TextAlign.left,),
                            ),
                          ),

                        ],
                      )
                  ),
                ]..addAll(reply_comments_builder(_replyCommentdModel.relayCommentList?.length??0)),
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
                                        onTap: (){_handle_send_reply_comment();}),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        )
                    ),
                  ],
                )
            ),
          ),
        ],
      ):Container(),
    );
  }
  @override
  Future load_more_data() {
    NetUtil.get(Api.REPLY_COMMENTS, (data) async{
      _replyCommentdModel.addAllComments(ReplyCommentList.fromJson(data).data);
      if(!this.mounted){
        return;
      }
      setState(() {

      });
      repayPage=repayPage+1;
    },
      params: {'comment':commentData.id,'page':repayPage,'ordering':'-date'},
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
    );
  }

  @override
  Future refresh_data() {
    NetUtil.get(Api.REPLY_COMMENTS, (data){
      _replyCommentdModel.commentList= ReplyCommentList.fromJson(data).data;
      if(!this.mounted)return;
      setState(() {
        loading=true;
      });
      repayPage=2;
    },
      params: {'comment':commentData.id,'page':1,'ordering':'-date'},
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
    );
  }
  List<Widget> reply_comments_builder(int length){
    List<Widget> widgets=[];
    for(int i=0;i<length;i++){
      widgets.add(
        ScopedModel(model: _replyCommentdModel, child: ReplyCommentCard(index: i,callback: set_reply_comment_id,))
      );
    }
    return widgets;
  }
  void set_reply_comment_id(ReplyCommentData obj){
    reply_obj=obj;
    if(!this.mounted){
      return;
    }
    setState(() {
    });
    FocusScope.of(context).requestFocus(myFocusNode);
  }
  void _handle_send_reply_comment(){
    String text=_controller.text;
    _controller.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    if(!this.mounted){
      return;
    }
    setState(() {
    });
    Map<String, dynamic> params={'text':text};
    params['reply_comment']=reply_obj?.id??'';
    params['comment']=commentData.id;
    NetUtil.post(Api.REPLY_COMMENTS, (data) {
      requestToast("评论成功");
      int id=data['id'];
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
      NetUtil.get(Api.REPLY_COMMENTS+id.toString()+'/', (data) {
        _replyCommentdModel.addBeginComment(ReplyCommentData.fromJson(data));
        reply_obj=null;
        NetUtil.get(Api.COMMENTS+this.commentData.id.toString()+'/', (data) {
          CommentData _commentData=CommentData.fromJson(data);
          _commentdModel.updateComment(_commentData,index);
          setState(() {
          });
        },
          headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
        );
      },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      );
      //TODO 界面显示数据
    },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
        params: params);

  }
}