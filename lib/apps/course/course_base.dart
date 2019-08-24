import 'dart:async';
import 'dart:io';

import 'package:finerit_app_flutter/apps/course/course_education.dart';
import 'package:finerit_app_flutter/apps/course/course_guide_gather.dart';
import 'package:finerit_app_flutter/apps/course/course_search_educat.dart';
import 'package:finerit_app_flutter/apps/course/course_web.dart';
import 'package:finerit_app_flutter/apps/money/money_base.dart';
import 'package:finerit_app_flutter/apps/money/money_base_ios.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_column_widget.dart';
import 'package:finerit_app_flutter/apps/profile/profile_vip_dredge_page.dart';
import 'package:finerit_app_flutter/beans/team_info_data_list_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/dicts.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/commons/ui.dart';
import 'package:finerit_app_flutter/extra_apps/daike_animation/src/radial_menu.dart';
import 'package:finerit_app_flutter/extra_apps/daike_animation/src/radial_menu_item.dart';
import 'package:finerit_app_flutter/icons/icons_route3.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/global_config.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'course_guide.dart';
import 'package:image/image.dart' as img;
class CourseApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CourseAppState();
}
class CourseAppState extends State<CourseApp> with SingleTickerProviderStateMixin{
  static const CHANNEL_SHARE=
  const MethodChannel("com.finerit.campus/share/invoke");
  TeamBaseModel teamBaseModel;
  MainStateModel model;
  static const CHANNEL_CHAT_QQ = const MethodChannel("com.finerit.campus/chat/qq");
  static const CHANNEL_CHAT_WX = const MethodChannel("com.finerit.campus/chat/wx");
  static const CHANNEL_CHAT_WB = const MethodChannel("com.finerit.campus/chat/wb");
  Future handleCourseWeb(String url) async {
    String password=model.password;
    teamBaseModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    if(url=='https://hwapp.finerit.com/course/index/?session_token='){
      url=url+model.session_token;
      print(url);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CourseWebApp(url: url,))
      );
      GlobalConfig.menu_key.currentState.reset();
      return;
    }
    if(url=='https://finerit.com/?type=1&viptype=1&id='||url=='https://finerit.com/?type=2&viptype=1&id='){
      if(model.userInfo.vipInfo.isOpening==false){
        NetUtil.get(Api.TEAM, (data) {
          teamBaseModel.teamInfo=TeamInfo.fromJson(data);
          if(teamBaseModel.teamInfo.data.length==0||teamBaseModel.teamInfo.data[0].user.vipInfo.isOpening==false){
            showGeneralDialog(
              context: context,
              pageBuilder: (context, a, b) => AlertDialog(
                title: Text('提示',style: TextStyle(fontSize: 16),),
                content: Container(
//                          width: MediaQuery.of(context).size.width * 1,
                  child:Text("父代和子一代团队共享VIP，您和您的团队尚未开通VIP，无法进入VIP通道，点击确定前往开通"),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('取消'),
                    onPressed: () {
                      Navigator.pop(context);

                    },
                  ),
                  FlatButton(
                    child: Text('确认'),
                    onPressed: () async {
                      Widget appWidget;
                      appWidget=VIPDredgePage();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => appWidget,
                        ),
                      );
                    },
                  ),
                ],
              ),
              barrierDismissible: false,
              barrierLabel: '删除微文',
              transitionDuration: Duration(milliseconds: 400),
            );
            GlobalConfig.menu_key.currentState.reset();
            return;
          }
          else{
            NetUtil.get(Api.GET_SESSION_ID, (data) async {
              bool is_web=false;
              if(url=="https://www.finerit.com/?type=2&id="){
                is_web=true;
              }
              print(data["sessionid"]);
              url=url+data["sessionid"];
              print(url);
              GlobalConfig.menu_key.currentState.reset();
              if(is_web==true){
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              }
              else{
                NetUtil.get(Api.GET_AUTO_SESSION_ID, (data) async {
                  print(data["autosessionid"]);
                  url=url+"&aid="+data["autosessionid"];
                  print(url);
                  GlobalConfig.menu_key.currentState.reset();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CourseWebApp(url: url,))
                  );
                }, params: {'password':password },headers: {"Authorization": "Token ${model.session_token}"});

              }


            }, params: {'password':password },headers: {"Authorization": "Token ${model.session_token}"});
          }
        },
          headers: {"Authorization": "Token ${model.session_token}"},
        );

      }
      else{
        NetUtil.get(Api.GET_SESSION_ID, (data) async {
          bool is_web=false;
          if(url=="https://www.finerit.com/?type=2&id="){
            is_web=true;
          }
          print(data["sessionid"]);
          url=url+data["sessionid"];
          print(url);
          GlobalConfig.menu_key.currentState.reset();
          if(is_web==true){
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          }
          else{
            NetUtil.get(Api.GET_AUTO_SESSION_ID, (data) async {
              print(data["autosessionid"]);
              url=url+"&aid="+data["autosessionid"];
              print(url);
              GlobalConfig.menu_key.currentState.reset();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CourseWebApp(url: url,))
              );
            }, params: {'password':password },headers: {"Authorization": "Token ${model.session_token}"});

          }


        }, params: {'password':password },headers: {"Authorization": "Token ${model.session_token}"});
      }

    }
    else{
      NetUtil.get(Api.GET_SESSION_ID, (data) async {
        bool is_web=false;
        if(url=="https://www.finerit.com/?type=2&id="){
          is_web=true;
        }
        print(data["sessionid"]);
        url=url+data["sessionid"];
        print(url);
        GlobalConfig.menu_key.currentState.reset();
        if(is_web==true){
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        }
        else{
          NetUtil.get(Api.GET_AUTO_SESSION_ID, (data) async {
            print(data["autosessionid"]);
            url=url+"&aid="+data["autosessionid"];
            print(url);
            GlobalConfig.menu_key.currentState.reset();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CourseWebApp(url: url,))
            );
          }, params: {'password':password },headers: {"Authorization": "Token ${model.session_token}"});

        }


      }, params: {'password':password },headers: {"Authorization": "Token ${model.session_token}"});
    }



  }
  handle_search() async {
    String url="https://www.finerit.com/";
//    url=url+data["sessionid"];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch ${url}';
    }
  }
  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool loading=false;
  Widget _widget;
  @override
  Widget build(BuildContext context) {
    model = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);

    if(loading==false){
      _widget=Container(
        alignment: Alignment.bottomCenter,

        child: new RadialMenu(
          key: GlobalConfig.menu_key,
          items: <RadialMenuItem<String>>[
            const RadialMenuItem<String>(
              backgroundColor: Colors.white70,
              value: "https://hwapp.finerit.com/course/index/?session_token=",
              child: const IconButton(
                icon:CircleAvatar(
                    backgroundImage:AssetImage('assets/course/rengong.png'),
                    radius:40
                ),
                onPressed: null,
                iconSize: 50,
                padding:EdgeInsets.all(0),
              ),

            ),
            const RadialMenuItem<String>(
              backgroundColor: Colors.white70,
              value: "https://finerit.com/?type=1&viptype=1&id=",
              child: const IconButton(
                icon:CircleAvatar(
                    backgroundImage:AssetImage('assets/course/zhidaovip.png'),
                    radius:30
                ),
                onPressed: null,
                iconSize: 50,
                padding:EdgeInsets.all(0),
              ),

            ),
            const RadialMenuItem<String>(
              backgroundColor: Colors.white70,
              value: "https://finerit.com/?type=2&viptype=1&id=",
              child: const IconButton(
                icon:CircleAvatar(
                    backgroundImage:AssetImage('assets/course/xuexitongvip.png'),
                    radius:30
                ),
                onPressed: null,
                padding:EdgeInsets.all(0),
                iconSize: 50,
              ),

            ),
            const RadialMenuItem<String>(
              backgroundColor: Colors.white70,
              value: "https://finerit.com/?type=1&id=",
              child: const IconButton(
                icon:CircleAvatar(
                    backgroundImage:AssetImage('assets/course/zhidao.png'),
                    radius:30
                ),
                onPressed: null,
                iconSize: 50,
                padding:EdgeInsets.all(0),
              ),

            ),
            const RadialMenuItem<String>(
              backgroundColor: Colors.white70,
              value: "https://finerit.com/?type=2&id=",
              child: const IconButton(
                icon:CircleAvatar(
                    backgroundImage:AssetImage('assets/course/xuexitong.png'),
                    radius:30
                ),
                onPressed: null,
                padding:EdgeInsets.all(0),
                iconSize: 50,
              ),

            ),
//            const RadialMenuItem<String>(
//              backgroundColor: Colors.white70,
//              value: "https://www.finerit.com/?type=2&id=",
//              child: const IconButton(
//                icon:CircleAvatar(
//                    backgroundImage:AssetImage('assets/course/souti.png'),
//                    radius:30
//                ),
//                onPressed: null,
//                padding:EdgeInsets.all(0),
//                iconSize: 50,
//              ),
//
//            ),
          ],
          radius: 120.0,
          onSelected: (Object url){
            if(double.parse(model.userInfo.money)<10){
              showGeneralDialog(
                context: context,
                pageBuilder: (context, a, b) => AlertDialog(
                  title: Text('提示',style: TextStyle(fontSize: 16),),
                  content: Container(
                    child:Text("您当前凡尔币不足，只能前往体验，无法享受所有功能。"),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('前往体验'),
                      onPressed: () {
                        Navigator.pop(context);
                        handleCourseWeb(url);
                      },
                    ),
                    FlatButton(
                      child: Text('前往充值'),
                      onPressed: () async {
                        Widget appWidget;
                        if(Platform.isIOS){
                          appWidget=MoneyAppIOS(iosPayShow: model.ifshowios,);
                        }else if(Platform.isAndroid){
                          appWidget=MoneyApp();
                        }
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => appWidget,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                barrierDismissible: false,
                barrierLabel: '删除微文',
                transitionDuration: Duration(milliseconds: 400),
              );
            }
            else{
              handleCourseWeb(url);
            }


          },
        ),
      );
      if(Platform.isIOS&&model.ifshowios==false){
        _widget=Container();
      }
      loading=true;
    }

    // TODO: implement build
    return model.ifshowios==true||Platform.isAndroid?Scaffold(
      body: SingleChildScrollView(
          child: new Container(
              padding: EdgeInsets.only(top: 10),
              color: Colors.grey[100],
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProfileCommenWidget(
                    icon: MyFlutterApp3.playnext,
                    text: '使用教程',
                    callback: (){
                      _handle_guide();
                    },
                  ),
                  ProfileCommenWidget(
                    icon: MyFlutterApp3.search,
                    text: '免费搜题',
                    callback: (){
                      handle_search();
                    },
                  ),
                  ProfileCommenWidget(
                    icon: MyFlutterApp4.addfriend,
                    text: '联系站长',
                    callback: (){
                      CHANNEL_CHAT_QQ.invokeMethod("chatqq");
                    },
                  ),
                  ProfileCommenWidget(
                    icon: MyFlutterApp3.house,
                    text: '公众号',
                    callback: (){

                      handle_save_image();
                      CHANNEL_CHAT_WX.invokeMethod('chatwx');
                    },
                  ),
                  Container(height: 10,),
                  new Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Image.network('https://www.finerit.com/media/course_hint.jpg')
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Container(
//                          alignment: Alignment.center,
//                          width: MediaQuery.of(context).size.width-20,
//                          child: Text("提示：",style: TextStyle(fontWeight: FontWeight.w500),),
//                        ),
//
//                        Text("    普通通道："),
//                        Text("        支持平台：学习通/超星尔雅，智慧树/知到。"),
//                        Text("        代刷方式：手动点击，到期前往完成见面课和期末考试"),
//                        Text("    VIP通道："),
//                        Text("        支持平台：学习通/超星尔雅，智慧树/知到。"),
//                        Text("        代刷方式：提交订单，后台挂机，到期自动完成，定期检查是否出现错误（消息中会收到信息）"),
//                        Text("    人工通道："),
//                        Text("        支持平台：学习通/超星尔雅，智慧树/知到，高校邦，优学院，学堂云3.0，融e学，创就业云课堂，云课堂-智慧职校，青书学堂，中国大学MOOC。"),
//                        Text("        代刷方式：提交订单"),
//                        Container(height: 10,),
//                      Text(
//                          "        均支持刷视频、期末考试、章节测试、见面课等所有功能。"
//                      ),
////                        Text(
////                            "    使用教程及注意事项请前往代课教程"
////                            "中查看，更多问题可咨询站长，点开右上角三个点的按钮，前往联系站长。"
////                        )
//                      ],
//                    ),
                  )
                ],
              ))),

      appBar: new AppBar(
        title:  new Text("代课系统",style: TextStyle(fontSize: 20,color: Colors.black87)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: new CircleAvatar(
              backgroundImage: new NetworkImage(
                  model.userInfo.headImg),
            ),
            onPressed: () => handle_head_event(context),
          ),

        ),
        actions: <Widget>[
          Container(
            child: FlatButton.icon(onPressed: _handle_share, icon: Icon(Icons.share,color: Colors.black,), label: Text('有奖分享',style: TextStyle(color: Colors.black),),),
          )
        ],

        backgroundColor: Colors.white,

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _widget,
    ):Scaffold(
      body: Center(child: Text('当前版本暂未上线'),),
      appBar: new AppBar(
        title:  new Text("代课系统",style: TextStyle(fontSize: 20,color: Colors.black87)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: new CircleAvatar(
              backgroundImage: new NetworkImage(
                  model.userInfo.headImg),
            ),
            onPressed: () => handle_head_event(context),
          ),

        ),
//        actions: <Widget>[
//          PopupMenuButton(
//            icon: Icon(MyFlutterApp.more, color: Colors.grey[800],),
//            onSelected: (String value) {
//              handle_operate_for_chat(value);
//            },
//            itemBuilder: (BuildContext context) =>
//            <PopupMenuItem<String>>[
//              const PopupMenuItem(
//                value: "跳转微博",
//                child: Text("官方微博"),
//              ),
//              const PopupMenuItem(
//                value: "站长QQ",
//                child: Text("联系站长"),
//              ),
//            ],
//          ),
//        ],

//        title:  new TabBar(
//          tabs: <Widget>[
//            Tab(text: "代课教程"),
//            Tab(text: "搜题教程"),
//          ],
//          indicatorColor: Colors.grey[400],
//          labelColor: Colors.black,
//          unselectedLabelColor: Colors.grey[400],
//          controller: _tabController,
//        ),
        backgroundColor: Colors.white,

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _widget,
    );
  }

  String headImg = "";
  String nickName = "";

  Future handle_operate_for_chat(String value) async {
    switch(value){
      case "站长QQ":
        CHANNEL_CHAT_QQ.invokeMethod("chatqq");
        break;
      case "跳转微博":
        CHANNEL_CHAT_WB.invokeMethod("chatwb");
        break;

    }

  }
  void _handle_guide(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CourseGuide())
    );
}
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }
  Future handle_save_image() async {
    final res = await http.get('https://www.finerit.com/media/wx.png');
    final image = img.decodeImage(res.bodyBytes);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path; // 临时文件夹
    String appDocPath = appDocDir.path; // 应用文件夹

    final imageFile = File(path.join(appDocPath, 'dart.png')); // 保存在应用文件夹内
    await imageFile.writeAsBytes(img.encodePng(image)); // 需要使用与图片格式对应的encode方法
    ByteData bytes = await rootBundle.load(path.join(appDocPath, 'dart.png'));
    final result = await ImageGallerySaver.saveImage(bytes.buffer.asUint8List());
    Clipboard.setData(new ClipboardData(text: '凡尔科技'));
    requestToast('公众号二维码保存成功，可前往微信进行扫码关注');
  }
  Future _handle_share() async{
    var event=await CHANNEL_SHARE.invokeMethod("doShare",[model.objectId]);
    if(event=="-1"){
      print("转发失败");
      return ;
    }
    String task=Dicts.TASK_STARE_CHIVE[event];
    if(task==null){
      return ;
    }
    NetUtil.get(Api.SHARE, (data) {
      print(data);
      print("分享成功！");
    },
      headers: {"Authorization": "Token ${model.session_token}"},
      params: {"taskid":task},
    );
  }
}