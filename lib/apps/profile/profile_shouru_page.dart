import 'package:finerit_app_flutter/apps/money/components/money_item_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_earn_widget.dart';
import 'package:finerit_app_flutter/beans/earn_code_list_bean.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
class ProfileEarnPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileEarnPageState();
}

class ProfileEarnPageState extends PageState<ProfileEarnPage> {
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day=DateTime.now().day;
  double income = 0.0;

  BaseEarnModel baseEarnModel;
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
      baseEarnModel = ScopedModel.of<BaseEarnModel>(context,
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
        centerTitle: true,
        title: Text(
          "账单明细",
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.white,
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
            itemCount: baseEarnModel.getData()?.length??0,
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
        Api.EARN_CODEINFOS,
            (data) {
          var itemList = EarnCodeList.fromJson(data);
          page = page + 1;
          baseEarnModel.addAll(itemList.data);
          if(!this.mounted){
            return;
          }
          setState(() {
            income = itemList.income;
          });
        },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
        params: {'page': page, 'year': year, 'month': month,'day':day},
        errorCallBack: (error) {
          print("error");
        });
  }

  @override
  Future refresh_data() {
    String sessionToken = userAuthModel.session_token;
    NetUtil.get(Api.EARN_CODEINFOS, (data) {
      var itemList = EarnCodeList.fromJson(data);
      baseEarnModel.setData([]);
      baseEarnModel.addAll(itemList.data);
      if(!this.mounted){
        return;
      }
      setState(
            () {
          page = 2;
          income = itemList.income;
          loading=true;
        },
      );
    },
        headers: {"Authorization": "Token $sessionToken"},
        params: {'page': 1, 'year': year, 'month': month,'day':day},
        errorCallBack: (error) {});
  }

  Widget get_cart_wighet(int index) {
    return ProfileEarnCard(index: index,);
  }

  void _handleDatePicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      locale: 'zh',
      minYear: 1970,
      maxYear: 2999,
      initialYear: year,
      initialMonth: month,
      initialDate: day,
      cancel: Text('取消'),
      confirm: Text('确定'),
      dateFormat: 'yyyy-mm-dd',
      onChanged: (year, month, date) { },
      onConfirm: (year, month, date) {
        if(!this.mounted){
          return;
        }
        setState(() {
          this.year = year;
          this.month = month;
          this.day=date;
        });
        refresh_data();
      },
      onCancel: () { },
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
                    "$year年$month月$day日",
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
                  "本日收入 \$$income",
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
