import 'package:finerit_app_flutter/apps/components/blank_widget.dart';
import 'package:finerit_app_flutter/apps/money/components/money_item_widget.dart';
import 'package:finerit_app_flutter/beans/finercode_info_list_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/extra_apps/flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:finerit_app_flutter/extra_apps/flutter_datetime_picker/src/i18n_model.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scoped_model/scoped_model.dart';

class MoneyDetailApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MoneyDetailAppState();
}

class MoneyDetailAppState extends PageState<MoneyDetailApp> {
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  double income = 0.0;
  double outcome = 0.0;

  BaseMoneyPaymentInfoModel moneyPaymentInfoModel;
  UserAuthModel userAuthModel;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(loading==false){
      userAuthModel =
          ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
      moneyPaymentInfoModel = ScopedModel.of<BaseMoneyPaymentInfoModel>(context,
          rebuildOnChange: true);

    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const BackButtonIcon(),
            color: Colors.grey[800],
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              Navigator.of(context).pop(true);
            }
        ),
        title: Text(
          "账单明细",
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          topFilterBar(),
          Flexible(child: handle_main_wighet()),
        ],
      ),
    );
  }

  Widget handle_main_wighet() {
    if (moneyPaymentInfoModel.getData() == null ||
        moneyPaymentInfoModel.getData().length == 0) {
      if (moneyPaymentInfoModel.initData == true) {
        return Container(
          child: new EasyRefresh(
            firstRefresh:true,
            autoLoad: true,
            key: easyRefreshKey,
            refreshHeader: MaterialHeader(
              key: headerKey,
            ),
            refreshFooter: MaterialFooter(
              key: footerKey,
            ),
            child: new ListView.builder(
                //ListView的Item
                itemCount: 0,
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Column(
                      children: <Widget>[
                        Container(
                          child: Blank(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            text: '还没有账单记录哦～',
                          ),
                        )
                      ],
                    ),
                  );
                }),
            onRefresh: () async {
              refresh_data();
            },
            loadMore: () async {
              load_more_data();
            },
          ),
        );
      }
    }
      return Container(
        child: new EasyRefresh(
          firstRefresh:true,
          autoLoad: true,
          key: easyRefreshKey,
          refreshHeader: MaterialHeader(
            key: headerKey,
          ),
          refreshFooter: MaterialFooter(
            key: footerKey,
          ),
          child: new ListView.builder(
              //ListView的Item
              itemCount: moneyPaymentInfoModel.getData()?.length??0,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Column(
                    children: <Widget>[get_cart_wighet(index)],
                  ),
                );
              }),
          onRefresh: () async {
            refresh_data();
          },
          loadMore: () async {
            load_more_data();
          },
        ),
      );

  }


  @override
  Future load_more_data() {
    NetUtil.get(
        Api.FINERCODE_INFO,
        (data) {
          var itemList = FinerCodeInfoList.fromJson(data);
          page = page + 1;
          moneyPaymentInfoModel.addAll(itemList.data);
          if(!this.mounted){
            return;
          }
          setState(() {
            income = itemList.income;
            outcome = itemList.outcome;
          });
        },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
        params: {'page': page, 'year': year, 'month': month},
        errorCallBack: (error) {
          print("error");
        });
  }

  @override
  Future refresh_data() {
    String sessionToken = userAuthModel.session_token;
    NetUtil.get(Api.FINERCODE_INFO, (data) {
      var itemList = FinerCodeInfoList.fromJson(data);
      moneyPaymentInfoModel.setData([]);
      moneyPaymentInfoModel.addAll(itemList.data);
      if(!this.mounted){
        return;
      }
      setState(
        () {
          page = 2;
          income = itemList.income;
          outcome = itemList.outcome;
          loading=true;
        },
      );
    },
        headers: {"Authorization": "Token $sessionToken"},
        params: {'page': 1, 'year': year, 'month': month},
        errorCallBack: (error) {});
  }

  Widget get_cart_wighet(int index) {
    return PaymentInfoCard<BaseMoneyPaymentInfoModel>(index: index);
  }

  void _handleDatePicker() {
    DatePicker.showDatePicker(
      context,
      isShowRightList: false,
      showTitleActions: true,
      minTime: DateTime(2000, 1, 1),
      maxTime: DateTime.now(),
      onChanged: (date) {

      },
      onConfirm: (date) {
        if(!this.mounted){
          return;
        }
        setState(() {
          year = date.year;
          month = date.month;
        });
        refresh_data();
      },
      currentTime: DateTime.now(),
      locale: LocaleType.zh,
    );
  }

  Widget topFilterBar() {
    return Container(
      height: 80,
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 40,
            child: FlatButton(
              onPressed: _handleDatePicker,
              child: Row(
                children: <Widget>[
                  Text(
                    "$year年$month月",
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
          Container(
            height: 20,
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Text(
                  "支出 \$$outcome ",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "收入 \$$income",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
