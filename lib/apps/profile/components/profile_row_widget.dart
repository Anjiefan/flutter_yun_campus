import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileRowWidget extends StatelessWidget{
  Function callback;
  IconData icon;
  String text;
  ProfileRowWidget({Key key
    ,@required this.callback
    ,@required this.icon
    ,@required this.text}):super(key:key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: (){
        callback();
      },
      child: new Container(
        color: Color.fromARGB(0, 255, 255, 255),
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            Container(
              child: Icon(
                icon,
                size: 24,
                color: FineritColor.color1_normal,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top:5),
                child:
                Text(
                  text,
                  style: TextStyle(color: FineritColor.color1_normal,fontSize: 12),
                )
            )
          ],
        ),
      ),
    );
  }

}