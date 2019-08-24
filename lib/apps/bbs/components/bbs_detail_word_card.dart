import 'dart:io';

import 'package:finerit_app_flutter/apps/bbs/components/bbs_card_icon.dart';
import 'package:finerit_app_flutter/beans/status_data_bean.dart';
import 'package:finerit_app_flutter/extra_apps/chewie/lib/chewie.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_user_head_wighet.dart';
import 'package:finerit_app_flutter/apps/bbs/components/bbs_feedback_status_widget.dart';
import 'package:finerit_app_flutter/apps/components/image_grid_view.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/global_config.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:video_player/video_player.dart';

class BBSDetailWordCard extends StatefulWidget{
  StatusData obj;
  int index;
  BBSDetailWordCard({
    key
    ,@required this.obj
    ,this.index
  }):super(key: key);
  @override
  State<StatefulWidget> createState() =>BBSDetailWordCardState(obj:obj,index: index);

}

class BBSDetailWordCardState extends State<BBSDetailWordCard>{
  List<VideoPlayerController> _videoPlayerControllers=[];
  StatusData obj;
  int index;
  UserAuthModel _userAuthModel;
  BaseStatusModel _bbsModel;
  BBSDetailWordCardState({
    key
    ,@required this.obj
    ,this.index
  }):super();
  @override
  void dispose() {
    // TODO: implement
    for(var _videoPlayerController in _videoPlayerControllers){
      if(_videoPlayerController!=null){
        _videoPlayerController.dispose();
      }
    }
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    _bbsModel = ScopedModel.of<BaseStatusModel>(context,rebuildOnChange: true);
    _userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    obj=_bbsModel.getData()[index];
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
                      obj.text,
                      style: new TextStyle(height: 1.3, color: Colors.black87)
                  )
              ),
              new Container(
                child: ImageGridView(imageList: obj.images,),
              ),
              obj.video.length!=0?_get_vedio_wighet():Container(),
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
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(

                              child: BBSCardIconWidget(icon: obj.collect?FineritIcons.like2_on:FineritIcons.like2,number: obj.collectCount,iconSize: 14),
                              onTap:(){
                                _handle_like_oprate();
                              },
                            ),
                            GestureDetector(
                              child: BBSCardIconWidget(icon: FineritIcons.comment2,number: obj.commentCount,iconSize: 14),
                              onTap: (){
                                //评论
                              },
                            ),

                          ],
                        )
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10),
              ),
            ],
          ),
        )
    );
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
        padding: EdgeInsets.only(left: 15,right: 20),
      );
    }else if(Platform.isAndroid){
      return  Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 5),
        height: MediaQuery.of(context).size.height/1.6,
        width: MediaQuery.of(context).size.width/1.2 ,
        child: Chewie(
          _videoPlayerController,
          aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
          autoPlay: false,
          autoInitialize:true,
          looping: false,

        ),
        padding: EdgeInsets.only(left: 15,right: 20),
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
        padding: EdgeInsets.only(left: 15,right: 20),
      );

    }


  }
  void _handle_like_oprate(){
    obj.collect=!obj.collect;
    if(obj.collect){
      obj.collectCount=obj.collectCount+1;
    }
    else{
      obj.collectCount=obj.collectCount-1;
    }
    _bbsModel.update(obj, index);
    NetUtil.get(Api.STATUS_COLLECT+obj.id.toString()+'/', (data) async{
      NetUtil.get(Api.BBS_BASE+obj.id.toString()+'/', (data) async{

        var _obj = StatusData.fromJson(data);
        _bbsModel.update(_obj, index);
        //TODO 界面显示数据
      },
        headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      );
    },
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
    );

  }

}