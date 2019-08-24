import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagePointWidget extends StatelessWidget{
  int num;
  MessagePointWidget({Key key,this.num}):super(key:key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return num != 0?new Container(
      child:  Center(
          child: Text(num.toString(), style: TextStyle(color: Colors.white, fontSize: 12),)
      ),
      decoration: BoxDecoration(
          color: Color(0xff00c0ff),
          borderRadius:
          BorderRadius.all(Radius.circular(30))
      ),
      margin: EdgeInsets.all(4),
      width: 15,
      height: 15,
    ): Expanded(
      child: Container(
        alignment: Alignment.centerRight,
        child: new Icon(
          Icons.navigate_next,
          size: 20,
          color: Colors.black38,
        ),
      ),
    );
  }

}