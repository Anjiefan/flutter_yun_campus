import 'dart:io';
import 'package:finerit_app_flutter/apps/components/vip_discript_widget.dart';
import 'package:finerit_app_flutter/apps/components/web.dart';
import 'package:finerit_app_flutter/apps/im/im_base.dart';
import 'package:finerit_app_flutter/apps/im/im_utils.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_horizontal_divider_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_message_point_widget.dart';
import 'package:finerit_app_flutter/apps/money/money_base.dart';
import 'package:finerit_app_flutter/apps/money/money_base_ios.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_column_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_row_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_vertical_divider_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_svip_icon.dart';
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/profile_blacklist_page.dart';
import 'package:finerit_app_flutter/apps/profile/profile_collect_page.dart';
import 'package:finerit_app_flutter/apps/profile/profile_earn_guide_page.dart';
import 'package:finerit_app_flutter/apps/profile/profile_erweima_page.dart';
import 'package:finerit_app_flutter/apps/profile/profile_guangbo_page.dart';
import 'package:finerit_app_flutter/apps/profile/profile_jingyan_page.dart';
import 'package:finerit_app_flutter/apps/profile/profile_level_guide_page.dart';
import 'package:finerit_app_flutter/apps/profile/profile_settings.dart';
import 'package:finerit_app_flutter/apps/profile/profile_shouru_page.dart';
import 'package:finerit_app_flutter/apps/profile/profile_userinfo_page.dart';
import 'package:finerit_app_flutter/apps/profile/profile_vip_dredge_page.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/dicts.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/icons/icons_route3.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/profile_level_icon.dart';
import 'components/proflie_vip_icon.dart';
import 'profile_rank_page.dart';
import 'profile_team_page.dart';

class ProfileApp extends StatefulWidget {
  static const routeName = "/profile";
  StatusShouCangModel statusShouCangModel;
  StatusSelfModel statusSelfModel;
  InviteBaseFirst inviteBaseFirst;
  InviteBaseSecond inviteBaseSecond;

  ProfileApp(
      {Key key,
      this.statusSelfModel,
      this.statusShouCangModel,
      this.inviteBaseSecond,
      this.inviteBaseFirst})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileAppState(
      statusSelfModel: statusSelfModel,
      statusShouCangModel: statusShouCangModel,
      inviteBaseFirst: inviteBaseFirst,
      inviteBaseSecond: inviteBaseSecond);
}

class ProfileAppState extends PageState<ProfileApp> {
  UserAuthModel _userAuthModel;
  MainStateModel model;
  static const CHANNEL_SHARE =
      const MethodChannel("com.finerit.campus/share/invoke");

//  static const FANKUI_CHANAL_NUM=
//  const MethodChannel("com.finerit.campus/fankui/num");
//  static const FANKUI_CHANAL_INVOKE=
//  const MethodChannel("com.finerit.campus/fankui/invoke");
  static const CHANNEL_UNIFIED_INVOKE =
      const MethodChannel("com.finerit.campus/unified/invoke");
  int fankuiNum = 0;
  bool loadingFrendInfo = false;
  String headImg = "";
  String nickName = "";
  UserInfoModel userInfoModel;
  bool ioshide = false;
  StatusShouCangModel statusShouCangModel;
  StatusSelfModel statusSelfModel;
  ProfileEarnModel profileEarnModel;
  InviteBaseFirst inviteBaseFirst;
  InviteBaseSecond inviteBaseSecond;
  TeamBaseModel teamBaseModel;

  ProfileAppState(
      {Key key,
      this.statusShouCangModel,
      this.statusSelfModel,
      this.inviteBaseFirst,
      this.inviteBaseSecond})
      : super();
  EarnSumInfoBaseMode earnSumInfoBaseMode;
  bool hasFather = false;

  @override
  initState() {
    super.initState();
    profileEarnModel = ProfileEarnModel();
  }

//  Future initFankuiNum() async {
//    int _fankuiNum=await FANKUI_CHANAL_NUM.invokeMethod("fankuinum");
//    if(!this.mounted){
//      return;
//    }
//    setState(() {
//      fankuiNum = _fankuiNum;
//    });
//  }
  void initEarnInfo() {
    NetUtil.get(Api.EARN_SUM, (data) {
      earnSumInfoBaseMode.setEarnSumData(
          data['yesterday_sum'], data['day_sum'], data['mouth_sum']);
    }, headers: {"Authorization": "Token ${_userAuthModel.session_token}"});
  }

  @override
  Widget build(BuildContext context) {
    if (loadingFrendInfo == false) {
      _userAuthModel =
          ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
      userInfoModel =
          ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
      model = ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
      earnSumInfoBaseMode =
          ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
//      initFankuiNum();
      initEarnInfo();
      loadingFrendInfo = true;
      teamBaseModel =
          ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
      if (teamBaseModel.teamInfo == null) {
        hasFather = false;
      } else if (teamBaseModel.teamInfo.data.length == 0) {
        hasFather = false;
      } else {
        hasFather = true;
      }
    }
    if (Platform.isIOS && model.ifshowios == false) {
      ioshide = true;
    }
    return model.ifshowios == true || Platform.isAndroid
        ? Scaffold(
            body: EasyRefresh(
              firstRefresh: true,
              key: easyRefreshKey,
              refreshHeader: MaterialHeader(
                key: headerKey,
              ),
              refreshFooter: MaterialFooter(
                key: footerKey,
              ),
              behavior: ScrollOverBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildTopCard(model),
                    _buildBanner(),
                    _buildMidCard(),
                    _buildBottomCard(),
                  ],
                ),
              ),
              onRefresh: () {
                refresh_data();
                if (hasFather == false) {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (context, a, b) => AlertDialog(
                          title: Text(
                            '提示',
                            style: TextStyle(fontSize: 16),
                          ),
                          content: Container(
                            child: Text(
                                "您还没有设置邀请人，如果您的邀请人是VIP，您将会共享VIP权限。如果您是VIP，您邀请的人消费或者做兼职您将获得分成。"),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('暂不设置'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text('设置邀请人'),
                              onPressed: () async {
                                Navigator.pop(context);
                                _handle_team_nav();
                              },
                            ),
                          ],
                        ),
                    barrierDismissible: false,
                    barrierLabel: '删除微文',
                    transitionDuration: Duration(milliseconds: 400),
                  );
                }
              },
              loadMore: () {
                load_more_data();
              },
            ),
          )
        : Scaffold(
            body: EasyRefresh(
              firstRefresh: true,
              key: easyRefreshKey,
              refreshHeader: MaterialHeader(
                key: headerKey,
              ),
              refreshFooter: MaterialFooter(
                key: footerKey,
              ),
              behavior: ScrollOverBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildTopCard(model),
                    _buildBottomCard(),
                  ],
                ),
              ),
              onRefresh: () {
                refresh_data();
              },
              loadMore: () {
                load_more_data();
              },
            ),
          );
  }

/****************************************************************************/
  //构建顶部功能模块
  Container _buildTopCard(MainStateModel model) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue,
              Colors.white,
            ]),
      ),
      margin: EdgeInsets.all(0),
      height: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //basic profile
          _buildBasicProfile(model),
          //social bar
          _buildSocialBar(),
        ],
      ),
    );
  }

  //构建功能模块：广播、团队、钱包、收藏
  Container _buildSocialBar() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 0),
                    blurRadius: 6.0,
                    spreadRadius: 2.0),
              ],
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: ProfileRowWidget(
                    icon: FineritIcons.article,
                    text: "公告",
                    callback: _handle_broadcast_nav,
                  ),
                ),
                new ProfileVerticalDividerWidget(
                  height: 42,
                ),
                Expanded(
                  child: ProfileRowWidget(
                    icon: MyFlutterApp3.chart,
                    text: "团队",
                    callback: _handle_team_nav,
                  ),
                ),
                new ProfileVerticalDividerWidget(
                  height: 42,
                ),
                Expanded(
                  child: ProfileRowWidget(
                    icon: MyFlutterApp4.wallet2,
                    text: "钱包",
                    callback: _handle_money_nav,
                  ),
                ),
                new ProfileVerticalDividerWidget(
                  height: 42,
                ),
                Expanded(
                  child: ProfileRowWidget(
                    icon: MyFlutterApp4.like2,
                    text: "会员",
                    callback: handle_vip,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //构建个人信息栏
  Container _buildBasicProfile(MainStateModel model) {
    if (userInfoModel.userInfo.experience == null) {
      userInfoModel.userInfo.experience = 0;
    }
    return Container(
      margin: EdgeInsets.only(top: 40),
      height: 120,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(model.userInfo.headImg),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      width: 0.0,
                    ),
                  ),
                ),
                onTap: () {
                  handle_profile_detail_nav();
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          new Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Column(
                  children: <Widget>[
                    new Container(
                        child: new Row(
                      children: <Widget>[
                        Text(userInfoModel.userInfo.nickName,
                            style:
                                TextStyle(color: Colors.black, fontSize: 14)),
                        Container(
                          width: 2,
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 2,
                            ),
                            child: LevelIcon(
                                level:
                                    "${userInfoModel.userInfo.level?.levelDesignation ?? '小班'}",
                                iconsize: 1,
                                color: Colors.white,
                                biglevel:
                                    "${userInfoModel.userInfo.level?.bigLevelDesignation ?? '幼稚园'}"),
                          ),
                          onTap: () {
                            handle_level_guide_nav();
                          },
                        ),
                        Container(
                          width: 2,
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 1, top: 2),
                            child: (userInfoModel.userInfo.vipInfo?.isAnnual ??
                                        false) ==
                                    false
                                ? VipIcon(
                                    viplevel:
                                        "${userInfoModel.userInfo.vipInfo?.levelDesignation ?? 0}",
                                    iconsize: 0.6,
                                    isOpen: userInfoModel
                                            .userInfo.vipInfo?.isOpening ??
                                        false,
                                  )
                                : SVipIcon(
                                    viplevel:
                                        "${userInfoModel.userInfo.vipInfo?.levelDesignation ?? 0}",
                                    iconsize: 0.6,
                                  ),
                          ),
                          onTap: () {
                            handle_vip();
                          },
                        )
                      ],
                    )),
                    new Container(
                      margin: EdgeInsets.only(top: 5),
                      child: new Row(
                        children: <Widget>[
                          Text(
                            "${userInfoModel.userInfo.id.substring(0, 8)}****",
                            style: new TextStyle(fontSize: 12),
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              padding: EdgeInsets.only(
                                  bottom: 2.5, top: 1, left: 2.5, right: 1.5),
                              child: new Text(" 复制邀请码 ",
                                  style: TextStyle(
                                      color: Colors.black26, fontSize: 10)),
                              decoration: new BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onTap: handle_copy_id,
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              padding: EdgeInsets.only(
                                  bottom: 2.5, top: 1, left: 2.5, right: 1.5),
                              child: new Text(" 生成二维码 ",
                                  style: TextStyle(
                                      color: Colors.black26, fontSize: 10)),
                              decoration: new BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onTap: () {
                              handle_erweima_page();
                            },
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(right: 4, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            userInfoModel.userInfo.experience.toDouble() >=
                                    10000
                                ? Text(
                                    "EXP ${(userInfoModel.userInfo.experience.toDouble() / 10000).floorToDouble()}万",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black87),
                                  )
                                : Text(
                                    "EXP ${userInfoModel.userInfo.experience}",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black87),
                                  ),
                            Icon(
                              Icons.arrow_right,
                              size: 16,
                              color: Colors.black87,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        handle_jingyan_nav();
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Expanded(
            child: new Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 27, right: 15),
                    padding: EdgeInsets.only(
                        bottom: 3.5, top: 1.5, left: 3.5, right: 3.5),
                    child: new Text(" 签到 ",
                        style: TextStyle(
                            color: Colors.lightBlueAccent, fontSize: 14)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onTap: () {
                    _handle_qiandao();
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ),
        ],
      ),
    );
  }

/****************************************************************************/

  //构建banner广告
  Widget _buildBanner() {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 0),
                  blurRadius: 6.0,
                  spreadRadius: 2.0),
            ],
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          child: Image(
            image: new AssetImage('assets/profile/base/banner.png'),
          )),
      onTap: () {
        handle_guide_nav();
      },
    );
  }

  //构建收入模块
  Container _buildMidCard() {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              blurRadius: 6.0,
              spreadRadius: 2.0),
        ],
        borderRadius: BorderRadius.circular(14.0),
        color: Colors.white,
      ),
      height: 150,
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 6, left: 16),
                child: new Text("我的收入"),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Text("查看详情"),
                      ),
                      onTap: () {
                        _handle_earn_page();
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(top: 8, right: 10),
                        child: Icon(
                          Icons.navigate_next,
                          size: 20,
                          color: Colors.black38,
                        ),
                      ),
                      onTap: () {
                        _handle_earn_page();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              HorizontalDivider(
                width: MediaQuery.of(context).size.width - 44,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Image(
                              width: 70,
                              height: 60,
                              image: earnSumInfoBaseMode.day_sum >
                                      earnSumInfoBaseMode.yesterday_sum
                                  ? new AssetImage(
                                      'assets/profile/base/graph2/higher.png')
                                  : new AssetImage(
                                      'assets/profile/base/graph2/lower.png'),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            child: new Text(
                              "今日收入:",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6.5),
                            child: new Text(
                                earnSumInfoBaseMode.day_sum.toString(),
                                style: TextStyle(
                                    fontSize: 13, color: Colors.teal)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Image(
                              width: 70,
                              height: 60,
                              image: new AssetImage(
                                  'assets/profile/base/graph2/standard.png'),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            child: new Text(
                              "昨日收入:",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6.5),
                            child: new Text(
                                earnSumInfoBaseMode.yesterday_sum.toString(),
                                style: TextStyle(
                                    fontSize: 13, color: Colors.blueAccent)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Image(
                              width: 70,
                              height: 60,
                              image: new AssetImage(
                                  'assets/profile/base/graph2/current.png'),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            child: new Text(
                              "本月收入:",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6.5),
                            child: new Text(
                                earnSumInfoBaseMode.month_sum.toString(),
                                style: TextStyle(
                                    fontSize: 13, color: Colors.teal)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handle_jingyan_nav() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileJingYanPage()));
  }

  void handle_level_guide_nav() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileLevelGuideApp(
                  url:
                      '${Api.BASE_URL}${Api.INTRODUCE}?userid=${_userAuthModel.objectId}',
//        'http://7326qw.natappfree.cc/introduce.html',
                )));
  }

  void handle_vip() {
    Widget appWidget;
    appWidget = VIPDredgePage();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => appWidget,
      ),
    );
  }

  void handle_guide_nav() {
    NetUtil.get(Api.GUIDE_GATHER, (data) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebApp(
              url: data['url'],
              appBar: new AppBar(
                title: Text(
                  '赚钱教程',
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                leading: BackButton(
                  color: Colors.grey[800],
                ),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  Container(
                    child: FlatButton.icon(
                      onPressed: () async {
                        if (await canLaunch(data['url'])) {
                          await launch(data['url']);
                        } else {
                          throw 'Could not launch ${data['url']}';
                        }
                      },
                      icon: Icon(
                        Icons.language,
                        color: Colors.black,
                      ),
                      label: Text(
                        '浏览器打开',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );
    },
        params: {'type': 'zhuan_qian'},
        headers: {"Authorization": "Token ${model.session_token}"});
//    Navigator.push(context,
//        MaterialPageRoute(builder: (context) => ProfileEarnGuideApp(url: '${Api.BASE_URL}${Api.GUIDE}',))
//    );
  }

  //构建底部功能条
  Container _buildBottomCard() {
    return Container(
      child: Column(
        children: <Widget>[
          model.ifshowios == true || Platform.isAndroid
              ? ProfileCommenWidget(
                  icon: MyFlutterApp4.rank,
                  text: '收入排行',
                  callback: () {
                    _handle_rank_nav();
                  },
                )
              : Container(),
          ProfileCommenWidget(
            icon: MyFlutterApp4.money,
            text: '兼职任务',
            callback: () {
              _handle_jianzhi_nav();
            },
          ),
          ProfileCommenWidget(
            icon: MyFlutterApp3.share,
            text: '有奖分享',
            callback: () {
              _handle_share();
            },
          ),
          ProfileCommenWidget(
            icon: MyFlutterApp4.like2,
            text: '我的收藏',
            callback: () {
              _handle_collect_nav();
            },
          ),
          ProfileCommenWidget(
            icon: MyFlutterApp4.alteruser,
            text: '切换账号',
            callback: () async {
              await model.logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, "/welcome", (route) => route == null);
            },
          ),
          ProfileCommenWidget(
            icon: MyFlutterApp3.feedback,
            text: '在线反馈',
            callback: () {
              _handle_fankui();
            },
            message: MessagePointWidget(
              num: fankuiNum,
            ),
          ),
          ProfileCommenWidget(
            icon: MyFlutterApp3.settings,
            text: '应用设置',
            callback: () {
              _handle_settings();
            },
            message: MessagePointWidget(
              num: fankuiNum,
            ),
          ),
        ],
      ),
    );
  }

  Future _handle_fankui() async {
    handle_im_go(context, model.objectId,'5ce2aba8c8959c0069b44e43',true);
//    if (Platform.isAndroid) {
//      var url = "https://im.finerit.com/#!/login/" +
//          model.objectId +
//          "~00" +
//          "/" +
//          '5ce2aba8c8959c0069b44e43' +
//          "~00";
//      if (await canLaunch(url)) {
//        await launch(url);
//      } else {
//        throw 'Could not launch ${url}';
//      }
//    }
//    if(Platform.isIOS){
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//                  ImApp.name(model.objectId, '5ce2aba8c8959c0069b44e43', true)));
//    }
//    if(Platform.isIOS){
////      Navigator.push(context,
////          MaterialPageRoute(builder: (context) => ImApp.name(model.objectId, '5ce2aba8c8959c0069b44e43', true))
////      );
////    }
////    else{
////
////      CHANNEL_UNIFIED_INVOKE.invokeMethod("openChatKit", [model.objectId+'～00', '5ce2aba8c8959c0069b44e43～00']);
////    }
  }

  void _handle_qiandao() {
    NetUtil.get(
      Api.USER_SIGN,
      (data) {
        requestToast(data['info']);
      },
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
    );
  }

  void _handle_team_nav() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileTeamPage(
                inviteBaseFirst: inviteBaseFirst,
                inviteBaseSecond: inviteBaseSecond,
              ),
        ));
  }

  void _handle_earn_page() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScopedModel<BaseEarnModel>(
            model: profileEarnModel, child: ProfileEarnPage()),
      ),
    );
  }

  void _handle_broadcast_nav() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScopedModel<BaseStatusModel>(
            model: statusSelfModel, child: ProfileGuangboPage()),
      ),
    );
  }

  void _handle_money_nav() {
    Widget appWidget;
    if (Platform.isIOS) {
      appWidget = MoneyAppIOS(
        iosPayShow: model.ifshowios,
      );
    } else if (Platform.isAndroid) {
      appWidget = MoneyApp();
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => appWidget,
      ),
    );
  }

  void _handle_rank_nav() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RankPage(),
        ));
  }

  void _handle_jianzhi_nav() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebApp(
                url: 'https://hwapp.finerit.com/job/qqz_join/'
                    '?status=3&session_token=${model.session_token}',
                appBar: new AppBar(
                  title: const Text(
                    '兼职任务',
                    style: TextStyle(color: Colors.black),
                  ),
                  centerTitle: true,
                  leading: BackButton(
                    color: Colors.grey[800],
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
        ));
  }

  void _handle_collect_nav() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScopedModel<BaseStatusModel>(
            model: statusShouCangModel, child: ProfileCollectPage()),
      ),
    );
  }

  void _handle_settings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Settings(),
      ),
    );
  }

  Future _handle_share() async {
    var event = await CHANNEL_SHARE.invokeMethod("doShare", [model.objectId]);
    if (event == "-1") {
      print("转发失败");
      return;
    }
    String task = Dicts.TASK_STARE_CHIVE[event];
    if (task == null) {
      return;
    }
    NetUtil.get(
      Api.SHARE,
      (data) {
        print(data);
        print("分享成功！");
      },
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
      params: {"taskid": task},
    );
  }

  void handle_copy_id() {
    requestToast("复制邀请码成功");
    Clipboard.setData(new ClipboardData(text: userInfoModel.userInfo.id));
  }

  void handle_erweima_page() {
    NetUtil.get(
      Api.TEAM_ERWEIMA,
      (data) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ErweimaPage(
                  url: data['info'],
                ),
          ),
        );
      },
      headers: {"Authorization": "Token ${_userAuthModel.session_token}"},
    );
  }

  void handle_profile_detail_nav() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileUserPage(
              statusShouCangModel: statusShouCangModel,
              statusSelfModel: statusSelfModel,
              user: userInfoModel.userInfo,
            ),
      ),
    );
  }

  @override
  Future load_more_data() {}

  @override
  Future refresh_data() {
    NetUtil.get(Api.USER_INFO + _userAuthModel.objectId + '/', (data) {
      UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
      userInfoModel.userInfo = userInfo;
    }, headers: {"Authorization": "Token ${_userAuthModel.session_token}"});
    NetUtil.get(Api.EARN_SUM, (data) {
      earnSumInfoBaseMode.setEarnSumData(
          data['yesterday_sum'], data['day_sum'], data['mouth_sum']);
    }, headers: {"Authorization": "Token ${_userAuthModel.session_token}"});
  }
}
