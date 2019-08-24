import 'package:finerit_app_flutter/apps/money/components/money_item_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_earn_widget.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_jingyan_card_widget.dart';
import 'package:finerit_app_flutter/beans/earn_code_list_bean.dart';
import 'package:finerit_app_flutter/beans/experience_data_list_bean.dart';
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
class ProfileJingYanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileJingYanPageState();
}

class ProfileJingYanPageState extends PageState<ProfileJingYanPage> {
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day=DateTime.now().day;
  int sum = 0;

  BaseEarnModel baseEarnModel;
  UserAuthModel userAuthModel;
  ExperienceBaseModel experienceBaseModel;
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
      experienceBaseModel =
          ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
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
          "经验明细",
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
            itemCount: experienceBaseModel.experienceDataList.length,
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
        Api.USER_EXPERIENCE,
            (data) {
              var itemList = ExperienceDataList.fromJson(data);
              sum = itemList.sum;
              experienceBaseModel.addExperienceDataAlls(itemList.data);
          page = page + 1;
        },
        headers: {"Authorization": "Token ${userAuthModel.session_token}"},
        params: {'page': page, 'year': year, 'month': month,'day':day,'ordering':'-date'},
        );
  }

  @override
  Future refresh_data() {
    String sessionToken = userAuthModel.session_token;
    NetUtil.get(Api.USER_EXPERIENCE, (data) {
      var itemList = ExperienceDataList.fromJson(data);
      page = 2;
      loading=true;
      sum = itemList.sum;
      experienceBaseModel.experienceDataList=itemList.data;
    },
        headers: {"Authorization": "Token $sessionToken"},
        params: {'page': 1, 'year': year, 'month': month,'day':day,'ordering':'-date'},
        errorCallBack: (error) {});
  }

  Widget get_cart_wighet(int index) {
    return ProfileJingYanCard(index: index,);
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
                  "本日经验 \$${sum??0}",
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
