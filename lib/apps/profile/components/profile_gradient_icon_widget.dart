import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Profile_gradient_icon_widget extends StatelessWidget{
  IconData icon;
  Profile_gradient_icon_widget(
      {Key key,@required this.icon}
      ):super(key:key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(key: key,
      padding: EdgeInsets.only(top: 4,left: 4,bottom: 4,right: 4),
      child: new Icon(
        icon,
        size: 15,
        color: Colors.white,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: new LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.tealAccent,
              Colors.lightBlueAccent,
            ]),
      ),
    );
  }

}