import 'package:finerit_app_flutter/apps/profile/components/profile_gradient_icon_widget.dart';
import 'package:finerit_app_flutter/icons/icons_route3.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileCommenWidget extends StatelessWidget {
  IconData icon;
  String text;
  Function callback;
  Widget message;

  ProfileCommenWidget(
      {Key key,
      @required this.icon,
      @required this.text,
      @required this.callback,
      this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        margin: EdgeInsets.only(top: 2),
        color: Colors.white,
        child: FlatButton(
          onPressed: callback,
          child: new Row(
            children: <Widget>[
              Container(
                child: Profile_gradient_icon_widget(
                  icon: icon,
                ),
                margin: EdgeInsets.only(right: 5),
              ),
              Container(
                  child: new Text(text,
                      style: new TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ))),

              message == null ? Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: new Icon(
                    Icons.navigate_next,
                    size: 20,
                    color: Colors.black38,
                  ),
                ),
              ) : message
            ],
          ),
        ));
  }
}
