import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeBaseButtonWidget extends StatelessWidget {
  Function callback;
  Future<dynamic> asynCallBack;
  String text;
  Color bottonColor;
  WelcomeBaseButtonWidget({Key key
    , this.text
    , this.callback
    ,this.asynCallBack
    ,this.bottonColor=FineritColor.login_button
    ,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(text);
    return new Container(
      width: 120,
      height: 35,
      margin: EdgeInsets.only(top: 40),
      child: InkWell(
        onTap: () {
          if(callback!=null){
            callback();
          }
          else if(asynCallBack!=null){
            asynCallBack.then((_) {
              print('asyn ok');
            });
          }
        },
        child: new Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(4.0), //只是为了给 Text 加一个内边距，好看点~
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 16.0),
          ),
          decoration: BoxDecoration(
            color:bottonColor,
            boxShadow:
            [BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 0),
                blurRadius: 6.0,
                spreadRadius: 2.0),],
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
    );
  }
}
