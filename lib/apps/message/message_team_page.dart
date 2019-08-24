
import 'package:finerit_app_flutter/apps/bbs/components/bbs_card.dart';
import 'package:finerit_app_flutter/apps/bbs/state/bbs_state.dart';
import 'package:finerit_app_flutter/apps/message/components/message_team_card.dart';
import 'package:finerit_app_flutter/beans/tean_message_data_list_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:scoped_model/scoped_model.dart';

class MessageTeamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MessageTeamState();
}

class MessageTeamState extends PageState<MessageTeamPage> {
  String type='系统广播';
  UserAuthModel userAuthModel;
  TeamMessageBaseModel teamMessageBaseModel;
  Widget get_cart_wighet(int index){
    return MessageTeamCard(index:index);
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
            itemCount: teamMessageBaseModel.teamMessageDataList.length,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Column(
                  children: <Widget>[
                    get_cart_wighet(index)
                  ],
                ),
              );
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
    NetUtil.get(Api.TEAM_MESSAGES, (data) {
      var itemList = TeamMessageDataList.fromJson(data);
      teamMessageBaseModel.addTeamMessageDataAlls(itemList.data);
      page=page+1;
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {"type": type,'page':page},
    );
  }
  Future refresh_data(){
    NetUtil.get(Api.TEAM_MESSAGES, (data) {
      var itemList = TeamMessageDataList.fromJson(data);
      teamMessageBaseModel.teamMessageDataList=itemList.data;
      if(!this.mounted){
        return;
      }
      setState(() {
        loading=true;
        page=2;
      });
    },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
        params: {"type": type,'page':1},
        );
  }
  @override
  Widget build(BuildContext context) {
    teamMessageBaseModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      loading=true;
    }
    return new Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.grey[800],
          ),
          title: Text(
            "团队通知",
            style: TextStyle(color: Colors.grey[800]),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body:handle_main_wighet()
    );
  }
}