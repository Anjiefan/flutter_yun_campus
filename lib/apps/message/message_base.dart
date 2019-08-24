
import 'dart:io';

import 'package:finerit_app_flutter/apps/bbs/model/bbs_model.dart';
import 'package:finerit_app_flutter/apps/components/head_avator_widget.dart';
import 'package:finerit_app_flutter/apps/components/message_point_widget.dart';
import 'package:finerit_app_flutter/apps/contact/contact_base.dart';
import 'package:finerit_app_flutter/apps/contact/contact_search_friend.dart';
import 'package:finerit_app_flutter/apps/contact/models/contact_model.dart';
import 'package:finerit_app_flutter/apps/im/im_base.dart';
import 'package:finerit_app_flutter/apps/im/im_utils.dart';
import 'package:finerit_app_flutter/apps/message/message_community_page.dart';
import 'package:finerit_app_flutter/apps/message/message_system_page.dart';
import 'package:finerit_app_flutter/apps/message/message_team_page.dart';
import 'package:finerit_app_flutter/beans/message_data_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/message_constant.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import "package:flutter/material.dart";
import 'package:collection/collection.dart' show lowerBound;
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class MessageApp extends StatefulWidget {
  final MethodChannel platformChannel;
  final FriendModel friendModel;
  const MessageApp({Key key, this.platformChannel,this.friendModel}) : super(key: key);
  @override
  State<StatefulWidget> createState() => MessageAppState(platformChannel: platformChannel,friendModel: friendModel);
}

class MessageAppState extends State<MessageApp> {
  MainStateModel model;
  final MethodChannel platformChannel;
  SlidableController slidableController;
  FriendModel friendModel;
  MessageBaseModel messageBaseModel;
  static const CHANNEL_UNIFIED_INVOKE =
  const MethodChannel("com.finerit.campus/unified/invoke");
  MessageAppState({this.platformChannel,this.friendModel});
  Widget _buildAppBar(MainStateModel model) {
    return AppBar(
      centerTitle: true,
      title: Text("消息", style: FineritStyle.style3,),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(MyFlutterApp4.mine,color: Colors.black,),
          onPressed: () {
            handle_contact_nav();
          },
        ),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        IconButton(
          tooltip: "添加好友",
          icon: const Icon(MyFlutterApp.create2,color: Colors.black,size: 15,),
          color: FineritColor.color1_normal,
          onPressed: _handleAddFriend,
        ),
      ],
    );
  }

  @protected
  void initState() {
    slidableController = new SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
  }


  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    model = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    messageBaseModel= ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    return new Scaffold(
      appBar: _buildAppBar(model),
      body: new Center(
        child: new OrientationBuilder(
          builder: (context, orientation) => _buildList(
              context,
              orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, Axis direction) {
    return new ListView.builder(
      scrollDirection: direction,
      itemBuilder: (context, index) {
        final Axis slidableDirection =
        direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
        return _getSlidableWithDelegates(context, index, slidableDirection);
      },
      itemCount: messageBaseModel.messagedataList.length,
    );
  }

  Widget _buildVerticalListItem(BuildContext context, int index) {
    MessageData item = messageBaseModel.messagedataList[index];
    return new Container(
      color: item.isTop?Colors.black12:Colors.white,
      child: InkWell(
        onTap: (){
          handle_message_type_nav(item,index);
        },
        child: new ListTile(
          leading: Container(
              height: 50,
              width: 50,
              child: BaseUserHead(
                userInfo: item.relateUser,
              )
          ),
          title: new Text(item.relateUser.nickName),
          subtitle: new Text(item.info),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(item.showDate),
              item.infoNum == 0?Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                width: 28,
                height: 14,
              ):
              GlobalMessagePoint(num: item.infoNum,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildhorizontalListItem(BuildContext context, int index) {
    MessageData item = messageBaseModel.messagedataList[index];
    return new Container(
      color: Colors.white,
      width: 160.0,
      child: InkWell(
        onTap: (){
          handle_message_type_nav(item,index);
        },
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Expanded(
                child:Container(
                  height: 50,
                  width: 50,
                  child:  BaseUserHead(
                    userInfo: item.relateUser,
                  ),
                )
            ),
            new Expanded(
              child: Center(
                child: new Text(
                  item.info,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _getSlidableWithDelegates(
      BuildContext context, int index, Axis direction) {
    MessageData item = messageBaseModel.messagedataList[index];
    int realIndex = index;
    print("this index=" + index.toString());
    return new Slidable.builder(
      key: new Key(item.relateUser.nickName),
      controller: slidableController,
      direction: direction,
      delegate: SlidableBehindDelegate(),
      actionExtentRatio: 0.25,
      child:
//      _buildVerticalListItem(context, index),
      direction == Axis.horizontal
          ? _buildVerticalListItem(context, index)
          : _buildhorizontalListItem(context, index),
      secondaryActionDelegate: new SlideActionBuilderDelegate(
          actionCount: 2,
          builder: (context, index, animation, renderingMode) {
            if (index == 0) {
              return new IconSlideAction(
                caption: item.isTop?'取消置顶':"置顶",
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.grey.shade200.withOpacity(animation.value)
                    : Colors.grey.shade200,
                icon: Icons.arrow_upward,
                onTap: () => showTop(item, realIndex),
                closeOnTap: true,
              );
            } else {
              return new IconSlideAction(
                caption: '删除',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.red.withOpacity(animation.value)
                    : Colors.red,
                icon: Icons.delete,
                onTap: () => hideItem(item,realIndex),
                closeOnTap: true,
              );
            }
          }),
    );
  }


  void _handleAddFriend() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScopedModel(model: ContactSearchUserModel(), child: ContactSearchFriendPage()),
      ),
    );
  }
  void handle_seem_message(MessageData item, int index){
    item.infoNum=0;
    messageBaseModel.updateMessage(item, index);
    NetUtil.put(Api.MESSAGES+item.id.toString()+'/', (data) {
    },
        headers: {"Authorization": "Token ${model.session_token}"},
        params: {
          'info_num':'0'
        }
    );
  }
  void handle_message_type_nav(MessageData item,int index){
    handle_seem_message(item,index);
    switch(item.type){
      case MessageConstant.IM:
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => ImApp.name(model.objectId, item.relateUser.id, false))
//        );
        handle_im_go(context, model.objectId,item.relateUser.id,false);
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => ImApp.name(model.objectId, item.relateUser.id, false))
//        );
//        if(Platform.isIOS){
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) => ImApp.name(model.objectId, item.relateUser.id, false))
//          );
////                                    requestToast('聊天功能IOS版本尚未上线，可使用安卓端');
//        }
//        else{
//          CHANNEL_UNIFIED_INVOKE.invokeMethod("openChatKit", [model.objectId+'～00', item.relateUser.id+'～00']);
//        }
//        if(Platform.isIOS){
//          requestToast('聊天功能IOS版本尚未上线，可使用安卓端');
//        }
//        else{
//          platformChannel.invokeMethod("openChatKit", [model.objectId, item.relateUser.id]);
//        }

        break;
      case MessageConstant.COMMUNITY:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new MessageCommunityPage()
            )
        );
        break;
      case MessageConstant.COURSE:
//        if(Platform.isIOS){
//          requestToast('聊天功能IOS版本尚未上线，可使用安卓端');
//        }
//        else{
//          platformChannel.invokeMethod("openChatKit", [model.objectId, item.relateUser.id]);
//        }
        handle_im_go(context, model.objectId,item.relateUser.id,false);
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => ImApp.name(model.objectId,item.relateUser.id, false))
//        );
//        if(Platform.isIOS){
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) => ImApp.name(model.objectId,item.relateUser.id, false))
//          );
////                                    requestToast('聊天功能IOS版本尚未上线，可使用安卓端');
//        }
//        else{
//          CHANNEL_UNIFIED_INVOKE.invokeMethod("openChatKit", [model.objectId+'～00',item.relateUser.id+'～00']);
//        }
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => ImApp.name(model.objectId,item.relateUser.id, false))
//        );

        break;
      case MessageConstant.SYSTEM:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>ScopedModel<BaseStatusModel>(model: TemporaryStatusModel()
                , child:  new MessageSystemPage())
            )
        );
        break;
      case MessageConstant.TEAM:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>ScopedModel<BaseStatusModel>(model: TemporaryStatusModel()
                , child:  new MessageTeamPage())
            )
        );
        break;
    }
  }

  showTop(MessageData item, int index) {
    item.isTop = !item.isTop;
    messageBaseModel.updateMessage(item, index);
    NetUtil.put(Api.MESSAGES+item.id.toString()+'/', (data) {
    },
        headers: {"Authorization": "Token ${model.session_token}"},
        params: {
          'is_top':item.isTop
        }
    );
  }

  hideItem(MessageData item, int index) {
    item.isShow=false;
    messageBaseModel.updateMessage(item, index);
    NetUtil.put(Api.MESSAGES+item.id.toString()+'/', (data) {
    },
        headers: {"Authorization": "Token ${model.session_token}"},
        params: {
          'is_show':false
        }
    );
  }
  handle_contact_nav(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>ScopedModel<BaseStatusModel>(model: TemporaryStatusModel()
            , child:  ContactApp(
            platformChannel: CHANNEL_UNIFIED_INVOKE,
            sendRequestModel: SendRequestModel(),
            getRequestModel: GetRequestModel(),
            friendModel: friendModel,
          ),)
        )
    );
  }
}

