import 'package:finerit_app_flutter/apps/bbs/components/bbs_card_icon.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_report_widget.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_user_head_wighet.dart';
import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/beans/comment_data_bean.dart';
import 'package:finerit_app_flutter/beans/reply_comment_data.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/global_config.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ReplyButton extends StatelessWidget{
  ReplyCommentData obj;
  CommentData base_obj;
  final TextEditingController _controller = new TextEditingController();
  UserAuthModel _userAuthModel;
  int index;
  ReplyButton({Key key
    ,this.obj
    ,this.index
    ,this.likeCallBack
    ,this.childCallback,this.base_obj}):super(key:key);
  void Function(int index) likeCallBack;
  void Function(ReplyCommentData obj,CommentData base_obj) childCallback;
  @override
  Widget build(BuildContext context) {
    _userAuthModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    return FlatButton(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BaseUserHead(
                userInfo: obj.user,
                radius: 14.0,
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
                      child: Text(obj.text,style: TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w400),),
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
                        icon: obj.like?Icons.favorite:FineritIcons.like,
                        number: obj.likeCount,iconSize: 12
                    ),
                    onTap:(){
                      if(likeCallBack!=null){
                        likeCallBack(index);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 750,
            child: Divider(
              height: 6,
            ),
          ),
        ],
      ),
      onPressed: (){
        if(this.childCallback!=null){
          childCallback(obj,base_obj);
        }
      },
    );
  }
}

