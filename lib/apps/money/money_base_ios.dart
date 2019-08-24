import 'dart:io';

import 'package:finerit_app_flutter/apps/money/components/money_prepaid%20_num_widget.dart';
import 'package:finerit_app_flutter/apps/money/model/money_model.dart';
import 'package:finerit_app_flutter/apps/money/money_detail.dart';
import 'package:finerit_app_flutter/apps/money/money_instructions.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class MoneyAppIOS extends StatefulWidget {
  bool iosPayShow;
  MoneyAppIOS({Key key,@required this.iosPayShow}):super(key:key);
  @override
  State<StatefulWidget> createState() => MoneyAppState(iosPayShow: iosPayShow);
}

class MoneyAppState extends PageState<MoneyAppIOS> {
  bool iosPayShow;
  MoneyAppState({key,@required this.iosPayShow}):super();
  static const CHANNEL_PAYMENT_INVOKE =
  const MethodChannel("com.finerit.campus/payment/invoke");
  static const CHANNEL_PAYMENT_CONFIRM =
  const EventChannel("com.finerit.campus/payment/confirm");
  var paymentResult = "";
  var sessionToken = "";
  UserAuthModel userAuthModel;
  UserInfoModel userInfoModel;
  var _textController = new TextEditingController();
  bool loading=false;
  final Set<String> _materialsA = Set<String>();
  final Set<String> _materialsB = Set<String>();
  String _selectedMaterial = '';
  Color _nameToColor(String name) {
    return Colors.white;
  }

  String _capitalize(String name) {
    assert(name != null && name.isNotEmpty);
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }


  @override
  void initState() {
    super.initState();
    CHANNEL_PAYMENT_CONFIRM.receiveBroadcastStream().listen(_onPaymentEvent);
  }

  void _onPaymentEvent(Object event) {
    if(!this.mounted){
      return;
    }
    setState(() {
      paymentResult = event;
      print("bill_no=$paymentResult");
      if (paymentResult != "-1") {
        //充值凡尔币
        refresh_data();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_textController != null) {
      _textController.dispose();
    }
  }
  @override
  Widget build(BuildContext context) {

    if(loading==false){
      userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      userInfoModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      _textController.text=userInfoModel.userInfo.phone;
    }

    List<Widget> payDetails=[];
    if(iosPayShow==false){
      payDetails=[
        Container(
          alignment: FractionalOffset.topCenter,
          margin: EdgeInsets.only(top: 5),
          child: Text(
            "\$${userInfoModel.userInfo != null ?userInfoModel.userInfo.money:0.0}",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: FractionalOffset.topCenter,
          margin: EdgeInsets.only(top: 5),
          child: Text(
            "获取凡尔币请联系软件客服",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
      ];
    }
    else{
      payDetails=[
        Container(
          alignment: FractionalOffset.topCenter,
          margin: EdgeInsets.only(top: 5),
          child: Text(
            "\$${userInfoModel.userInfo != null ?userInfoModel.userInfo.money:0.0}",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            alignment: FractionalOffset.topCenter,
            margin: EdgeInsets.only(top: 40),
            child: MaterialButton(
              height: 30.0,
              minWidth: 150.0,
              color: FineritColor.color1_pressed,
              textColor: Colors.white,
              child: new Text("充值"),
              onPressed: () async {
                if(userInfoModel.userInfo.phone=='13000000001'){
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (context, a, b) => AlertDialog(
                      title: Text('提示',style: TextStyle(fontSize: 16),),
                      content: Container(
                        child:Text("您当前使用的是游客账号，游客账号无法进行充值和提现，您可以进行切换账号，注册专属于您自己的账号。"),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('继续使用'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text('切换账号'),
                          onPressed: () async {
                            Navigator.pop(context);
                            await userAuthModel.logout();
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/welcome", (route) => route == null);
                          },
                        ),
                      ],
                    ),
                    barrierDismissible: false,
                    barrierLabel: '切换账号',
                    transitionDuration: Duration(milliseconds: 400),
                  );
                  return;
                }
                String  url="https://hwapp.finerit.com/web/pay/?user_id=${userAuthModel.objectId}";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
//                showModalBottomSheet(
//                    context: context,
//                    builder: (BuildContext context) {
//                      return Container(
//                        height: MediaQuery.of(context).size.height * 0.5,
//                        child: Column(
//                          children: <Widget>[
//                            Stack(
//                              children: <Widget>[
//                                Padding(
//                                  padding: const EdgeInsets.all(0.0),
//                                  child: Align(
//                                    alignment: FractionalOffset.centerLeft,
//                                    child: FlatButton(
//                                      onPressed: () {
//                                        Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                            builder: (context) => MoneyInstructionApp(),
//                                          ),
//                                        );
//                                      },
//                                      child: Text("用途"),
//                                    ),
//                                  ),
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.all(14.0),
//                                  child: Align(
//                                    alignment: FractionalOffset.center,
//                                    child: Text("凡尔币充值"),
//                                  ),
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.all(0.0),
//                                  child: Align(
//                                    alignment: FractionalOffset.centerRight,
//                                    child: FlatButton(
//                                        onPressed: () {
//                                          Navigator.pop(context);
//                                        },
//                                        child: Text("取消")),
//                                  ),
//                                ),
//                              ],
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Container(
//                                child: Text(
//                                  "充值金额仅限凡尔APP使用",
//                                  style: TextStyle(color: Colors.grey[400]),
//                                ),
//                              ),
//                            ),
//                            new Container(
//                              height:
//                              MediaQuery.of(context).size.height * 0.15,
//                              child: Row(
//                                mainAxisAlignment:
//                                MainAxisAlignment.spaceEvenly,
//                                children: <Widget>[
//                                  MoneyPrepaidNumWidget(
//                                    finerCode: 25,
//                                  ),
//                                  MoneyPrepaidNumWidget(
//                                    finerCode: 50,
//                                  ),
//                                  MoneyPrepaidNumWidget(
//                                    finerCode: 100,
//                                  ),
//                                ],
//                              ),
//                            ),
//                            new Container(
//                              height:
//                              MediaQuery.of(context).size.height * 0.15,
//                              child: Row(
//                                mainAxisAlignment:
//                                MainAxisAlignment.spaceEvenly,
//                                children: <Widget>[
//                                  MoneyPrepaidNumWidget(
//                                    finerCode: 200,
//                                  ),
//                                  MoneyPrepaidNumWidget(
//                                    finerCode: 500,
//                                  ),
//                                  MoneyPrepaidNumWidget(
//                                    finerCode: 1000,
//                                  ),
//                                ],
//                              ),
//                              margin: EdgeInsets.only(top: 5),
//                            ),
//                            Container(
//                              child: Row(
//                                children: <Widget>[],
//                              ),
//                            ),
//                          ],
//                        ),
//                      );
//                    });
              },
            )),
        Container(
            alignment: FractionalOffset.topCenter,
            margin: EdgeInsets.only(top: 5),
            child: MaterialButton(
              height: 30.0,
              minWidth: 150.0,
              color: Colors.grey[200],
              child: new Text("提现"),
              onPressed: _handle_alypay,
            )),
      ];
    }

    Widget body=Column(
      children: <Widget>[
        Container(
          alignment: FractionalOffset.topCenter,
          margin: EdgeInsets.only(top: 30),
          child: Icon(
            MyFlutterApp.money,
            size: 72,
            color: Colors.amber,
          ),
        ),
        Container(
          alignment: FractionalOffset.topCenter,
          margin: EdgeInsets.only(top: 10),
          child: Text(
            "我的凡尔币",
            style: TextStyle(fontSize: 16),
          ),
        ),

      ]..addAll(payDetails),
    );
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.grey[800],
        ),
        centerTitle: true,
        actions: <Widget>[
          Platform.isIOS&&userAuthModel.ifshowios==false?Container():FlatButton(
            child: Text("账单明细"),
            onPressed: _handleAccountDetail,
          )
        ],
        title: Text(
          "我的钱包",
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.white,
      ),
      body: EasyRefresh(
        firstRefresh:true,
        key: easyRefreshKey,
        refreshHeader: MaterialHeader(
          key: headerKey,
        ),
        refreshFooter: MaterialFooter(
          key: footerKey,
        ),
        child:  body,
        onRefresh: ()  {
          refresh_data();
        },
        loadMore: ()  {
          load_more_data();
        },
      ),
    );
  }

  void _handle_alypay(){
    showGeneralDialog(
      context: context,
      pageBuilder: (context, a, b) => AlertDialog(
        title: Text('输入提现的支付宝账户'),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: (MediaQuery.of(context).size.height / 2) * 0.3,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              new Theme(
                data: ThemeData(
                  hintColor: Colors.black26,
                ),
                child:
                new Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width*1,
                  child:TextField(
                    controller: _textController,
                    autofocus: true,
                    cursorColor:Colors.black26,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: "输入支付宝账号...",
                      errorBorder:UnderlineInputBorder(
                        borderSide:
                        BorderSide( width: 0.5,color: Colors.black26),

                      ),
                      disabledBorder:UnderlineInputBorder(
                        borderSide:
                        BorderSide( width: 0.5,color: Colors.black26),

                      ),
                      enabledBorder:UnderlineInputBorder(
                        borderSide:
                        BorderSide( width: 0.5,color: Colors.black26),

                      ),
                      focusedBorder:UnderlineInputBorder(
                        borderSide:
                        BorderSide( width: 0.8,color: Colors.black26),

                      ),
                      border:UnderlineInputBorder(
                        borderSide:
                        BorderSide(width: 0.5,color: Colors.black26),

                      ),
                    ),
                    style:TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
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

              if (_textController.text == '') {
                requestToast('请输入提现的支付宝账户');
                return;
              }
              _handleWithDraw(_textController.text);
              Navigator.pop(context);

            },
          ),
        ],
      ),
      barrierDismissible: false,
      barrierLabel: '提现',
      transitionDuration: Duration(milliseconds: 400),
    );
  }
  void _handleWithDraw(username) {
    NetUtil.post(
      Api.WITHDRAW_URL,
          (data) {
        if(!this.mounted){
          return;
        }
        setState(() {
          userInfoModel.userInfo.money=data["money"];
        });
        requestToast(data['info']);
      },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      params: {
        "alipay_user_account": username
      },
    );
  }


  Future initMoneyInfo() async {
    NetUtil.get(Api.USER_INFO+userAuthModel.objectId+'/', (data) {
      UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
      userInfoModel.userInfo=userInfo;
      loading=true;
    }, headers: {"Authorization": "Token ${userAuthModel.session_token}"});
  }

  void _handleAccountDetail() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ScopedModel<BaseMoneyPaymentInfoModel>(
                  child:  MoneyDetailApp(),
                  model: MoneyPaymentInfoModel(),
                )
        ));
  }

  @override
  Future load_more_data() {
    // TODO: implement load_more_data
    return null;
  }

  @override
  Future refresh_data() {
    NetUtil.get(Api.USER_INFO+userAuthModel.objectId+'/', (data) {
      UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
      userInfoModel.userInfo=userInfo;
      loading=true;
    }, headers: {"Authorization": "Token ${userAuthModel.session_token}"});
  }
}


