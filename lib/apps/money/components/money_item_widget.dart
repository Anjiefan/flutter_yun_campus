import 'package:finerit_app_flutter/beans/finercode_info_data_bean.dart';

import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PaymentInfoCard<T extends Model> extends StatefulWidget {
  int index;

  PaymentInfoCard({key, @required this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PaymentInfoCardState<T>(index: index);
}

class PaymentInfoCardState<T extends Model> extends State<PaymentInfoCard> {
  int index;
  FinerCodeInfoData obj;
  Widget widgetAchive;
  UserAuthModel _userAuthModel;
  BaseMoneyPaymentInfoModel _moneyPaymentInfoModel;

  PaymentInfoCardState({key, this.index}) : super();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userAuthModel =
        ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
    _moneyPaymentInfoModel = ScopedModel.of<T>(context, rebuildOnChange: true)
        as BaseMoneyPaymentInfoModel;
    obj = _moneyPaymentInfoModel.getData()[index];
    widgetAchive = new Container(
        color: Colors.white,
        child: new FlatButton(
            onPressed: () {},
            child: Stack(
              children: <Widget>[
                Align(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        obj.incident,
                        style: TextStyle(color: Colors.black),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                          child: Text(
                        obj.date,
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ))
                    ],
                  ),
                  alignment: FractionalOffset.centerLeft,
                ),
                Align(
                  alignment: FractionalOffset.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      "${obj.operate} ${obj.finerCode}",
                      style: TextStyle(
                          color:
                              obj.operate == "+" ? Colors.green : Colors.black),
                    ),
                  ),
                )
              ],
            )));
    return widgetAchive;
  }

}
