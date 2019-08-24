import 'package:finerit_app_flutter/apps/contact/contact_search_friend.dart';
import 'package:finerit_app_flutter/apps/contact/contact_tabs_page.dart';
import 'package:finerit_app_flutter/apps/contact/models/contact_model.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactRequestPage extends StatefulWidget {
  GetRequestModel getRequestModel;
  SendRequestModel sendRequestModel;
  ContactRequestPage(
      {Key key,this.getRequestModel,this.sendRequestModel}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContactRequestPageState(getRequestModel: getRequestModel,sendRequestModel: sendRequestModel);
  }
}

class ContactRequestPageState extends State<ContactRequestPage> with SingleTickerProviderStateMixin{
  ContactRequestPageState({this.getRequestModel,this.sendRequestModel}):super();
  TabController _tabController;
  GetRequestModel getRequestModel;
  SendRequestModel sendRequestModel;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    return Scaffold(
      appBar: _buildAppBar(model),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          ScopedModel<FriendRequestBaseModel>(
            model:getRequestModel,
            child: GetRequestTab(),
          ),
          ScopedModel<FriendRequestBaseModel>(
            model:sendRequestModel,
            child: SendRequestTab(),
          ),
        ],
      ),
    );
  }
  Widget _buildAppBar(MainStateModel model) {
    return AppBar(
      title: new TabBar(
        tabs: <Widget>[
          Tab(text: "收到请求"),
          Tab(text: "发出请求"),
        ],
        indicatorColor: Colors.lightBlueAccent,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.black38,
        controller: _tabController,
        indicatorPadding: new EdgeInsets.only(bottom: 0.0),
      ),
      centerTitle: true,
      leading: BackButton(color: Colors.black,),
      backgroundColor: Colors.white,
      actions: <Widget>[
        IconButton(
          tooltip: "添加好友",
          icon: const Icon(MyFlutterApp.create2,size: 15,color: Colors.black),
          color: FineritColor.color1_normal,
          onPressed: _handleAddFriend,
        ),
      ],
    );
  }
  void _handleAddFriend() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>ScopedModel(model: ContactSearchUserModel(), child: ContactSearchFriendPage()),
      ),
    );
  }
}