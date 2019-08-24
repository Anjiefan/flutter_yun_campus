import 'dart:io';

import 'package:finerit_app_flutter/apps/bbs/components/bbs_card_icon.dart';
import 'package:finerit_app_flutter/beans/status_data_bean.dart';
import 'package:finerit_app_flutter/beans/team_message_data_bean.dart';
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
class MessageTeamCard extends StatefulWidget{
  int index;
  MessageTeamCard({
    key
    ,@required this.index
  }):super(key: key);
  @override
  State<StatefulWidget> createState()=>MessageTeamCardState(index: index);
}

class MessageTeamCardState extends State<MessageTeamCard>{
  List<VideoPlayerController> _videoPlayerControllers=[];
  int index;
  TeamMessageData obj;
  Widget widgetAchive;
  UserAuthModel _userAuthModel;
  TeamMessageBaseModel teamMessageBaseModel;
  bool loading=false;
  bool showMore=false;
  String text;
  MessageTeamCardState({
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
      teamMessageBaseModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    }

    if(loading==false){
      _userAuthModel = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);

      loading=true;
    }
    obj=teamMessageBaseModel.teamMessageDataList[index];
    if(showMore==false){
      text=obj.text.length>100?obj.text.substring(0,100):obj.text;
    }
    else{
      text=obj.text;
    }
    Widget vedioWidget;
    if(obj.video.length!=0){
      vedioWidget=_get_vedio_wighet();
    }
    widgetAchive=new Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 5.0),
        child:new Column(
          children: <Widget>[
            new Column(
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

}

