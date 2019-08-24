

import 'package:finerit_app_flutter/apps/message/components/message_replayitems.dart';
import 'package:finerit_app_flutter/beans/commuity_message_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/community_message_data_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:scoped_model/scoped_model.dart';

class MessageCommunityPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MessageCommunityPageState();
  }

}

class MessageCommunityPageState extends PageState<MessageCommunityPage>{
  CommunityMessageBaseModel communityMessageBaseModel;
  TextEditingController _controller=TextEditingController();
  UserAuthModel userAuthModel;
  String reply_username='';
  FocusNode myFocusNode=FocusNode();
  bool is_comment=true;
  CommunityMessageData communityMessageData;
  @override
  void dispose() {
    super.dispose();
    if(_controller != null){
      _controller.dispose();
    }
  }
  Widget get_cart_wighet(int index){
    return ReplayItems(communityMessageData:
    communityMessageBaseModel.communityMessageDataList[index],
    callback: handle_comment_option,);
  }
  Widget handle_main_wighet(){
    return Container(
      alignment: Alignment.topCenter,
      child: new EasyRefresh(
        autoLoad: true,
        firstRefresh:true,
        key: easyRefreshKey,
        refreshHeader: MaterialHeader(
          key: headerKey,
        ),
        refreshFooter: MaterialFooter(
          key: footerKey,
        ),
        child: new ListView.builder(
          //ListView的Item
            itemCount: communityMessageBaseModel.communityMessageDataList.length,
            itemBuilder: (BuildContext context, int index) {
              return get_cart_wighet(index);
            }),
        onRefresh: ()  {
          refresh_data();
        },
        loadMore: ()  {
          load_more_data();
        },
      ),
    );
  }
  Future load_more_data(){
    NetUtil.get(Api.COMMUNITY_MESSAGE, (data) {
      page=page+1;
      communityMessageBaseModel.addCommunityMessageDataAlls(CommunityMessageDataList.fromJson(data).data);
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'page':page},
    );
  }
  Future refresh_data(){
    NetUtil.get(Api.COMMUNITY_MESSAGE, (data) {
      page=2;
      communityMessageBaseModel.communityMessageDataList=CommunityMessageDataList.fromJson(data).data;
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {'page':1}
    );
  }
  @override
  Widget build(BuildContext context) {
    if(communityMessageData!=null){
      reply_username=communityMessageData.relateUser.nickName;
    }
    else{
      reply_username='';
    }
    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      communityMessageBaseModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    return new Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.grey[800],
          ),
          centerTitle: true,
          title: Text(
            "社区消息",
            style: TextStyle(color: Colors.grey[800]),
          ),
          backgroundColor: Colors.white,
        ),
        body:GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              is_comment=true;
            });
          },
          child: Stack(
            children: <Widget>[
              handle_main_wighet(),
              new Positioned(
                bottom: 0,
                left:0,
                width: MediaQuery.of(context).size.width,
                child: Offstage(
                  offstage: false,
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
                              offstage: is_comment,
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
                                                handle_type_reply();
                                              }),
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
              ),

            ],
          ),
        )
    );
  }
  void handle_type_reply(){
    FocusScope.of(context).requestFocus(FocusNode());
    if(!this.mounted){
      return;
    }
    setState(() {
      is_comment=true;
    });
    Map<String, dynamic> params={'text':_controller.text};
    params['reply_comment']=communityMessageData.replyId
        !=communityMessageData.relateId?communityMessageData.replyId
        :'';
    params['comment']=communityMessageData.relateId;
    NetUtil.post(Api.REPLY_COMMENTS, (data) {
      requestToast("回复成功");
      _controller.clear();
      communityMessageData=null;
    },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
        params: params);
  }
  void handle_comment_option(CommunityMessageData communityMessageData){
    FocusScope.of(context).requestFocus(myFocusNode);
    setState(() {
      this.communityMessageData=communityMessageData;
      is_comment=false;
    });
  }
}