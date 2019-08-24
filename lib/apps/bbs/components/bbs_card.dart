import 'dart:io';

import 'package:finerit_app_flutter/apps/bbs/components/bbs_card_icon.dart';
import 'package:finerit_app_flutter/beans/status_data_bean.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/extra_apps/chewie/lib/chewie.dart';
import 'package:finerit_app_flutter/apps/bbs/bbs_replay.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_feedback_status_widget.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_user_head_wighet.dart';
import 'package:finerit_app_flutter/apps/components/image_grid_view.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';

import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:video_player/video_player.dart';
class BBSCard extends StatefulWidget{
  int index;
  BBSCard({
    key
    ,@required this.index
  }):super(key: key);
  @override
  State<StatefulWidget> createState()=>BBSCardState(index: index);
}

class BBSCardState extends State<BBSCard>{
  List<VideoPlayerController> _videoPlayerControllers=[];
  int index;
  StatusData obj;
  Widget widgetAchive;
  UserAuthModel _userAuthModel;
  BaseStatusModel _bbsModel;
  bool loading=false;
  bool showMore=false;
  String text;
  BBSCardState({
    key
    ,this.index
  }):super();
  @override
  void dispose() {
    // TODO: implement dispose
    for(var _videoPlayerController in _videoPlayerControllers){
      if(_videoPlayerController!=null){
        _videoPlayerController.dispose();
      }
    }
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(loading==false){
      _bbsModel = ScopedModel.of<BaseStatusModel>(context,rebuildOnChange: true);
    }

    if(loading==false){
      _userAuthModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);



    }
    obj=_bbsModel.getData()[index];
    if(showMore==false){
      text=obj.text.length>100?obj.text.substring(0,100):obj.text;
    }
    else{
      text=obj.text;
    }
    if(loading==false){
      NetUtil.post(Api.STATUS_BROWSE, (data){
        NetUtil.get(Api.BBS_BASE+obj.id.toString()+'/', (data) {

          var _obj = StatusData.fromJson(data);
          _bbsModel.update(_obj, index);
          //TODO 界面显示数据
        },
          headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
        );
      },headers: {"Authorization": "Token ${_userAuthModel.session_token}"}
          ,params: {'status':obj.id},errorCallBack: (){});
      loading=true;
    }
    Widget vedioWidget;
    if(obj.video.length!=0){
      vedioWidget=_get_vedio_wighet();
    }
    widgetAchive=new Container(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 5.0),
        child:new Column(
          children: <Widget>[
            new FlatButton(
              onPressed: (){
                _handle_detail_status(obj,index);
              },
              padding:EdgeInsets.only(left: 10,top: 12,right: 8),
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
                              FeedBackWidgetStatus(index: index,obj: obj,bbsModel: _bbsModel,),
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
                          text,
                          style: new TextStyle(fontSize: 16, color: Colors.black87,fontWeight: FontWeight.w400)
                      )
                  ),
                  obj.text.length>100?new GestureDetector(
                    child: showMore==false?new Container(
                        margin: EdgeInsets.only(left: 4),
                        child:Row(
                          children: <Widget>[
                            Text("展开",style: TextStyle(fontSize: 16,color: Colors.black45,fontWeight: FontWeight.w300),),
                          ],
                        )
                    ):new Container(
                        margin: EdgeInsets.only(left: 4,top: 3),
                        child:Row(
                          children: <Widget>[
                            Text("收起",style: TextStyle(fontSize: 16,color: Colors.black45,fontWeight: FontWeight.w300),),

                          ],
                        )
                    ),
                    onTap: (){
                      handle_show_or_hide();
                    },
                  ):Container(),
                  new Container(
                    child: ImageGridView(imageList: obj.images,),
                  ),
                  obj.video.length!=0?
                  vedioWidget:Container(),
                ],
              ),
            ),

            new Container(
              child: new Row(
                children: <Widget>[
                  Container(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        BBSCardIconWidget(icon: FineritIcons.look, number: obj.browseCount, iconSize: 14,),
                        BBSCardIconWidget(icon: FineritIcons.money, number: obj.finerCode, iconSize: 14,),

                      ],
                    ),
                  ),
                  new Expanded(
                      child:
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(

                              child: BBSCardIconWidget(icon: obj.collect?FineritIcons.like2_on:FineritIcons.like2,number: obj.collectCount,iconSize: 14),
                              onTap:(){
                                _handle_like_oprate(obj,index);
                              },
                            ),
                            GestureDetector(
                              child: BBSCardIconWidget(icon: FineritIcons.comment2,number: obj.commentCount,iconSize: 13),
                              onTap: (){
                                _handle_detail_status_to_comment(obj,index);
                              },
                            ),

                          ],
                        ),
                      )
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10),
            ),
          ],
        )

    );
    return widgetAchive;
  }
  void handle_show_or_hide(){
    if(showMore==true){
      if(!this.mounted){
        return;
      }
      setState(() {
        showMore=!showMore;
      });
      return;
    }
    else{
      if(!this.mounted){
        return;
      }
      setState(() {
        showMore=!showMore;
      });
      return;
    }

  }
  Widget _get_vedio_wighet(){
    VideoPlayerController _videoPlayerController=VideoPlayerController.network(obj.video[0]);
    _videoPlayerControllers.add(_videoPlayerController);
    if(Platform.isIOS){
      return  Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 5),
        height: MediaQuery.of(context).size.height/1.6,
        width: MediaQuery.of(context).size.width/1.6 ,
        child: Chewie(
          _videoPlayerController,
          aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
          autoPlay: false,
          autoInitialize:true,
          looping: false,
        ),
      );
    }else if(Platform.isAndroid){
      return  Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 5),
        height: MediaQuery.of(context).size.height/1.6,
        width: MediaQuery.of(context).size.width/1.3 ,
        child: Chewie(
          _videoPlayerController,
          aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
          autoPlay: false,
          autoInitialize:true,
          looping: false,

        ),
      );
    }
    else{
      return  Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 5),
        height: MediaQuery.of(context).size.height/1.6,
        width: MediaQuery.of(context).size.width/1.3 ,
        child: Chewie(
          _videoPlayerController,
          aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
          autoPlay: false,
          autoInitialize:true,
          looping: false,
        ),
      );
    }
  }
  void _handle_like_oprate(StatusData obj,int index){
    obj.collect=!obj.collect;
    if(obj.collect){
      obj.collectCount=obj.collectCount+1;
    }
    else{
      obj.collectCount=obj.collectCount-1;
    }
    _bbsModel.update(obj, index);
    NetUtil.post(Api.STATUS_COLLECT, (data) async{
      if(data['is_collect']==true){
        requestToast("收藏成功");
      }
      else{
        requestToast("取消收藏");
      }
      NetUtil.get(Api.BBS_BASE+obj.id.toString()+'/', (data) async{
        var _obj = StatusData.fromJson(data);
        _bbsModel.update(_obj, index);
        //TODO 界面显示数据
      },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}",
        },
      );
    },
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
        params:{'status':obj.id}
    );

  }
  void _handle_detail_status(StatusData obj,int index){
    for(var _videoPlayerController in _videoPlayerControllers){
      if(_videoPlayerController!=null){
        _videoPlayerController.pause();
      }
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=>
            ScopedModel<BaseStatusModel>(
              model: _bbsModel,
              child: ReplyPage(bbsDetailItem: obj,index:index),
            )
    ));
  }
  void _handle_detail_status_to_comment(StatusData obj,int index){
    for(var _videoPlayerController in _videoPlayerControllers){
      if(_videoPlayerController!=null){
        _videoPlayerController.pause();
      }
    }
    NetUtil.get(Api.BBS_BASE+obj.id.toString()+'/', (data) async{

      var _obj = StatusData.fromJson(data);
      _bbsModel.update(_obj, index);
      //TODO 界面显示数据
    },
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
    );
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=>
            ScopedModel<BaseStatusModel>(
              model: _bbsModel,
              child: ReplyPage(bbsDetailItem: obj,index:index,comment: true,),
            )
    ));
  }

}

