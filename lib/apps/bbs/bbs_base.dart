import 'package:finerit_app_flutter/apps/bbs/bbs_send.dart';
import 'package:finerit_app_flutter/apps/bbs/bbs_tabs.dart';
import 'package:finerit_app_flutter/apps/bbs/model/bbs_model.dart';
import 'package:finerit_app_flutter/commons/ui.dart';
import 'package:finerit_app_flutter/icons/icons_route2.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BBSApp extends StatefulWidget {
  StatusSystemdModel statusSystemdModel;
  StatusCommonModel statusCommonModel;
  BBSApp({Key key,this.statusSystemdModel,this.statusCommonModel}):super(key:key);
  @override
  State<StatefulWidget> createState() => BBSAppState(
      statusSystemdModel: statusSystemdModel,
      statusCommonModel: statusCommonModel,
  );
}



class BBSAppState extends State<BBSApp> with SingleTickerProviderStateMixin{
  BBSAppState({key
  ,this.statusCommonModel
  ,this.statusSystemdModel
  }):super();
  TabController _tabController;
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  StatusSystemdModel statusSystemdModel;
  StatusCommonModel statusCommonModel;
  MainStateModel baseModel;
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  Widget _buildAppBar(MainStateModel model) {
    return AppBar(
      centerTitle: true,
      title:
      new TabBar(
        tabs: <Widget>[
          Tab(text: "系统公告"),
          Tab(text: "用户公告"),
        ],

        indicatorColor: Colors.lightBlueAccent,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.black38,
        controller: _tabController,
        indicatorPadding: new EdgeInsets.only(bottom: 0.0),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: new CircleAvatar(
            radius: 20,
            backgroundImage: new NetworkImage(model.userInfo!=null?model.userInfo.headImg:""),
          ),
          onPressed: () {
            handle_head_event(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        Container(width: 50,)
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainStateModel>(
        builder: (context, widget,MainStateModel model){
          baseModel=model;
          BaseStatusModel statusModel=statusCommonModel;
          String phone=model.userInfo!=null?model.userInfo.phone:"";
          if(phone=="19999999999"){
            statusModel=statusSystemdModel;
          }
          return Scaffold(
            appBar: _buildAppBar(model),
            floatingActionButton: FloatingActionButton(
              child: const Icon(MyFlutterApp2.pen,size: 22,color: Colors.lightBlueAccent,),
              heroTag: null,
              foregroundColor: FineritColor.color1_normal,
              backgroundColor: Colors.white,
              elevation: 10.0,
              highlightElevation: 14.0,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> Talk(statusModel: statusModel,)
                ));
              },
              mini: true,
              shape: new CircleBorder(),
              isExtended: false,
            ),
            body:new TabBarView(
              controller: _tabController,
              children: <Widget>[
                ScopedModel<BaseStatusModel>(
                  model:statusSystemdModel,
                  child: BBSSystemTab(
                  ),
                ),
                ScopedModel<BaseStatusModel>(
                  model:statusCommonModel,
                  child: BBSCommonTab(),
                ),
              ],
            ),
          );

        }
    );

  }




}
