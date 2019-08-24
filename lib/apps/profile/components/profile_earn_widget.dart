import 'package:finerit_app_flutter/beans/earn_code_data_bean.dart';
import 'package:finerit_app_flutter/beans/finercode_info_data_bean.dart';

import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileEarnCard extends StatefulWidget {
  int index;
  ProfileEarnCard({key, @required this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileEarnCardState(index: index);
}

class ProfileEarnCardState extends State<ProfileEarnCard> {
  int index;
  EarnCodeData obj;
  Widget widgetAchive;
  UserAuthModel _userAuthModel;
  BaseEarnModel baseEarnModel;
  ProfileEarnCardState({key, this.index}) : super();

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
    baseEarnModel=
        ScopedModel.of<BaseEarnModel>(context, rebuildOnChange: true);
    obj=baseEarnModel.getData()[index];
    widgetAchive = new Container(
        color: Colors.white,
        child: new FlatButton(
          padding: EdgeInsets.all(10),
            onPressed: () {},
            child: Row(
              children: <Widget>[
                Align(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text(
                          obj.childUser.nickName,
                          style: TextStyle(color: Colors.black),
                        ),),
                      Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Text(
                            obj.incident,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),),
                      Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Text(
                            obj.date,
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ))
                    ],
                  ),
                  alignment: FractionalOffset.centerLeft,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      "+ ${obj.finerCode}",
                      style: TextStyle(
                          color:Colors.green,fontSize: 18
                          ),
                    ),
                  ),
                )
              ],
            )));
    return widgetAchive;
  }

}
