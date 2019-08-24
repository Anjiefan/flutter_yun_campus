import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagePointWidget extends StatelessWidget{
  int num;
  MessagePointWidget({Key key,this.num}):super(key:key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Positioned(  // draw a red marble
      top: 0.0,
      right: 0.0,
      child:
      (num) == 0?Container():
      Container(
//        child: Center(child: Text((num) > 99?"..." :
//        (num).toString(), style: TextStyle(color: Colors.white, fontSize: 10),)),
        decoration: BoxDecoration(
            color: Color(0xff00c0ff),
            borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        width: 8,
        height: 8,
      ),
    );
  }

}