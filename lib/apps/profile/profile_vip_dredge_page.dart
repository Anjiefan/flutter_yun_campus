import 'dart:io';

import 'package:finerit_app_flutter/apps/components/vip_discript_widget.dart';
import 'package:finerit_app_flutter/apps/money/money_base.dart';
import 'package:finerit_app_flutter/apps/money/money_base_ios.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_svip_icon.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/beans/vip_pay_info_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'components/profile_horizontal_divider_widget.dart';
import 'components/proflie_vip_icon.dart';

class VIPDredgePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>VIPDredgePageState();
}

class VIPDredgePageState extends State<VIPDredgePage>{
  bool vipType = false;
  var finB=0.0;
  UserAuthModel userAuthModel;
  UserInfoModel userInfoModel;
  VipPayBaseModel vipPayBaseModel;
  bool loading=false;
  void _change_type(bool type){
    if(type==false){
      finB=vipPayBaseModel.vipPayInfo?.realMonthPay??0.0;
    }
    else{
      finB=vipPayBaseModel.vipPayInfo?.realYearPay??0.0;
    }
    setState(() {
      vipType=type;
      finB;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    userAuthModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    userInfoModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    vipPayBaseModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    if(loading==false){
      loadVipPayData();
      loading=true;
    }
    return Scaffold(
//      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.grey[800],
        ),
        title: Text("开通会员", style: TextStyle(color: Colors.grey[800]),),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body:
      Column(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(top: 10,bottom: 5),
            child:
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(userInfoModel.userInfo.headImg),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(width: 0.0,),
                      ),
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
                              margin: EdgeInsets.only(top: 5),
                              child:
                              new Row(
                                children: <Widget>[
                                  Text(userInfoModel.userInfo.nickName,style: TextStyle(color: Colors.black, fontSize: 14)),
                                  Container(
                                    margin: EdgeInsets.only(left: 5,top: 3),
                                    child:  VipDiscriptWidget(levelDesignation: userInfoModel.userInfo.vipInfo.levelDesignation
                                      ,isAnnual: userInfoModel.userInfo.vipInfo.isAnnual,isOpening: userInfoModel.userInfo.vipInfo.isOpening,),
                                  ),
                                ],
                              )
                          ),
                          Row(
                            children: <Widget>[
                              new Container(
                                margin: EdgeInsets.only(top: 10),
                                child: new Row(
                                  children: <Widget>[
                                    Icon(
                                      FineritIcons.money,
                                      size: 14,
                                      color: Colors.black54,
                                    ),
                                    Container(width: 2,),
                                    Text(userInfoModel.userInfo.money.toString(),style: TextStyle(color: Colors.black54,),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                new Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20,right: 10),
                          child:new Text('${vipPayBaseModel.vipPayInfo?.userVipInfo??''}',style: TextStyle(color: Colors.black54,fontSize: 14)),
                        ),
                      ],
                    )
                )
              ],
            ),
          ),
          HorizontalDivider(width:MediaQuery.of(context).size.width),
          new Container(
            child:Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/profile/base/monthVip.png'),
                            width: 80,
                            height: 80,
                          ),
                          Text("开通1个月vip",style: TextStyle(fontSize: 18),),
                          new GestureDetector(
                            onTap: (){
                              _change_type(false);
                            },
                            child: new Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 100,
                              height: 130,
                              decoration: vipType==false?new BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 4.0,
                                    blurRadius: 5.0,
                                  )],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey[300],
                                    width: 1,
                                    style: BorderStyle.solid,
                                  )
                              ):BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey[300],
                                    width: 1,
                                    style: BorderStyle.solid,
                                  )
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text("1个月",style: TextStyle(fontSize: 16),),
                                  Container(
                                    child: Divider(color: Colors.black45,height: 10,),
                                  ),
                                  Text('${vipPayBaseModel.vipPayInfo?.realMonthPay??0.0}'
                                      ,style: TextStyle(fontSize: 30)),
                                  Text("原价：${vipPayBaseModel.vipPayInfo?.monthPay??0.0}"
                                      ,style: TextStyle(fontSize: 15,color: Colors.black38,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.black38,)),
                                  Text("凡尔币"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/profile/base/yearVip.png'),
                            width: 80,
                            height: 80,
                          ),
                          Text("开通1年vip",style: TextStyle(fontSize: 18),),
                          new GestureDetector(
                            onTap: (){
                              _change_type(true);
                            },
                            child: new Container(
                              margin: EdgeInsets.only(top: 10),
                              width: 100,
                              height: 130,
                              decoration: vipType?new BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 4.0,
                                    blurRadius: 5.0,
                                  )],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey[300],
                                    width: 1,
                                    style: BorderStyle.solid,
                                  )
                              ):BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey[300],
                                    width: 1,
                                    style: BorderStyle.solid,
                                  )
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text("1年",style: TextStyle(fontSize: 16),),
                                  Container(
                                    child: Divider(color: Colors.black45,height: 10,),
                                  ),
                                  Text('${vipPayBaseModel.vipPayInfo?.realYearPay??0.0}'
                                      ,style: TextStyle(fontSize: 30)),
                                  Text("原价：${vipPayBaseModel.vipPayInfo?.yearPay??0.0}"
                                      ,style: TextStyle(fontSize: 15,color: Colors.black38,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.black38,)),
                                  Text("凡尔币"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                new Container(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('${vipPayBaseModel.vipPayInfo?.activity??''}',style: TextStyle(color: Colors.redAccent,fontSize: 15),),
          ),
          new Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                new GestureDetector(
                  child: new Container(
                    margin: EdgeInsets.only(left: 45),
                    padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 3),
                    child: Text("充值凡尔币",style: TextStyle(fontSize: 20,color: Colors.black45)),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300],style: BorderStyle.solid,width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onTap: (){
                    _handle_money_nav();
                  },
                ),
                new Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new GestureDetector(
                          onTap: (){
                            handle_to_pay();
                          },
                          child: new Container(
                            padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 3),
                            child: Text("立刻支付:"+finB.toString(),style: TextStyle(fontSize: 20,color: Colors.white),),
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        )

                      ],
                    )
                )
              ],
            ),
          ),
          new Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(left: 10,bottom: 10),
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("提示",style:TextStyle(fontWeight: FontWeight.w500)),
                    Container(child:Divider(color: Colors.grey[300],height: 10,)),
                    Text("1.累计充值1个月到vip1，2个月到vip2......以此类推。"),
                    Text("2.年费vip，直升vip12，赠送9万用户经验，同时用户等级升至 博一。"),
                    Text("3.vip在团队之间特权共享，拥有vip的用户更容易吸引队员哦。"),
                  ],
                ),
              ))
        ],
      ),
    );
  }
  void loadVipPayData(){
    NetUtil.get(Api.VIP_PAYINFO, (data) {
      VipPayInfo vipPayInfo=VipPayInfo.fromJson(data);
      finB=vipPayInfo.realMonthPay;
      vipPayBaseModel.vipPayInfo=vipPayInfo;
    },
      headers: {"Authorization": "Token ${userAuthModel.session_token}"},
    );
  }
  void _handle_money_nav() {
    Widget appWidget;
    if(Platform.isIOS){
      appWidget=MoneyAppIOS(iosPayShow: userAuthModel.ifshowios,);
    }else if(Platform.isAndroid){
      appWidget=MoneyApp();
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => appWidget,
      ),
    );
  }
  void handle_to_pay(){
    if(double.parse(userInfoModel.userInfo.money)<finB){
      requestToast('余额不足，请前往充值');
      return;
    }
    showGeneralDialog(
      context: context,
      pageBuilder: (context, a, b) => AlertDialog(
        title: Text('开通VIP',style: TextStyle(fontSize: 16),),
        content: Container(
          child: Container(
            child: Text("开通此类型VIP将要扣除${finB}凡尔币，确定开通吗？"),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('取消'),
            onPressed: () {
              requestToast('取消开通，开通VIP将拥有更多特权哦～');
              Navigator.pop(context);

            },
          ),
          FlatButton(
            child: Text('确认'),
            onPressed: () async {
              handle_to_start_vip_lift();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      barrierDismissible: false,
      barrierLabel: '开通VIP',
      transitionDuration: Duration(milliseconds: 400),
    );
  }
  void handle_to_start_vip_lift(){
    if(this.vipType==false){
      NetUtil.get(Api.OPEN_VIP, (data) {
        requestToast(data['info']);
        NetUtil.get(Api.USER_INFO+userAuthModel.objectId+'/', (data) {
          UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
          userInfoModel.userInfo=userInfo;
        }, headers: {"Authorization": "Token ${userAuthModel.session_token}"});
      },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      );
    }
    else{
      NetUtil.get(Api.OPEN_ANNUAL_VIP, (data) {
        requestToast(data['info']);
        NetUtil.get(Api.USER_INFO+userAuthModel.objectId+'/', (data) {
          UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
          userInfoModel.userInfo=userInfo;
        }, headers: {"Authorization": "Token ${userAuthModel.session_token}"});
      },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
      );
    }

  }
}